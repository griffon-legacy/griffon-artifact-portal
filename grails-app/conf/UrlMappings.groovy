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
        "/settings"(controller: 'profile', action: 'settings')

        '/api'(controller: 'api', action: 'index')
        '/api/plugins'(controller: 'api', action: 'list') { type = 'plugin'}
        "/api/plugins/$name"(controller: 'api', action: 'info') { type = 'plugin'}
        "/api/plugins/$name/$version"(controller: 'api', action: 'info') { type = 'plugin'}
        "/api/plugins/$name/download/$version"(controller: 'api', action: 'download') { type = 'plugin'}
        '/api/archetypes'(controller: 'api', action: 'list') { type = 'archetype' }
        "/api/archetypes/$name"(controller: 'api', action: 'info') { type = 'archetype' }
        "/api/archetypes/$name/$version"(controller: 'api', action: 'info') { type = 'archetype' }
        "/api/archetypes/$name/download/$version"(controller: 'api', action: 'download') { type = 'archetype' }

        '/repository/plugins'(controller: 'api', action: 'list') { type = 'plugin'}
        "/repository/plugins/$name"(controller: 'api', action: 'info') { type = 'plugin'}
        "/repository/plugins/$name/$version"(controller: 'api', action: 'info') { type = 'plugin'}
        "/repository/plugins/$name/$version/griffon-${name}-${version}.zip"(controller: 'api', action: 'download') {
            type = 'plugin'
            md5 = false
        }
        "/repository/plugins/$name/$version/griffon-${name}-${version}.zip.md5"(controller: 'api', action: 'download') {
            type = 'plugin'
            md5 = true
        }
        '/repository/archetypes'(controller: 'api', action: 'list') { type = 'archetype'}
        "/repository/archetypes/$name"(controller: 'api', action: 'info') { type = 'archetype'}
        "/repository/archetypes/$name/$version"(controller: 'api', action: 'info') { type = 'archetype'}
        "/repository/archetypes/$name/$version/griffon-${name}-${version}.zip"(controller: 'api', action: 'download') {
            type = 'archetype'
            md5 = false
        }
        "/repository/archetypes/$name/$version/griffon-${name}-${version}.zip.md5"(controller: 'api', action: 'download') {
            type = 'archetype'
            md5 = true
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
