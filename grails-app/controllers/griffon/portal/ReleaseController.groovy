/*
 * Copyright 2011-2012 the original author or authors.
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

package griffon.portal

import grails.converters.JSON
import grails.util.GrailsNameUtils
import griffon.portal.stats.Download
import griffon.portal.stats.DownloadTotal
import java.util.regex.Matcher
import java.util.regex.Pattern
import javax.servlet.http.HttpServletRequest
import org.codehaus.griffon.portal.api.ArtifactInfo
import org.codehaus.griffon.portal.api.ArtifactProcessor
import org.springframework.web.multipart.MultipartHttpServletRequest
import static griffon.portal.values.PreferenceKey.RELEASES_STORE_DIR
import static griffon.portal.values.PreferenceKey.PACKAGES_STORE_DIR

/**
 * @author Andres Almiray
 */
class ReleaseController {
    private static final Pattern ARTIFACT_PATTERN = Pattern.compile("^griffon-([\\w][\\w\\.-]*)-([0-9][\\w\\.\\-]*)\\.zip\$")

    ArtifactProcessor artifactProcessor
    PreferencesService preferencesService

    def show() {
        if (!params.id) {
            redirect(uri: '/')
            return
        }

        def releaseId = params.id instanceof Long ? params.id : params.id.toLong()
        Release releaseInstance = Release.get(releaseId)
        if (!releaseInstance) {
            redirect(uri: '/')
            return
        }

        [
                releaseInstance: releaseInstance,
                downloads: DownloadTotal.findByRelease(releaseInstance)?.total ?: 0i
        ]
    }

    def display() {
        if (!params.type || !params.name || !params.version) {
            redirect(uri: '/')
            return
        }

        Artifact artifact = null
        switch (params.type) {
            case 'plugin':
                artifact = Plugin.findByName(params.name)
                break
            case 'archetype':
                artifact = Archetype.findByName(params.name)
                break
        }

        if (!artifact) {
            redirect(uri: '/')
            return
        }

        Release releaseInstance = Release.withCriteria(uniqueResult: true) {
            and {
                eq('artifactVersion', params.version)
                eq('artifact', artifact)
            }
        }

        if (!releaseInstance) {
            redirect(uri: '/')
            return
        }

        render(view: 'show', model: [
                releaseInstance: releaseInstance,
                downloads: DownloadTotal.findByRelease(releaseInstance)?.total ?: 0i
        ])
    }

    def download() {
        if (!params.id) {
            redirect(uri: '/')
            return
        }

        def releaseId = params.id instanceof Long ? params.id : params.id.toLong()
        Release releaseInstance = Release.get(releaseId)
        if (!releaseInstance) {
            redirect(uri: '/')
            return
        }

        Artifact artifact = releaseInstance.artifact
        String type = GrailsNameUtils.getShortName(artifact.getClass()).toLowerCase()
        String releasesStoreDir = preferencesService.getValueOf(RELEASES_STORE_DIR)
        String basePath = "${releasesStoreDir}/${type}/${artifact.name}/${releaseInstance.artifactVersion}/"
        String fileName = "griffon-${artifact.name}-${releaseInstance.artifactVersion}.zip"
        File file = new File("${basePath}${fileName}")
        byte[] content = file.bytes

        new Download(
                username: session.user?.username ?: 'GRIFFON_WEB',
                release: releaseInstance,
                type: type,
                userAgent: request.getHeader('user-agent'),
                ipAddress: request.remoteAddr,
                osName: request.getHeader('x-os-name'),
                osArch: request.getHeader('x-os-arch'),
                osVersion: request.getHeader('x-os-version'),
                javaVersion: request.getHeader('x-java-version'),
                javaVmVersion: request.getHeader('x-java-vm-version'),
                javaVmName: request.getHeader('x-java-vm-name'),
                griffonVersion: request.getHeader('x-griffon-version')
        ).saveIt()

        Date lastModified = new Date(file.lastModified())
        response.contentType = 'application/zip'
        response.contentLength = content.length
        response.setHeader('Cache-Control', 'must-revalidate')
        response.setHeader('Accept-Ranges', 'bytes')
        response.setHeader('Last-Modified', lastModified.format('EEE, dd MMM yyyy HH:mm:ss z'))
        response.setHeader('Content-disposition', "attachment; filename=${fileName}")
        response.outputStream << content
    }

    def download_package() {
        if (!params.type || !params.name || !params.version) {
            redirect(uri: '/')
            return
        }

        String packagesStoreDir = preferencesService.getValueOf(PACKAGES_STORE_DIR)
        String basePath = "${packagesStoreDir}/${params.type}/${params.name}/${params.version}/"
        String fileName = "griffon-${params.name}-${params.version}.zip"
        File file = new File("${basePath}${fileName}")
        if (!file.exists()) {
            // should result in 404
            redirect(uri: '/')
            return
        }

        byte[] content = file.bytes
        Date lastModified = new Date(file.lastModified())
        response.contentType = 'application/zip'
        response.contentLength = content.length
        response.setHeader('Cache-Control', 'must-revalidate')
        response.setHeader('Accept-Ranges', 'bytes')
        response.setHeader('Last-Modified', lastModified.format('EEE, dd MMM yyyy HH:mm:ss z'))
        response.setHeader('Content-disposition', "attachment; filename=${fileName}")
        response.outputStream << content
    }

    def upload() {
        Matcher matcher = ARTIFACT_PATTERN.matcher(params.fileName)
        if (!matcher.find()) {
            render([success: false, message: "Not allowed: " + params.fileName] as JSON)
            return
        }
        String artifactName = matcher.group(1)
        String artifactVersion = matcher.group(2)

        try {
            File tmpFile = createTemporaryFile()
            InputStream inputStream = selectInputStream(request)
            tmpFile << inputStream

            artifactProcessor.process(new ArtifactInfo(
                    tmpFile,
                    artifactName,
                    artifactVersion,
                    session.user.username))
        } catch (IOException ioe) {
            render([success: false, message: ioe.message] as JSON)
            return
        }
        render([success: true, message: "Succesfully uploaded ${params.fileName}"] as JSON)
    }

    private InputStream selectInputStream(HttpServletRequest request) {
        if (request instanceof MultipartHttpServletRequest) {
            request.getFile('upload-file').inputStream
        } else {
            request.inputStream
        }
    }

    private File createTemporaryFile() {
        File.createTempFile('grails', 'ajaxupload')
    }
}
