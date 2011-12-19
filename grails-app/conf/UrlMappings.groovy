class UrlMappings {
    static mappings = {
        name signin: "/signin"(controller: 'user', action: 'login')
        name signup: "/signup"(controller: 'user', action: 'signup')
        name login: "/login"(controller: 'user', action: 'login')
        name logout: "/logout"(controller: 'user', action: 'logout')
        name subscribe: "/subscribe"(controller: 'user', action: 'subscribe')
        name forgot_password: "/forgot_password"(controller: 'user', action: 'forgot_password')
        name forgot_username: "/forgot_username"(controller: 'user', action: 'forgot_username')

        "/profile/$id"(controller: 'profile', action: 'show')
        "/settings/$id"(controller: 'profile', action: 'settings')
        '/api/plugins'(controller: 'api', action: 'list') {
            type = 'plugin'
        }
        "/api/plugins/$name"(controller: 'api', action: 'info') {
            type = 'plugin'
        }
        "/api/plugins/$name/download/$version"(controller: 'api', action: 'download') {
            type = 'plugin'
        }
        '/api/archetypes'(controller: 'api', action: 'list') {
            type = 'archetype'
        }
        "/api/archetypes/$name"(controller: 'api', action: 'info') {
            type = 'archetype'
        }
        "/api/archetypes/$name/download/$version"(controller: 'api', action: 'download') {
            type = 'archetype'
        }
        "/plugins"(controller: 'plugin', action: 'list')
        "/archetypes"(controller: 'archetype', action: 'list')
        name showPlugin: "/plugin/$name"(controller: 'plugin', action: 'show')
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
