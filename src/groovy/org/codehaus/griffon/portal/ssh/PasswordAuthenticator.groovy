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

package org.codehaus.griffon.portal.ssh

import griffon.portal.Membership
import griffon.portal.User
import griffon.portal.util.MD5
import org.apache.sshd.server.session.ServerSession

/**
 * @author Andres Almiray
 */
class PasswordAuthenticator implements org.apache.sshd.server.PasswordAuthenticator {
    boolean authenticate(String pUsername, String pPassword, ServerSession serverSession) {
        User.findWhere(username: pUsername,
                password: MD5.encode(pPassword),
                'membership.status': Membership.Status.ACCEPTED) != null
    }
}
