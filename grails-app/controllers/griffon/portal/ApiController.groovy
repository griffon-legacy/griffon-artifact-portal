package griffon.portal

import grails.converters.JSON
import grails.util.GrailsNameUtils

class ApiController {
    private final static String TIMESTAMP_FORMAT = "yyyy-MM-dd'T'HH:mm:ssZ"

    static allowedMethods = [
            plugins: 'GET',
            archetypes: 'GET',
            pluginInfo: 'GET',
            archetypeInfo: 'GET']

    def plugins() {
        List list = Plugin.list(sort: 'name').collect([]) { Plugin plugin ->
            asMap(plugin)
        }

        render list as JSON
    }

    def archetypes() {
        List list = Archetype.list(sort: 'name').collect([]) { Archetype archetype ->
            asMap(archetype)
        }

        render list as JSON
    }

    def pluginInfo() {
        Map data = [:]
        Plugin plugin = Plugin.findByName(params.name)
        if (plugin) {
            data = asMap(plugin)
            data.releases = Release.findAllByArtifact(plugin, [sort: 'artifactVersion', order: 'desc']).collect([]) {Release release ->
                asMap(release)
            }
        }
        render data as JSON
    }

    def archetypeInfo() {
        Map data = [:]
        Archetype archetype = Archetype.findByName(params.name)
        if (archetype) {
            data = asMap(archetype)
            data.releases = Release.findAllByArtifact(archetype, [sort: 'artifactVersion', order: 'desc']).collect([]) {Release release ->
                asMap(release)
            }
        }
        render data as JSON
    }

    def download() {
        Release release = Release.withCriteria(uniqueResult: true) {
            and {
                eq('artifactVersion', params.version)
                artifact {
                    eq('name', params.name)
                }
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
