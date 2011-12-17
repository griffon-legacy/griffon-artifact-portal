package griffon.portal

import grails.converters.JSON
import grails.util.GrailsNameUtils

class ApiController {
    private final static String TIMESTAMP_FORMAT = "yyyy-MM-dd'T'HH:mm:ssZ"
    private final static Map SORT_SETTINGS = [sort: 'artifactVersion', order: 'desc']

    static allowedMethods = [
            list: 'GET',
            info: 'GET',
            download: 'GET']

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
            asMap(artifact)
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
            data.releases = []
            Release.findAllByArtifact(artifact, SORT_SETTINGS).each {Release release ->
                try {
                    data.releases << asMap(release)
                } catch (IOException ioe) {
                    // ignore
                }
            }
        } else {
            data = [
                    action: 'info',
                    response: 'Not Found',
                    params: [
                            type: params.type,
                            name: params.name,
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
        String fileName = "griffon-${params.name}-${params.version}.zip"
        String releasePath = servletContext.getRealPath("${basePath}${fileName}")
        byte[] content = new FileInputStream(releasePath).bytes

        response.contentType = 'application/octet-stream'
        response.contentLength = content.length
        response.setHeader('Pragma', '')
        response.setHeader('Cache-Control', 'must-revalidate')
        response.setHeader('Content-disposition', "attachment; filename=${fileName}")
        response.outputStream << content
    }

    private Map asMap(Plugin plugin) {
        [
                name: plugin.name,
                title: plugin.title,
                description: plugin.description,
                license: plugin.license,
                toolkits: plugin.toolkits,
                platforms: plugin.platforms,
                authors: plugin.authors.collect([]) { Author author ->
                    [name: author.name, email: author.email]
                }
        ]
    }

    private Map asMap(Archetype archetype) {
        [
                name: archetype.name,
                title: archetype.title,
                description: archetype.description,
                license: archetype.license,
                authors: archetype.authors.collect([]) { Author author ->
                    [name: author.name, email: author.email]
                }
        ]
    }

    private Map asMap(Release release) {
        Artifact artifact = release.artifact
        String type = GrailsNameUtils.getShortName(artifact.getClass()).toLowerCase()
        String basePath = "/WEB-INF/releases/${type}/${artifact.name}/${release.artifactVersion}/"
        String fileName = "griffon-${artifact.name}-${release.artifactVersion}.zip.md5"
        String releasePath = servletContext.getRealPath("${basePath}${fileName}")

        [
                version: release.artifactVersion,
                griffonVersion: release.griffonVersion,
                date: release.dateCreated.format(TIMESTAMP_FORMAT),
                comment: release.comment,
                checksum: new FileInputStream(releasePath).text
        ]
    }
}
