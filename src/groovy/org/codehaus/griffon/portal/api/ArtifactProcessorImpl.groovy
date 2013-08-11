/*
 * Copyright 2011-2013 the original author or authors.
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

import griffon.portal.*
import griffon.portal.util.MD5
import groovy.json.JsonException
import groovy.json.JsonSlurper
import groovy.xml.MarkupBuilder
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.pegdown.PegDownProcessor
import org.slf4j.Logger
import org.slf4j.LoggerFactory

import java.util.zip.ZipEntry
import java.util.zip.ZipFile

import static griffon.portal.values.PreferenceKey.*
import static griffon.util.ConfigUtils.getConfigValueAsBoolean

/**
 * @author Andres Almiray
 */
class ArtifactProcessorImpl implements ArtifactProcessor {
    private static final Logger LOG = LoggerFactory.getLogger(ArtifactProcessorImpl)

    NotifyService notifyService
    PreferencesService preferencesService
    GrailsApplication grailsApplication
    StatsService statsService

    void process(ArtifactInfo artifactInfo) throws IOException {
        for (artifactType in ['plugin', 'archetype']) {
            ZipEntry artifactEntry = artifactInfo.zipFile.getEntry(artifactType + '.json')
            if (artifactEntry) {
                handle(artifactInfo, artifactType, artifactEntry)
                return
            }
        }
        artifactInfo.file.delete()

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

        boolean allowSnapshots = getConfigValueAsBoolean(grailsApplication.config, "allow.snapshots", true)
        if (artifactInfo.artifactVersion.endsWith('-SNAPSHOT') && !allowSnapshots) {
            throw new IOException("Snapshot releases are currently disabled")
        }

        try {
            switch (artifactType) {
                case 'plugin':
                    verifyArtifact(artifactInfo, json)
                    withTransaction {
                        handlePlugin(artifactInfo, json)
                    }
                    break
                case 'archetype':
                    verifyArtifact(artifactInfo, json)
                    withTransaction {
                        handleArchetype(artifactInfo, json)
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

    private void verifyArtifact(ArtifactInfo artifactInfo, json) {
        ZipFile zipFile = artifactInfo.zipFile
        String releaseFileName = "griffon-${json.name}-${json.version}-release.zip"
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
        String packageHash = zipFile.getInputStream(md5ChecksumEntry).text

        if (computedHash.trim() != packageHash.trim()) {
            throw new IOException("Wrong checksum for ${fileName}")
        }

        String packagesStoreDir = preferencesService.getValueOf(PACKAGES_STORE_DIR)
        String basePath = "${packagesStoreDir}/${json.type}/${json.name}/${json.version}/"
        String packageFilePath = "${basePath}${fileName}"
        String md5ChecksumPath = "${basePath}${fileName}.md5"
        new File(packageFilePath).getParentFile().mkdirs()
        OutputStream os = new FileOutputStream(packageFilePath)
        os.bytes = zipFile.getInputStream(artifactFileEntry).bytes
        os = new FileOutputStream(md5ChecksumPath)
        os.bytes = zipFile.getInputStream(md5ChecksumEntry).bytes

        json.checksum = zipFile.getInputStream(md5ChecksumEntry).text
        if (releaseNotesEntry != null) {
            String formattedReleaseNotesPath = "${basePath}/README.html"
            new File(formattedReleaseNotesPath).text = new PegDownProcessor().markdownToHtml(zipFile.getInputStream(releaseNotesEntry).text)
            json.releaseNotes = zipFile.getInputStream(releaseNotesEntry).text
        }

        String releasesStoreDir = preferencesService.getValueOf(RELEASES_STORE_DIR)
        basePath = "${releasesStoreDir}/${json.type}/${json.name}/${json.version}/"
        String releaseFilePath = "${basePath}${releaseFileName}"
        File packageFile = new File(releaseFilePath)
        packageFile.getParentFile().mkdirs()
        os = new FileOutputStream(releaseFilePath)
        os.bytes = artifactInfo.file.bytes
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
            source = json.source
            documentation = json.documentation
            // groupId = json.group ?: Plugin.DEFAULT_GROUP
            toolkits = json.toolkits.join(',')
            platforms = json.platforms.join(',')
            framework = json.framework ?: false
        }

        handleAuthors(plugin, json)
        plugin.save()
        makeRelease(artifactInfo, plugin, json)
        // makeMavenArtifacts(plugin, json)
    }

    /*
    private void makeMavenArtifacts(Plugin plugin, json) {
        String packagesStoreDir = preferencesService.getValueOf(PACKAGES_STORE_DIR)
        String basePath = "${packagesStoreDir}/plugin/${json.name}/${json.version}/"
        String fileName = "griffon-${json.name}-${json.version}.zip"
        println "${basePath}${fileName}"
        ZipFile zipFile = new ZipFile(new File("${basePath}${fileName}"))

        List<String> versions = Release.createCriteria().list(sort: 'artifactVersion') {
            artifact {
                eq("name", plugin.name)
            }
            projections {
                property('artifactVersion')
            }
        }
        String lastUpdated = new Date().format('yyyyMMddHHmmss')

        packagesStoreDir = preferencesService.getValueOf(MAVEN_STORE_DIR)
        basePath = "${packagesStoreDir}/${plugin.groupId.replace('.', '/')}/"

        ['bom', 'parent', 'runtime', 'compile', 'test'].each { scope ->
            ZipEntry pomEntry = zipFile.getEntry("poms/${scope}.xml")
            if (pomEntry == null) return
            String artifactName = "griffon-${plugin.name}-${scope}"
            String pomPath = "${artifactName}/${json.version}/griffon-${plugin.name}-${scope}-${json.version}.pom"
            String pomFileName = basePath + pomPath
            persistsZipEntry(zipFile, pomEntry, pomFileName)
            makeMavenMetadata(plugin, basePath + artifactName, versions, scope, lastUpdated)
        }
        ['runtime', 'compile', 'test'].each { scope ->
            String jarName = "griffon-${plugin.name}-${scope}-${json.version}.jar"
            ZipEntry jarEntry = zipFile.getEntry("dist/${jarName}")
            if (jarEntry == null) return
            String jarPath = "griffon-${plugin.name}-${scope}/${json.version}/${jarName}"
            String jarFileName = basePath + jarPath
            persistsZipEntry(zipFile, jarEntry, jarFileName)
            plugin['pom' + scope.capitalize()] = true
        }
        ['sources', 'javadoc'].each { scope ->
            String jarName = "griffon-${plugin.name}-runtime-${json.version}-${scope}.jar"
            ZipEntry jarEntry = zipFile.getEntry("docs/${jarName}")
            if (jarEntry == null) return
            String jarPath = "griffon-${plugin.name}-runtime/${json.version}/${jarName}"
            String jarFileName = basePath + jarPath
            persistsZipEntry(zipFile, jarEntry, jarFileName)
        }
        plugin.save()
    }

    private static void makeMavenMetadata(Plugin plugin, String filePath, List<String> versionList, String scope, String updated) {
        StringWriter sw = new StringWriter()
        MarkupBuilder builder = new MarkupBuilder(sw)
        builder.metadata {
            groupId(plugin.groupId)
            artifactId("griffon-${plugin.name}-${scope}")
            version(versionList[0])
            versioning {
                release(versionList.last())
                versions {
                    versionList.each { v -> version(v) }
                }
                lastUpdated(updated)
            }
        }
        new File("${filePath}/maven-metadata.xml").text = '<?xml version="1.0"?>\n' + sw.toString()
    }
    */

    private static void persistsZipEntry(ZipFile zipFile, ZipEntry zipEntry, String fileName) {
        File file = new File(fileName)
        file.parentFile.mkdirs()
        OutputStream os = new FileOutputStream(file)
        os.bytes = zipFile.getInputStream(zipEntry).bytes
        os.close()
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
            source = json.source
            documentation = json.documentation
        }

        handleAuthors(archetype, json)
        archetype.save()
        makeRelease(artifactInfo, archetype, json)
    }

    private void handleAuthors(Artifact artifact, json) {
        json.authors.each { data ->
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
            releaseNotes = json.releaseNotes ?: ''
        }
        if (json.dependencies) {
            release.dependencies = json.dependencies.inject([:]) { m, dep ->
                m[dep.name] = dep.version
                m
            }
        }

        release.save()

        statsService.upload(
            username: artifactInfo.username,
            release: release,
            type: json.type
        )

        if (artifactInfo.notifications && artifactInfo.twitter) notifyService.tweetRelease(json.type, json.name, json.version)
        if (artifactInfo.notifications && artifactInfo.email) notifyService.notifyWatchers(release, artifactInfo.username)
    }
}
