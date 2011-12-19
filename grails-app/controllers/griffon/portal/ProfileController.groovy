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

/**
 * @author Andres Almiray
 */
class ProfileController {
    static defaultAction = 'show'

    def show() {
        if (!params.id) {
            redirect(uri: '/')
            return
        }

        // attempt username resolution first
        Profile profileInstance = User.findByUsername(params.id)?.profile
        if (!profileInstance) {
            // attempt id resolution next
            try {
                Long.parseLong(params.id)
            } catch (NumberFormatException nfe) {
                redirect(uri: '/')
                return
            }

            profileInstance = Profile.get(params.id)
        }

        if (!profileInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'profile.label', default: 'Profile'), params.id])
            redirect(uri: '/')
            return
        }

        List<Plugin> pluginList = Plugin.withCriteria(sort: 'name', order: 'asc') {
            authors {
                eq('email', profileInstance.user.email)
            }
        }

        List<Archetype> archetypeList = Archetype.withCriteria(sort: 'name', order: 'asc') {
            authors {
                eq('email', profileInstance.user.email)
            }
        }

        [
                profileInstance: profileInstance,
                pluginList: pluginList,
                archetypeList: archetypeList
        ]
    }

    def settings() {
        [profileInstance: session.user.profile]
    }
}
