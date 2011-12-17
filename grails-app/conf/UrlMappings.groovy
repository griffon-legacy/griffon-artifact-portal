class UrlMappings {
    static mappings = {
        "/profile/$id"(controller: 'profile', action: 'show')
        "/api/plugins/$name"(controller: 'api', action: 'pluginInfo')
        "/api/plugins/$name/download/$version"(controller: 'api', action: 'download') {
            type = 'plugin'
        }
        "/api/archetypes/$name"(controller: 'api', action: 'archetypeInfo')
        "/api/archetypes/$name/download/$version"(controller: 'api', action: 'download') {
            type = 'archetype'
        }
        "/plugins"(controller: 'plugin', action: 'list')
        name showPlugin: "/plugin/$name"(controller: 'plugin', action: 'show')
        "/archetypes"(controller: 'archetype', action: 'list')
        name showArchetype: "/archetype/$name"(controller: 'archetype', action: 'show')
        "/release/show/$id"(controller: 'release', action: 'show')
        "/release/download/$id"(controller: 'release', action: 'download')

        "/$controller/$action?/$id?" {
            constraints {
                // apply constraints here
            }
        }

        "/"(view: "/index")
        "500"(view: '/error')
    }
}
