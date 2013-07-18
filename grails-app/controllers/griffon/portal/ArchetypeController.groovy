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
class ArchetypeController {
    static navigationScope = 'hidden'

    static defaultAction = 'show'

    def list() {
        return redirect(uri: '/archetypes')
    }

    def show() {
        if (params.name == 'show') {
            params.name = request.getParameter('name')
        }
        if (!params.name) {
            return redirect(uri: '/archetypes')
        }

        String archetypeName = params.name.toLowerCase()
        Archetype archetypeInstance = Archetype.findByName(archetypeName)
        if (!archetypeInstance) {
            return redirect(uri: '/archetypes')
        }

        params.tab = params.tab ?: ArtifactTab.DESCRIPTION.name

        List authorList = archetypeInstance.authors.collect([]) { Author author ->
            User user = User.findWhere(email: author.email)
            if (user) {
                [
                    name: author.name,
                    email: user.profile.gravatarEmail,
                    username: user.username
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
            watching = Watcher.findByArtifact(archetypeInstance)?.users?.contains(user) ?: false
        }

        def downloads = DownloadTotal.withCriteria() {
            and {
                eq('type', 'archetype')
                release {
                    eq('artifact', archetypeInstance)
                }
            }
        }.total.sum()

        List releaseList = Release.findAllByArtifact(archetypeInstance, [sort: 'artifactVersion', order: 'desc'])
        List downloadsByCountry = DownloadByCountry.findAllByArtifact(archetypeInstance, [sort: 'total', order: 'asc']).collect(downloadsByCountry) { DownloadByCountry t ->
            [t.country, t.total]
        }

        [
            archetypeName: archetypeName,
            archetypeInstance: archetypeInstance,
            authorList: authorList,
            releaseList: releaseList,
            watching: watching,
            downloads: downloads ?: 0i,
            downloadsByCountry: downloadsByCountry,
            tab: params.tab
        ]
    }
}
