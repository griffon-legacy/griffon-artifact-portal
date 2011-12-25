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

import grails.util.GrailsNameUtils
import griffon.portal.auth.User
import griffon.portal.stats.DownloadTotal

/**
 * @author Andres Almiray
 */
class PluginController {
    static defaultAction = 'show'

    def show() {
        if (params.name == 'show') {
            params.name = request.getParameter('name')
        }
        if (!params.name) {
            redirect(uri: '/')
            return
        }

        String pluginName = params.name.toLowerCase()
        Plugin pluginInstance = Plugin.findByName(pluginName)
        if (!pluginInstance) {
            redirect(uri: '/')
            return
        }

        List authorList = pluginInstance.authors.collect([]) {Author author ->
            User user = User.findWhere(email: author.email)
            if (user) {
                [
                        name: author.name,
                        email: user.profile.gravatarEmail,
                        username: user.username
                ]
            } else {
                [
                        name: author.name,
                        email: author.email,
                        username: ''
                ]
            }
        }

        boolean watching = false
        User user = session.user ? User.get(session.user.id) : null
        if (user) {
            // use of elvis to avoid assigning null to a boolean (!!)
            watching = Watcher.findByArtifact(pluginInstance)?.users?.contains(user) ?: false
        }

        def downloads = DownloadTotal.withCriteria() {
            and {
                eq('type', 'plugin')
                release {
                    eq('artifact', pluginInstance)
                }
            }
        }.total.sum()

        [
                pluginName: GrailsNameUtils.getNaturalName(pluginName),
                pluginInstance: pluginInstance,
                authorList: authorList,
                releaseList: Release.findAllByArtifact(pluginInstance, [sort: 'artifactVersion', order: 'desc']),
                watching: watching,
                downloads: downloads ?: 0i
        ]
    }

    def list() {
        [pluginList: Plugin.list(sort: 'name', order: 'asc')]
    }
}
