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

package org.codehaus.griffon.portal.ssh

import griffon.portal.Profile
import griffon.portal.auth.Membership
import griffon.portal.auth.User
import griffon.portal.util.MD5
import org.apache.sshd.server.session.ServerSession
import org.slf4j.Logger
import org.slf4j.LoggerFactory

/**
 * @author Andres Almiray
 */
class PasswordAuthenticator implements org.apache.sshd.server.PasswordAuthenticator {
    private static final Logger LOG = LoggerFactory.getLogger(PasswordAuthenticator)

    boolean authenticate(String username, String password, ServerSession serverSession) {
        User user = User.findWhere(username: username,
                password: MD5.encode(password),
                'membership.status': Membership.Status.ACCEPTED)
        if (user) {
            return Profile.findByUser(user) != null
        }
        false
    }
}
