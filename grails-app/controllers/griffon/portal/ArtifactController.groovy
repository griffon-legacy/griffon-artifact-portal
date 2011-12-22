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

import grails.converters.JSON
import griffon.portal.values.Category

/**
 * @author Andres Almiray
 */
class ArtifactController {
    def watch() {
        User user = session.user ? User.get(session.user.id) : null
        Artifact artifact = Artifact.get(params.id)
        Watcher watcher = Watcher.findByArtifact(artifact) ?: new Watcher(artifact: artifact)

        if (watcher.users?.contains(user)) {
            watcher.removeFromUsers(user)
            if (watcher.users.isEmpty()) {
                watcher.delete(flush: true)
            } else {
                watcher.save(flush: true)
            }
            render([status: false] as JSON)
        } else {
            watcher.addToUsers(user)
            watcher.save(flush: true)
            render([status: true] as JSON)
        }
    }

    def all() {
        List<Artifact> artifacts = []
        switch (params.type) {
            case 'plugin':
                artifacts = Plugin.list(sort: 'name', order: 'asc')
                break
            case 'archetype':
                artifacts = Archetype.list(sort: 'name', order: 'asc')
                break
        }

        Map artifactMap = [:]
        artifacts.each {Artifact artifact ->
            String firstChar = artifact.name[0].toUpperCase()
            List list = artifactMap.get(firstChar, [])
            list << artifact
        }

        [
                artifactMap: artifactMap,
                artifactTotal: artifacts.size(),
                categoryType: Category.findByName(params.action)
        ]
    }

    def recently_updated() {
        Date now = (new Date()).clearTime()
        List<Artifact> artifacts = []

        Map queryParams = [
                sort: 'name',
                order: 'asc',
                max: 5,
                offset: params.offset ?: 0
        ]

        switch (params.type) {
            case 'plugin':
                artifacts = Plugin.findAllByLastUpdatedBetween(now - 14, now + 1, queryParams)
                break
            case 'archetype':
                artifacts = Archetype.findAllByLastUpdatedBetween(now - 14, now + 1, queryParams)
                break
        }

        render(view: 'list',
                model: [
                        artifactList: artifacts,
                        artifactTotal: artifacts.size(),
                        categoryType: Category.findByName(params.action)
                ])
    }

    def newest() {
        Date now = (new Date()).clearTime()
        List<Artifact> artifacts = []

        Map queryParams = [
                sort: 'name',
                order: 'asc',
                max: 5,
                offset: params.offset ?: 0
        ]

        switch (params.type) {
            case 'plugin':
                artifacts = Plugin.findAllByDateCreatedBetween(now - 14, now + 1, queryParams)
                break
            case 'archetype':
                artifacts = Archetype.findAllByDateCreatedBetween(now - 14, now + 1, queryParams)
                break
        }

        render(view: 'list',
                model: [
                        artifactList: artifacts,
                        artifactTotal: artifacts.size(),
                        categoryType: Category.findByName(params.action)
                ])
    }

    def highest_voted() {
        List<Artifact> artifacts = []

        Map queryParams = [
                max: 5,
                offset: params.offset ?: 0
        ]

        switch (params.type) {
            case 'plugin':
                artifacts = Plugin.listOrderByAverageRating(queryParams)
                break
            case 'archetype':
                artifacts = Archetype.listOrderByAverageRating(queryParams)
                break
        }

        render(view: 'list',
                model: [
                        artifactList: artifacts,
                        artifactTotal: artifacts.size(),
                        categoryType: Category.findByName(params.action)
                ])
    }
}
