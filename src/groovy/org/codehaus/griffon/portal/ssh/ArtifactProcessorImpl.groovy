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

package org.codehaus.griffon.portal.ssh

import groovy.json.JsonException
import groovy.json.JsonSlurper
import java.util.zip.ZipEntry
import java.util.zip.ZipFile
import org.apache.sshd.server.SshFile
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import griffon.portal.*

/**
 * @author Andres Almiray
 */
class ArtifactProcessorImpl implements ArtifactProcessor {
    private static final Logger LOG = LoggerFactory.getLogger(ArtifactProcessorImpl)

    void process(SshFile file, String artifactName, String artifactVersion) throws IOException {
        ZipFile zipFile = new ZipFile(file.getAbsolutePath())

        boolean handled = false
        for (artifact in ['plugin', 'archetype']) {
            ZipEntry artifactEntry = zipFile.getEntry(artifact + '.json')
            if (artifactEntry) {
                handled = true
                handle(zipFile, artifactEntry, artifact, artifactName, artifactVersion)
                break
            }
        }

        if (!handled) {
            throw new IOException('Not a valid griffon artifact')
        }
    }

    private void handle(ZipFile zipFile, ZipEntry artifactEntry, String artifactType, String artifactName, String artifactVersion) {
        def json = null
        try {
            json = new JsonSlurper().parseText(zipFile.getInputStream(artifactEntry).text)
        } catch (JsonException e) {
            throw new IOException("Release of ${artifactType}::${artifactName}-${artifactVersion} failed => $e", e)
        }
        if (artifactType != json.type) {
            throw new IOException("Artifact type is '${json.type}' but expected type is '${artifactType}'")
        }
        if (artifactName != json.name) {
            throw new IOException("Artifact name is '${json.name}' but expected name is '${artifactName}'")
        }
        if (artifactVersion != json.version) {
            throw new IOException("Artifact version is '${json.version}' but expected version is '${artifactVersion}'")
        }

        try {
            switch (artifactType) {
                case 'plugin':
                    withTransaction {
                        handlePlugin(zipFile, json)
                    }
                    break
                case 'archetype':
                    withTransaction {
                        handleArchetype(zipFile, json)
                    }
            }
        } catch (Exception e) {
            throw new IOException("Release of ${artifactType}::${artifactName}-${artifactVersion} failed => $e", e)
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

    private void handlePlugin(ZipFile zipFile, json) {
        Plugin plugin = new Plugin(
                name: json.name,
                title: json.title,
                description: json.description,
                license: json.license,
                toolkits: json.toolkits.join(','),
                platforms: json.platforms.join(',')
        )
        json.authors.each {data ->
            Author author = Author.findByEmail(data.email)
            if (!author) {
                author = new Author(
                        name: data.name,
                        email: data.email
                )
            }
            plugin.addToAuthors(author)
        }

        plugin.save()
        makeRelease(plugin, json)

        // unpack artifact zip to download area
        // unpack docs (if any)
    }

    private void handleArchetype(ZipFile zipFile, json) {
        Archetype archetype = new Archetype(
                name: json.name,
                title: json.title,
                description: json.description,
                license: json.license,
        )
        json.authors.each {data ->
            Author author = Author.findByEmail(data.email)
            if (!author) {
                author = new Author(
                        name: data.name,
                        email: data.email
                )
            }
            archetype.addToAuthors(author)
        }

        archetype.save()
        makeRelease(archetype, json)

        // unpack artifact zip to download area
        // unpack docs (if any)
    }

    private void makeRelease(Artifact artifact, json) {
        Release release = new Release(
                artifactVersion: json.version,
                griffonVersion: json.griffonVersion,
                comment: json.comment,
                artifact: artifact
        )
        release.save()
    }
}
