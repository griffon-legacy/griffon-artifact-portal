package griffon.portal

import grails.converters.JSON

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
        [
                version: release.artifactVersion,
                griffonVersion: release.griffonVersion,
                date: release.dateCreated.format(TIMESTAMP_FORMAT),
                comment: release.comment
        ]
    }
}
