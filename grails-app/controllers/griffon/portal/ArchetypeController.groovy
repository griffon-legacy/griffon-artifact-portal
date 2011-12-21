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
import grails.util.GrailsNameUtils

/**
 * @author Andres Almiray
 */
class ArchetypeController {
    static defaultAction = 'show'

    def show() {
        if (params.name == 'show') {
            params.name = request.getParameter('name')
        }
        if (!params.name) {
            redirect(uri: '/')
            return
        }

        String archetypeName = params.name.toLowerCase()
        Archetype archetypeInstance = Archetype.findByName(archetypeName)
        if (!archetypeInstance) {
            redirect(uri: '/')
            return
        }

        List authorList = archetypeInstance.authors.collect([]) {Author author ->
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
            watching = Watcher.findByArtifact(archetypeInstance)?.users?.contains(user) ?: false
        }

        [
                archetypeName: GrailsNameUtils.getNaturalName(archetypeName),
                archetypeInstance: archetypeInstance,
                authorList: authorList,
                releaseList: Release.findAllByArtifact(archetypeInstance, [sort: 'artifactVersion', order: 'desc']),
                watching: watching
        ]
    }

    def list() {
        [archetypeList: Archetype.list(sort: 'name', order: 'asc')]
    }

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
}
