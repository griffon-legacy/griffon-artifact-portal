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

import griffon.portal.auth.Membership
import griffon.portal.auth.User

/**
 * @author Andres Almiray
 */
class AdminController {
    def index() {
        redirect(action: 'list')
    }

    def list() {
        if (!User.hasAdminRole(session.user)) redirect(uri: '/')
        [users: User.listOrderByUsername(params), userCount: User.count()]
    }

    def show() {
        if (!User.hasAdminRole(session.user)) redirect(uri: '/')
        if (!params.id) {
            redirect(action: 'list')
            return
        }
        [user: User.findByUsername(params.id)]
    }

    def save() {
        if (!User.hasAdminRole(session.user)) redirect(uri: '/')
        if (!params.id) {
            redirect(action: 'list')
            return
        }
        User userInstance = User.findByUsername(params.id)
        if (!userInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])
            redirect(action: 'list')
            return
        }
        userInstance.properties = params.properties
        userInstance.profile.notifications.watchlist = params["profile.notifications.watchlist"] != null
        userInstance.profile.notifications.content = params["profile.notifications.content"] != null
        userInstance.profile.notifications.comments = params["profile.notifications.comments"] != null

        if (!userInstance.save()) {
            return render(view: 'show', model: [user: userInstance])
        }
        flash.message = message(code: 'admin.user.save.success', args: [params.id])
        redirect(action: "show", id: userInstance.username)
    }

    def delete() {
        if (!User.hasAdminRole(session.user)) redirect(uri: '/')
        if (!params.id) {
            redirect(action: 'list')
            return
        }
        User userInstance = User.findByUsername(params.id)
        if (!userInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])
            redirect(action: 'list')
            return
        }
        userInstance.delete()
        flash.message = message(code: 'admin.user.delete.success', args: [params.id])
        redirect(action: 'list')
    }

    def changeMembership() {
        if (!User.hasAdminRole(session.user)) redirect(uri: '/')
        if (!params.id) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])
            response.status = 404
            render(template: "/shared/errors_and_messages", model: [cssClass: 'span16'])
        }
        if (!params.status) {
            flash.message = message(code: 'admin.user.changeMembership.nostatus', args: [params.id])
            response.status = 400
            render(template: "/shared/errors_and_messages", model: [cssClass: 'span16'])
        }
        User userInstance = User.findByUsername(params.id)
        if (!userInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])
            response.status = 404
            render(template: "/shared/errors_and_messages", model: [cssClass: 'span16'])
        }
        try {
            Membership.Status status = Membership.Status.valueOf(Membership.Status, params.status)
            userInstance.membership.status = status
            userInstance.save()
            render(template: "membership", model: ['user': params.id, 'currentStatus': params.status])
        } catch (IllegalArgumentException e) {
            flash.message = message(code: 'admin.user.changeMembership.wrongstatus', args: [params.status])
            response.status = 400
            render(template: "/shared/errors_and_messages", model: [cssClass: 'span16'])
        }
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
