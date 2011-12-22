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

import grails.plugin.executor.PersistenceContextExecutorWrapper
import grails.util.GrailsNameUtils
import grails.util.GrailsUtil
import griffon.portal.util.MD5
import groovy.json.JsonException
import groovy.json.JsonSlurper
import groovy.text.SimpleTemplateEngine
import groovy.transform.Synchronized
import java.util.zip.ZipEntry
import java.util.zip.ZipFile
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.codehaus.groovy.grails.web.context.ServletContextHolder
import org.grails.mail.MailService
import org.pegdown.PegDownProcessor
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.twitter4j.grails.plugin.Twitter4jService
import griffon.portal.*

/**
 * @author Andres Almiray
 */
class ArtifactProcessorImpl implements ArtifactProcessor {
    private static final Logger LOG = LoggerFactory.getLogger(ArtifactProcessorImpl)

    private Twitter4jService twitter4jService
    GrailsApplication grailsApplication
    PersistenceContextExecutorWrapper executorService
    MailService mailService

    void process(ArtifactInfo artifactInfo) throws IOException {
        for (artifact in ['plugin', 'archetype']) {
            ZipEntry artifactEntry = artifactInfo.zipFile.getEntry(artifact + '.json')
            if (artifactEntry) {
                handle(artifactInfo, artifact, artifactEntry)
                return
            }
        }

        throw new IOException('Not a valid griffon artifact')
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
                        handlePlugin(artifactInfo, json)
                        writeActivity(artifactInfo, json)
                    }
                    break
                case 'archetype':
                    verifyArtifact(artifactInfo.zipFile, json)
                    withTransaction {
                        handleArchetype(artifactInfo, json)
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
        ZipEntry releaseNotesEntry = zipFile.getEntry("release_notes.md")

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
        if (releaseNotesEntry != null) {
            String releaseNotesPath = ServletContextHolder.servletContext.getRealPath("${basePath}/README.md")
            os = new FileOutputStream(releaseNotesPath)
            os.bytes = zipFile.getInputStream(releaseNotesEntry).bytes
            String formattedReleaseNotesPath = ServletContextHolder.servletContext.getRealPath("${basePath}/README.html")
            new File(formattedReleaseNotesPath).text = new PegDownProcessor().markdownToHtml(zipFile.getInputStream(releaseNotesEntry).text)
            json.releaseNotes = true
        }
    }

    private void handlePlugin(ArtifactInfo artifactInfo, json) {
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
        makeRelease(artifactInfo, plugin, json)
    }

    private void handleArchetype(ArtifactInfo artifactInfo, json) {
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
        makeRelease(artifactInfo, archetype, json)
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

    private void makeRelease(ArtifactInfo artifactInfo, Artifact pArtifact, json) {
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
            releaseNotes = json.releaseNotes ?: false
        }
        release.save()

        try {
            if (grailsApplication.config.twitter.enabled) {
                String url = "http://${grailsApplication.config.grails.serverURL}/${json.type}/${json.name}"
                getTwitter4jService().updateStatus("#griffon $json.name $json.version released $url")
            }
        } catch (Exception e) {
            LOG.error("Could not update Twitter status for ${json.name}-${json.version}", e)
        }

        Watcher watcher = Watcher.findByArtifact(pArtifact)
        if (watcher?.users) {
            List users = watcher.users.collect([]) { User user ->
                [username: user.username, email: user.email]
            }
            String serverURL = grailsApplication.config.serverURL
            SimpleTemplateEngine engine = new SimpleTemplateEngine()
            def template = engine.createTemplate(grailsApplication.config.template.release.posted.toString())
            executorService.withoutPersistence {
                users.each { user ->
                    try {
                        mailService.sendMail {
                            to user.email
                            subject "[ANN] ${GrailsNameUtils.getNaturalName(json.type)} ${json.name}-${json.version} released"
                            html template.make(
                                    serverURL: serverURL,
                                    capitalizedType: GrailsNameUtils.getNaturalName(json.type),
                                    capitalizedName: GrailsNameUtils.getNaturalName(json.name),
                                    name: json.name,
                                    version: json.version,
                                    type: json.type,
                                    poster: artifactInfo.username,
                                    username: user.username
                            ).toString()
                        }
                    } catch (Exception e) {
                        LOG.error("An error ocurred while sending release update (${json.name}-${json.version}) to ${user.email} (${user.username})", GrailsUtil.sanitize(e))
                    }
                }
            }
        }
    }

    @Synchronized
    private Twitter4jService getTwitter4jService() {
        if (twitter4jService == null) {
            twitter4jService = grailsApplication.mainContext.twitter4jService
        }
        twitter4jService
    }

    private void writeActivity(ArtifactInfo artifactInfo, json) {
        new Activity(
                username: artifactInfo.username,
                eventType: artifactInfo.eventType,
                event: [type: json.type, name: json.name, version: json.version].toString()
        ).save()
    }
}
