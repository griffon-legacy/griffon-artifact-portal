/*
 * Copyright 2011-2012 the original author or authors.
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

import grails.plugin.executor.PersistenceContextExecutorWrapper
import grails.plugin.mail.MailService
import grails.util.GrailsNameUtils
import grails.util.GrailsUtil
import griffon.portal.auth.User
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.twitter4j.grails.plugin.Twitter4jService

/**
 * @author Andres Almiray
 */
class NotifyService {
    GrailsApplication grailsApplication
    Twitter4jService twitter4jService
    PersistenceContextExecutorWrapper executorService
    MailService mailService

    void tweetRelease(String type, String name, String version) {
        try {
            if (grailsApplication.config.twitter.enabled) {
                String url = "${grailsApplication.config.grails.serverURL}/${type}/${name}"
                twitter4jService.updateStatus("#griffon $name $version released $url")
            }
        } catch (Exception e) {
            log.error("Could not update Twitter status for ${name}-${version}", e)
        }
    }

    void notifyWatchers(Release release, String poster) {
        Watcher watcher = Watcher.findByArtifact(release.artifact)
        if (watcher?.users) {
            List users = watcher.users.collect([]) { User user ->
                [username: user.username, email: user.email, notify: user.profile.notifications.watchlist]
            }
            String serverURL = grailsApplication.config.serverURL
            Map data = [
                    type: release.artifact.type,
                    name: release.artifact.name,
                    version: release.artifactVersion
            ]
            executorService.withoutPersistence {
                users.each { user ->
                    if (!user.notify || poster == user.username) return

                    try {
                        mailService.sendMail {
                            to user.email
                            subject "[ANN] ${GrailsNameUtils.getNaturalName(data.type)} ${data.name}-${data.version} released"
                            html(view: '/email/releasePosted',
                                    model: [
                                            serverURL: serverURL,
                                            capitalizedType: GrailsNameUtils.getNaturalName(data.type),
                                            capitalizedName: GrailsNameUtils.getNaturalName(data.name),
                                            name: data.name,
                                            version: data.version,
                                            type: data.type,
                                            poster: poster,
                                            username: user.username
                                    ]
                            )
                        }
                    } catch (Exception e) {
                        log.error("An error ocurred while sending release update (${data.name}-${data.version}) to ${user.email} (${user.username})", GrailsUtil.sanitize(e))
                    }
                }
            }
        }
    }

    void notifyOnNewComment(Artifact artifact, User poster) {
        List users = Artifact.findAllAuthorsAsUsers(artifact).collect([]) { User user ->
            [username: user.username, email: user.email, notify: user.profile.notifications.comments]
        }

        String serverURL = grailsApplication.config.serverURL
        Map data = [
                type: artifact.type,
                name: artifact.name,
        ]
        executorService.withoutPersistence {
            users.each { user ->
                if (!user.notify || poster.username == user.username) return

                try {
                    mailService.sendMail {
                        to user.email
                        subject "New comment on ${data.type} ${GrailsNameUtils.getNaturalName(data.name)}"
                        html(view: '/email/commentPosted',
                                model: [
                                        serverURL: serverURL,
                                        capitalizedType: GrailsNameUtils.getNaturalName(data.type),
                                        capitalizedName: GrailsNameUtils.getNaturalName(data.name),
                                        name: data.name,
                                        type: data.type,
                                        poster: poster,
                                        username: user.username
                                ]
                        )
                    }
                } catch (Exception e) {
                    log.error("An error ocurred while sending comment update (${data.name}) to ${user.email} (${user.username})", GrailsUtil.sanitize(e))
                }
            }
        }
    }
}
