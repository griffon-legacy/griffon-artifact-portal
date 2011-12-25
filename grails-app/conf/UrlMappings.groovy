class UrlMappings {
    static mappings = {
        name signin: "/signin"(controller: 'user', action: 'login')
        name signup: "/signup"(controller: 'user', action: 'signup')
        name login: "/login"(controller: 'user', action: 'login')
        name logout: "/logout"(controller: 'user', action: 'logout')
        name subscribe: "/subscribe"(controller: 'user', action: 'subscribe')
        name forgot_password: "/forgot_password"(controller: 'user', action: 'forgot_password')
        name forgot_username: "/forgot_username"(controller: 'user', action: 'forgot_username')

        name sesstings_update_account: "/settings/$username/update/account"(controller: 'profile', action: 'update_account')
        name sesstings_update_profile: "/settings/$username/update/profile"(controller: 'profile', action: 'update_profile')
        name sesstings_update_password: "/settings/$username/update/password"(controller: 'profile', action: 'update_password')
        name settings: "/settings/$username/$tab"(controller: 'profile', action: 'settings')
        //"/profile/$id"(controller: 'profile', action: 'show')
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

        name categories_plugin: "/category/$action/plugins"(controller: 'artifact') {
            type = 'plugin'
            constraints {
                action(inList: griffon.portal.values.Category.getNamesAsList())
            }
        }

        name categories_archetype: "/category/$action/archetypes"(controller: 'artifact') {
            type = 'archetype'
            constraints {
                action(inList: griffon.portal.values.Category.getNamesAsList())
            }
        }

        name watch_artifact: "/artifact/watch/$id"(controller: 'artifact', action: 'watch')
        name tag_artifact: "/artifact/tag/$id"(controller: 'artifact', action: 'tag')
        "/plugins"(controller: 'plugin', action: 'list')
        "/archetypes"(controller: 'archetype', action: 'list')
        name show_plugin: "/plugin/$name"(controller: 'plugin', action: 'show')
        name show_archetype: "/archetype/$name"(controller: 'archetype', action: 'show')
        name show_docs: "/docs/$type/$name"(controller: 'docs', action: 'show')
        name show_release: "/release/show/$id"(controller: 'release', action: 'show')
        name download_release: "/release/download/$id"(controller: 'release', action: 'download')
        name display_release: "/release/$type/$name/$version"(controller: 'release', action: 'display')

        "/$controller/$action?/$id?" {
            constraints {
                // apply constraints here
            }
        }

        "/"(view: "/index")
        "500"(view: '/error')
    }
}
