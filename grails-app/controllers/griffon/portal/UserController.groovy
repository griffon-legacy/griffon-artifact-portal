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

import griffon.portal.util.MD5

/**
 * @author Andres Almiray
 */
class UserController {
    def jcaptchaService

    def login() {
        User user = User.findWhere(username: params.username,
                password: MD5.encode(params.passwd))
        if (user) {
            session.user = user
            redirect(controller: 'profile', action: 'show', params: [id: user.id])
            return
        } else {
            redirect(action: 'signup')
        }
    }

    def logout() {
        session.user = null
        redirect(uri: '/')
    }

    def signup() {
        [userInstance: new User(params)]
    }

    def subscribe() {
        User user = new User(params)
        user.profile = new Profile(
                user: user,
                gravatarEmail: user.email,
        )

        if (!jcaptchaService.validateResponse('image', session.id, user.captcha)) {
            user.errors.rejectValue('captcha', 'griffon.portal.User.invalid.captcha.message')
            redirect(action: 'signup', model: [userInstance: user])
            return
        }

        user.password = MD5.encode(params.password)
        if (!user.save(flush: true)) {
            user.password = params.password
            redirect(action: 'signup', model: [userInstance: user])
            return
        }

        redirect(controller: 'profile', action: 'show', id: user.username)
    }

    def pending() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        String query = 'from User as u where u.membership.status = :status'
        List userInstanceList = User.findAll(query, [status: Membership.Status.PENDING], params)
        [userInstanceList: userInstanceList, userInstanceTotal: userInstanceList.size()]
    }

    def approveOrReject() {
        User user = User.get(params.id)
        user.membership.status = params.status
        user.save()
        redirect(action: 'pending')
    }
}