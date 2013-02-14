/*
 * Copyright 2011-2013 the original author or authors.
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

import griffon.portal.auth.User
import griffon.portal.stats.DownloadByCountry
import griffon.portal.stats.DownloadTotal
import griffon.portal.values.ArtifactTab

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
            redirect(uri: '/plugins')
            return
        }

        String pluginName = params.name.toLowerCase()
        if (pluginName.contains('+')) {
            pluginName = pluginName.replace('+', '-')
        }

        Plugin pluginInstance = Plugin.findByName(pluginName)
        if (!pluginInstance) {
            redirect(uri: '/plugins')
            return
        }

        params.tab = params.tab ?: ArtifactTab.DESCRIPTION.name

        List authorList = pluginInstance.authors.collect([]) { Author author ->
            User user = User.findWhere(email: author.email)
            if (user && user.profile) {
                [
                    name: author.name,
                    email: user.profile.gravatarEmail,
                    username: user.username,
                ]
            } else {
                [
                    id: author.id,
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

        List releaseList = []
        if (params.tab == ArtifactTab.RELEASES.name) {
            releaseList = Release.findAllByArtifact(pluginInstance, [sort: 'artifactVersion', order: 'desc'])
        }

        List downloadsByCountry = []
        if (params.tab == ArtifactTab.STATISTICS.name) {
            DownloadByCountry.findAllByArtifact(pluginInstance, [sort: 'total', order: 'asc']).collect(downloadsByCountry) { DownloadByCountry t ->
                [t.country, t.total]
            }
        }

        [
            pluginName: pluginName,
            pluginInstance: pluginInstance,
            authorList: authorList,
            releaseList: releaseList,
            watching: watching,
            downloads: downloads ?: 0i,
            downloadsByCountry: downloadsByCountry,
            tab: params.tab
        ]
    }
}
