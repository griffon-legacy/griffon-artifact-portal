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
class User {
    String username
    String password
    String email
    String fullName
    String captcha
    Membership membership
    Profile profile

    Date dateCreated
    Date lastUpdated

    static embedded = ['membership']
    static transients = ['captcha']

    static constraints = {
        username(nullable: false, blank: false, unique: true)
        password(nullable: false, blank: false)
        email(nullable: false, email: true, unique: true)
        fullName(nullable: false, blank: false)
        membership(nullable: false)
        profile(nullable: true)
    }

    String toString() { "${username}:${id}" }
}

class Membership {
    String reason
    Status status = Status.PENDING

    static constraints = {
        reason(nullable: false, blank: true, minSize: 20, maxSize: 1000)
        status(nullable: false)
    }

    static enum Status {
        PENDING,
        ACCEPTED,
        REJECTED
    }
}