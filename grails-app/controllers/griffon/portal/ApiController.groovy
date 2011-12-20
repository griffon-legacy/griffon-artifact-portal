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
import griffon.portal.values.EventType

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

        String basePath = "/WEB-INF/releases/${params.type}/${params.name}/${params.version}/"
        String fileName = "griffon-${params.name}-${params.version}.zip" + (params.md5 ? '.md5' : '')
        String releasePath = servletContext.getRealPath("${basePath}${fileName}")
        File file = new File(releasePath)
        byte[] content = file.bytes

        response.contentType = 'text/plain'
        if (!params.md5) {
            new Activity(
                    username: 'GRIFFON_API',
                    eventType: EventType.DOWNLOAD,
                    event: [type: params.type, name: params.name, version: params.version].toString()
            ).save()

            response.contentType = 'application/octet-stream'
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
                toolkits: plugin.toolkits,
                platforms: plugin.platforms,
                dependencies: plugin.dependencies.inject([]) { l, entry ->
                    l << [name: entry.key, version: entry.value]
                    l
                },
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
                comment: release.comment
        ]
    }
}
