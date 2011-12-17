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

import grails.util.GrailsNameUtils

/**
 * @author Andres Almiray
 */
class ReleaseController {
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

        response.contentType = 'application/octet-stream'
        response.contentLength = content.length
        response.setHeader('Pragma', '')
        response.setHeader('Cache-Control', 'must-revalidate')
        response.setHeader('Content-disposition', "attachment; filename=${fileName}")
        response.outputStream << content
    }
}
