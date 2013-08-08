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

package griffon.portal

import static griffon.portal.values.PreferenceKey.MAVEN_STORE_DIR

/**
 * @author Andres Almiray
 */
class MavenController {
    StatsService statsService
    PreferencesService preferencesService

    def browse() {
        String packagesStoreDir = preferencesService.getValueOf(MAVEN_STORE_DIR)
        String path = "${packagesStoreDir}/${params.artifactPath}"
        if (params.artifactPath.endsWith('maven-metadata')) path += '.xml'
        File file = new File(path)
        if (!file.exists()) {
            response.sendError(404)
            return
        }

        if (file.name.endsWith('maven-metadata.xml') || file.name.endsWith('.pom')) {
            response.contentType = 'text/xml'
            return render(file.text)
        } else if (file.name.endsWith('.jar')) {
            String pluginVersion = file.parentFile.name
            String pluginName = file.parentFile.parentFile.name - 'griffon-'
            if (pluginName.endsWith('-runtime')) pluginName -= '-runtime'
            if (pluginName.endsWith('-compile')) pluginName -= '-compile'
            if (pluginName.endsWith('-test')) pluginName -= '-test'
            Release releaseInstance = Release.withCriteria(uniqueResult: true) {
                and {
                    eq('artifactVersion', pluginVersion)
                    artifact {
                        eq('name', pluginName)
                    }
                }
            }
            statsService.mavenDownload(
                release: releaseInstance,
                filename: file.name,
                userAgent: request.getHeader('user-agent'),
                ipAddress: request.remoteAddr
            )

            byte[] content = file.bytes
            Date lastModified = new Date(file.lastModified())
            response.contentType = 'application/jar'
            response.contentLength = content.length
            response.setHeader('Cache-Control', 'must-revalidate')
            response.setHeader('Accept-Ranges', 'bytes')
            response.setHeader('Last-Modified', lastModified.format('EEE, dd MMM yyyy HH:mm:ss z'))
            response.setHeader('Content-disposition', "attachment; filename=${file.name}")
            response.outputStream << content
        }

        if (params.artifactPath && params.artifactPath[0] != '/') params.artifactPath = '/' + params.artifactPath
        String basePath = '/repository/maven'
        String[] pathParts = params.artifactPath.split('/')
        String parentPath = basePath + pathParts[0..(pathParts.length - 2)].join('/')
        if (parentPath == basePath) parentPath += '/'
        [files: file.listFiles(), parentPath: parentPath]
    }
}
