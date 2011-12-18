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

package griffon.portal

import grails.converters.JSON
import grails.util.GrailsNameUtils
import griffon.portal.values.EventType
import java.util.regex.Matcher
import java.util.regex.Pattern
import java.util.zip.ZipFile
import javax.servlet.http.HttpServletRequest
import org.codehaus.griffon.portal.api.ArtifactInfo
import org.codehaus.griffon.portal.api.ArtifactProcessor
import org.springframework.web.multipart.MultipartHttpServletRequest

/**
 * @author Andres Almiray
 */
class ReleaseController {
    private static final Pattern ARTIFACT_PATTERN = Pattern.compile("^griffon-([\\w][\\w\\.-]*)-([0-9][\\w\\.\\-]*)\\.zip\$")

    ArtifactProcessor artifactProcessor

    def dispatch() {
        def releaseId = params.id
        def actionToFollow = params['release_' + releaseId]
        redirect(action: actionToFollow, id: releaseId)
    }

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

        [releaseInstance: releaseInstance]
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
        String basePath = "/WEB-INF/releases/${type}/${artifact.name}/${releaseInstance.artifactVersion}/"
        String fileName = "griffon-${artifact.name}-${releaseInstance.artifactVersion}.zip"
        String releasePath = servletContext.getRealPath("${basePath}${fileName}")
        byte[] content = new FileInputStream(releasePath).bytes

        new Activity(
                username: session.user?.username ?: 'GRIFFON_WEB',
                eventType: EventType.DOWNLOAD,
                event: [type: type, name: artifact.name, version: releaseInstance.artifactVersion].toString()
        ).save()

        response.contentType = 'application/octet-stream'
        response.contentLength = content.length
        response.setHeader('Pragma', '')
        response.setHeader('Cache-Control', 'must-revalidate')
        response.setHeader('Content-disposition', "attachment; filename=${fileName}")
        response.outputStream << content
    }

    def upload() {
        log.error(params.fileName)
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
                    new ZipFile(tmpFile.getAbsolutePath()),
                    artifactName,
                    artifactVersion,
                    session.user.username,
                    EventType.UPLOAD))
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
