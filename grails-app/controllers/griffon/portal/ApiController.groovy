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
import griffon.portal.auth.User
import griffon.portal.stats.Download
import griffon.portal.util.MD5
import static grails.util.GrailsNameUtils.isBlank
import static griffon.portal.values.PreferenceKey.PACKAGES_STORE_DIR
import static griffon.portal.values.PreferenceKey.RELEASES_STORE_DIR

/**
 * @author Andres Almiray
 */
class ApiController {
    private final static String TIMESTAMP_FORMAT = "yyyy-MM-dd'T'HH:mm:ssZ"
    private final static Map SORT_SETTINGS = [sort: 'artifactVersion', order: 'desc']

    static allowedMethods = [
            list: 'GET',
            info: 'GET',
            download: 'GET']

    PreferencesService preferencesService

    def index() {}

    def list() {
        List list = []
        switch (params.type) {
            case 'plugin':
                list = Plugin.list(sort: 'name')
                break
            case 'archetype':
                list = Archetype.list(sort: 'name')
        }

        list = list.collect([]) { artifact ->
            Map data = asMap(artifact, false)
            data.releases = Release.findAllByArtifact(artifact, SORT_SETTINGS).collect([]) {Release release ->
                asMap(release)
            }
            data
        }

        render list as JSON
    }

    def info() {
        Artifact artifact = null
        switch (params.type) {
            case 'plugin':
                artifact = Plugin.findByName(params.name)
                break
            case 'archetype':
                artifact = Archetype.findByName(params.name)
        }

        Map data = [:]
        if (artifact) {
            data = asMap(artifact)
            if (params.version) {
                Release release = Release.withCriteria(uniqueResult: true) {
                    and {
                        eq('artifactVersion', params.version)
                        eq('artifact', artifact)
                    }
                }
                if (release) {
                    data.release = asMap(release)
                } else {
                    response.status = 404
                    data = [
                            action: 'info',
                            response: 'Not Found',
                            params: [
                                    type: params.type,
                                    name: params.name,
                                    name: params.version
                            ]
                    ]
                }
            } else {
                data.releases = Release.findAllByArtifact(artifact, SORT_SETTINGS).collect([]) {Release release ->
                    asMap(release)
                }
            }
        } else {
            response.status = 404
            data = [
                    action: 'info',
                    response: 'Not Found',
                    params: [
                            type: params.type,
                            name: params.name
                    ]
            ]
        }
        render data as JSON
    }

    def download() {
        Artifact artifact = null
        switch (params.type) {
            case 'plugin':
                artifact = Plugin.findByName(params.name)
                break
            case 'archetype':
                artifact = Archetype.findByName(params.name)
        }
        if (!artifact) {
            response.status = 404
            render([
                    action: 'download',
                    response: 'Not Found',
                    params: [
                            type: params.type,
                            name: params.name,
                            version: params.version
                    ]
            ] as JSON)
            return
        }

        Release release = Release.withCriteria(uniqueResult: true) {
            and {
                eq('artifactVersion', params.version)
                eq('artifact', artifact)
            }
        }
        if (!release) {
            response.status = 404
            render([
                    action: 'download',
                    response: 'Not Found',
                    params: [
                            type: params.type,
                            name: params.name,
                            version: params.version
                    ]
            ] as JSON)
            return
        }

        String storeDir = preferencesService.getValueOf(params.release ? RELEASES_STORE_DIR : PACKAGES_STORE_DIR)
        String basePath = "${storeDir}/${params.type}/${params.name}/${params.version}/"
        String fileName = "griffon-${params.name}-${params.version}"
        if (params.release) {
            fileName += '-release.zip'
        } else if (params.md5) {
            fileName += '.zip.md5'
        } else {
            fileName += '.zip'
        }
        File file = new File("${basePath}${fileName}")
        byte[] content = file.bytes

        String username = request.getHeader('x-username')?.trim()
        if (isBlank(username) || !User.findByUsername(username)) {
            username = 'GRIFFON_API'
        } else {
            username = MD5.encode(username)
        }

        response.contentType = 'text/plain'
        if (!params.md5 && !params.release) {
            new Download(
                    username: username,
                    release: release,
                    type: params.type,
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

            response.contentType = 'application/zip'
            response.setHeader('Cache-Control', 'must-revalidate')
        }

        Date lastModified = new Date(file.lastModified())
        response.contentLength = content.length
        response.setHeader('Accept-Ranges', 'bytes')
        response.setHeader('Last-Modified', lastModified.format('EEE, dd MMM yyyy HH:mm:ss z'))
        response.setHeader('Content-disposition', "attachment; filename=${fileName}")
        response.outputStream << content
    }

    private Map asMap(Plugin plugin, boolean includeDescription = true) {
        Map map = [
                name: plugin.name,
                title: plugin.title
        ]
        if (includeDescription) {
            map.description = plugin.description
        }

        map + [
                license: plugin.license,
                source: plugin.source ?: '',
                documentation: plugin.documentation ?: '',
                toolkits: isBlank(plugin.toolkits) ? [] : plugin.toolkits.split(','),
                platforms: isBlank(plugin.platforms) ? [] : plugin.platforms.split(','),
                framework: plugin.framework,
                authors: plugin.authors.collect([]) { Author author ->
                    [name: author.name, email: author.email]
                }
        ]
    }

    private Map asMap(Archetype archetype, boolean includeDescription = true) {
        Map map = [
                name: archetype.name,
                title: archetype.title]

        if (includeDescription) {
            map.description = archetype.description
        }

        map + [
                license: archetype.license,
                source: archetype.source ?: '',
                documentation: archetype.documentation ?: '',
                authors: archetype.authors.collect([]) { Author author ->
                    [name: author.name, email: author.email]
                }
        ]
    }

    private Map asMap(Release release) {
        [
                version: release.artifactVersion,
                griffonVersion: release.griffonVersion,
                date: release.dateCreated.format(TIMESTAMP_FORMAT),
                checksum: release.checksum,
                comment: release.comment,
                dependencies: release.dependencies.inject([]) { l, entry ->
                    l << [name: entry.key, version: entry.value]
                    l
                },
        ]
    }
}
