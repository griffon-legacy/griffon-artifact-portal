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

package griffon.portal.auth

import griffon.portal.Profile

/**
 * @author Andres Almiray
 */
class User {
    String username
    String password
    String email
    String fullName = ''
    Membership membership = new Membership()

    Date dateCreated
    Date lastUpdated

    static hasOne = [profile: Profile]
    static embedded = ['membership']
    static hasMany = [roles: Role, permissions: String]

    static constraints = {
        username(nullable: false, blank: false, unique: true)
        password(nullable: false, blank: false)
        email(nullable: false, email: true, unique: true)
        fullName(nullable: false, blank: true)
        membership(nullable: false)
        profile(nullable: true)
    }

    String toString() {
        [
                id: id,
                username: username,
                email: email,
                fullName: fullName,
                membership: membership?.status,
                profileId: profile?.id
        ]
    }

    static boolean hasAdminRole(User user) {
        if (user == null) return false
        Role adminRole = Role.findByName(Role.ADMINISTRATOR)
        user = User.findByUsername(user.username)
        user.roles.contains(adminRole)
    }
}

class Membership {
    String reason
    Status status = Status.NOT_REQUESTED

    static constraints = {
        reason(nullable: true, blank: false, minSize: 20, maxSize: 1000)
        status(nullable: false)
    }

    static enum Status {
        NOT_REQUESTED,
        PENDING,
        ACCEPTED,
        REJECTED
    }
}