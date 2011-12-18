/*
 * Copyright 2011 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.codehaus.griffon.portal.api

import griffon.portal.util.MD5
import groovy.json.JsonException
import groovy.json.JsonSlurper
import java.util.zip.ZipEntry
import java.util.zip.ZipFile
import org.codehaus.groovy.grails.web.context.ServletContextHolder
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import griffon.portal.*

/**
 * @author Andres Almiray
 */
class ArtifactProcessorImpl implements ArtifactProcessor {
    private static final Logger LOG = LoggerFactory.getLogger(ArtifactProcessorImpl)

    void process(ArtifactInfo artifactInfo) throws IOException {
        boolean handled = false
        for (artifact in ['plugin', 'archetype']) {
            ZipEntry artifactEntry = artifactInfo.zipFile.getEntry(artifact + '.json')
            if (artifactEntry) {
                handled = true
                handle(artifactInfo, artifact, artifactEntry)
                break
            }
        }

        if (!handled) {
            throw new IOException('Not a valid griffon artifact')
        }
    }

    private void handle(ArtifactInfo artifactInfo, String artifactType, ZipEntry artifactEntry) {
        def json = null
        try {
            json = new JsonSlurper().parseText(artifactInfo.zipFile.getInputStream(artifactEntry).text)
        } catch (JsonException e) {
            throw new IOException("Release of ${artifactType}::${artifactInfo.artifactName}-${artifactInfo.artifactVersion} failed => $e", e)
        }
        if (artifactType != json.type) {
            throw new IOException("Artifact type is '${json.type}' but expected type is '${artifactType}'")
        }
        if (artifactInfo.artifactName != json.name) {
            throw new IOException("Artifact name is '${json.name}' but expected name is '${artifactInfo.artifactName}'")
        }
        if (artifactInfo.artifactVersion != json.version) {
            throw new IOException("Artifact version is '${json.version}' but expected version is '${artifactInfo.artifactVersion}'")
        }

        try {
            switch (artifactType) {
                case 'plugin':
                    verifyArtifact(artifactInfo.zipFile, json)
                    withTransaction {
                        handlePlugin(json)
                        writeActivity(artifactInfo, json)
                    }
                    break
                case 'archetype':
                    verifyArtifact(artifactInfo.zipFile, json)
                    withTransaction {
                        handleArchetype(json)
                        writeActivity(artifactInfo, json)
                    }
            }
        } catch (Exception e) {
            throw new IOException("Release of ${artifactType}::${artifactInfo.artifactName}-${artifactInfo.artifactVersion} failed => $e", e)
        }
    }

    private void withTransaction(Closure callback) throws IOException {
        Artifact.withTransaction { status ->
            try {
                callback()
            } catch (IOException e) {
                status.setRollbackOnly()
                throw e
            }
        }
    }

    private void verifyArtifact(ZipFile zipFile, json) {
        String fileName = "griffon-${json.name}-${json.version}.zip"
        ZipEntry artifactFileEntry = zipFile.getEntry(fileName)
        ZipEntry md5ChecksumEntry = zipFile.getEntry("${fileName}.md5")

        if (artifactFileEntry == null) {
            throw new IOException("Release does not contain expected zip entry ${fileName}")
        }
        if (md5ChecksumEntry == null) {
            throw new IOException("Release does not contain expected zip entry ${fileName}.md5")
        }

        byte[] bytes = zipFile.getInputStream(artifactFileEntry).bytes
        String computedHash = MD5.encode(bytes)
        String releaseHash = zipFile.getInputStream(md5ChecksumEntry).text

        if (computedHash.trim() != releaseHash.trim()) {
            throw new IOException("Wrong checksum for ${fileName}")
        }

        String basePath = "/WEB-INF/releases/${json.type}/${json.name}/${json.version}/"
        String releaseFilePath = ServletContextHolder.servletContext.getRealPath("${basePath}${fileName}")
        String md5ChecksumPath = ServletContextHolder.servletContext.getRealPath("${basePath}${fileName}.md5")
        new File(releaseFilePath).getParentFile().mkdirs()
        OutputStream os = new FileOutputStream(releaseFilePath)
        os.bytes = zipFile.getInputStream(artifactFileEntry).bytes
        os = new FileOutputStream(md5ChecksumPath)
        os.bytes = zipFile.getInputStream(md5ChecksumEntry).bytes

        json.checksum = zipFile.getInputStream(md5ChecksumEntry).text
    }

    private void handlePlugin(json) {
        Plugin plugin = Plugin.findByName(json.name)
        if (!plugin) {
            plugin = new Plugin(name: json.name)
        }
        plugin.with {
            title = json.title
            description = json.description
            license = json.license
            toolkits = json.toolkits.join(',')
            platforms = json.platforms.join(',')
            dependencies = json.dependencies.inject([:]) {m, dep ->
                m[dep.name] = dep.version
                m
            }
        }

        handleAuthors(plugin, json)
        plugin.save()
        makeRelease(plugin, json)

        // unpack docs (if any)
    }

    private void handleArchetype(json) {
        Archetype archetype = Archetype.findByName(json.name)
        if (!archetype) {
            archetype = new Archetype(name: json.name)
        }
        archetype.with {
            title = json.title
            description = json.description
            license = json.license
        }

        handleAuthors(archetype, json)
        archetype.save()
        makeRelease(archetype, json)

        // unpack docs (if any)
    }

    private void handleAuthors(Artifact artifact, json) {
        json.authors.each {data ->
            Author author = Author.findByEmail(data.email)
            if (!author) {
                author = new Author(
                        name: data.name,
                        email: data.email
                )
            }
            if (!artifact.authors?.contains(author)) {
                artifact.addToAuthors(author)
            }
        }
    }

    private void makeRelease(Artifact pArtifact, json) {
        Release release = Release.withCriteria(uniqueResult: true) {
            and {
                eq("artifactVersion", json.version)
                artifact {
                    eq("name", pArtifact.name)
                }
            }
        }
        if (!release) {
            release = new Release(
                    artifactVersion: json.version)
        }
        release.with {
            griffonVersion = json.griffonVersion
            comment = json.comment
            checksum = json.checksum
            artifact = pArtifact
        }
        release.save()
    }

    private void writeActivity(ArtifactInfo artifactInfo, json) {
        new Activity(
                username: artifactInfo.username,
                eventType: artifactInfo.eventType,
                event: [type: json.type, name: json.name, version: json.version].toString()
        ).save()
    }
}
