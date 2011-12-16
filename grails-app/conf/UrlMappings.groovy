class UrlMappings {
    static mappings = {
        "/profile/$id"(controller: 'profile', action: 'show')
        "/api/plugins/$name"(controller: 'api', action: 'pluginInfo')
        "/api/archetypes/$name"(controller: 'api', action: 'archetypeInfo')
        "/plugins"(controller: 'plugin', action: 'list')
        name showPlugin: "/plugin/$name"(controller: 'plugin', action: 'show')
        "/archetypes"(controller: 'archetype', action: 'list')
        name showArchetype: "/archetype/$name"(controller: 'archetype', action: 'show')
        name showRelease: "/release/$id"(controller: 'release', action: 'show')

        "/$controller/$action?/$id?" {
            constraints {
                // apply constraints here
            }
        }

        "/"(view: "/index")
        "500"(view: '/error')
    }
}
