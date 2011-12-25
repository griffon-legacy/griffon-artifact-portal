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

import com.grailsrocks.emailconfirmation.EmailConfirmationService
import grails.converters.JSON
import griffon.portal.auth.User
import griffon.portal.util.MD5
import groovy.text.SimpleTemplateEngine
import org.apache.commons.lang.RandomStringUtils
import org.grails.mail.MailService
import org.grails.plugin.jcaptcha.JcaptchaService

/**
 * @author Andres Almiray
 */
class UserController {
    JcaptchaService jcaptchaService
    MailService mailService
    EmailConfirmationService emailConfirmationService

    def login(LoginCommand command) {
        if (!params.username || !params.passwd) {
            // renders 1st hit
            render(view: 'signin', model: [command: new LoginCommand()])
            return
        }

        if (!command.validate()) {
            // renders with errors
            render(view: 'signin', model: [command: command])
            return
        }

        User user = User.findWhere(username: params.username,
                password: MD5.encode(params.passwd))
        if (user) {
            if (!user.profile) {
                render(view: 'subscribe', model: [userInstance: user])
                return
            }
            session.user = user
            session.profile = user.profile
            if (params.originalURI) {
                redirect(uri: params.originalURI)
            } else {
                redirect(controller: 'profile', action: 'show', params: [id: user.username])
            }
            return
        } else {
            command.errors.rejectValue('username', 'griffon.portal.auth.User.credentials.nomatch.message')
            render(view: 'signin', model: [command: command, originalURI: params.orinialURI])
        }
    }

    def logout() {
        session.user = null
        session.profile = null
        redirect(uri: '/')
    }

    def signup() {
        [userInstance: new User(params)]
    }

    def subscribe() {
        User user = new User(params)

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

        emailConfirmationService.sendConfirmation(
                user.email,
                'Please confirm',
                [from: grailsApplication.config.grails.mail.default.from],
                MD5.encode(user.email)
        )

        [userInstance: user]
    }

    def membership() {
        User user = User.get(params.id)
        user.membership.reason = params.reason
        if (!user.save(flush: true)) {
            render([code: 'ERROR'] as JSON)
        } else {
            if (user.membership.status != Membership.Status.PENDING) {
                user.membership.status = Membership.Status.PENDING
                user.save()
            }
            render([code: 'OK'] as JSON)
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

    def forgot_password(ForgotPasswordCommand command) {
        if (!params.username || !params.captcha) {
            render(view: 'forgot_password', model: [command: new ForgotPasswordCommand()])
            return
        }

        if (!command.validate()) {
            render(view: 'forgot_password', model: [command: command])
            return
        }

        if (!jcaptchaService.validateResponse('image', session.id, command.captcha)) {
            command.errors.rejectValue('captcha', 'griffon.portal.User.invalid.captcha.message')
            render(view: 'forgot_password', model: [command: command])
            return
        }

        User user = User.findByUsername(command.username)
        if (!user) {
            command.errors.rejectValue('username', 'griffon.portal.User.username.notfound.message')
            render(view: 'forgot_password', model: [command: command])
            return
        }

        sendCredentials(user)
        flash.message = "Please check your email (${user.email}) for further instructions."
        command.captcha = ''
        [command: command]
    }

    def forgot_username(ForgotUsernameCommand command) {
        if (!params.email || !params.captcha) {
            render(view: 'forgot_username', model: [command: new ForgotUsernameCommand()])
            return
        }

        if (!command.validate()) {
            render(view: 'forgot_username', model: [command: command])
            return
        }

        if (!jcaptchaService.validateResponse('image', session.id, command.captcha)) {
            command.errors.rejectValue('captcha', 'griffon.portal.User.invalid.captcha.message')
            render(view: 'forgot_username', model: [command: command])
            return
        }

        User user = User.findByEmail(command.email)
        if (!user) {
            command.errors.rejectValue('email', 'griffon.portal.User.email.notfound.message')
            render(view: 'forgot_username', model: [command: command])
            return
        }

        sendCredentials(user)
        flash.message = "Please check your email (${user.email}) for further instructions."
        command.captcha = ''
        [command: command]
    }

    private void sendCredentials(User user) {
        String newPassword = RandomStringUtils.randomAlphanumeric(8)
        user.password = MD5.encode(newPassword)
        user.save()

        SimpleTemplateEngine template = new SimpleTemplateEngine()
        mailService.sendMail {
            to user.email
            subject 'Password Reset'
            html template.createTemplate(grailsApplication.config.template.forgot.credentials.toString()).make(
                    ipaddress: request.remoteAddr,
                    serverURL: grailsApplication.config.serverURL,
                    username: user.username,
                    password: newPassword
            ).toString()
        }
    }
}

class LoginCommand {
    String username
    String passwd

    static constraints = {
        username(nullable: false, blank: false)
        passwd(nullable: false, blank: false)
    }
}

class ForgotPasswordCommand {
    String username
    String captcha

    static constraints = {
        username(nullable: false, blank: false)
        captcha(nullable: false, blank: false)
    }
}

class ForgotUsernameCommand {
    String email
    String captcha

    static constraints = {
        email(nullable: false, email: true)
        captcha(nullable: false, blank: false)
    }
}