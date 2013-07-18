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

package griffon.portal.auth

import com.grailsrocks.emailconfirmation.EmailConfirmationService
import grails.converters.JSON
import grails.plugin.mail.MailService
import grails.validation.Validateable
import griffon.portal.util.MD5
import org.apache.commons.lang.RandomStringUtils
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.grails.plugin.jcaptcha.JcaptchaService

/**
 * @author Andres Almiray
 */
class UserController {
    static navigationScope = 'hidden'

    JcaptchaService jcaptchaService
    MailService mailService
    EmailConfirmationService emailConfirmationService
    GrailsApplication grailsApplication

    def login(LoginCommand command) {
        if (!params.filled) {
            // renders 1st hit
            return render(view: 'signin', model: [command: new LoginCommand()])
        }

        if (!command.validate()) {
            // renders with errors
            return render(view: 'signin', model: [command: command])
        }

        User user = User.findWhere(username: command.username,
                password: MD5.encode(command.passwd))
        if (!user) {
            command.errors.rejectValue('username', 'griffon.portal.auth.User.username.nomatch.message')
            return render(view: 'signin', model: [command: command, originalURI: params.orinialURI])
        }

        session.user = user
        session.profile = user.profile

        if (user.username == 'admin') {
            return redirect(controller: 'admin', action: 'index')
        } else if (!user.profile) {
            return render(view: 'subscribe', model: [userInstance: user])
        }
        if (params.originalURI) {
            redirect(uri: params.originalURI)
        } else {
            redirect(controller: 'profile', action: 'show', id: user.username)
        }
    }

    def logout() {
        session.user = null
        session.profile = null
        redirect(uri: '/')
    }

    def signup(SignupCommand command) {
        if (!params.filled) {
            return render(view: 'signup', model: [command: new SignupCommand()])
        }

        if (!command.validate()) {
            return render(view: 'signup', model: [command: command])
        }

        if (!jcaptchaService.validateResponse('image', session.id, command.captcha)) {
            command.errors.rejectValue('captcha', 'griffon.portal.auth.User.invalid.captcha.message')
            return render(view: 'signup', model: [command: command])
        }

        User user = new User()
        user.properties = command.properties
        user.membership.status = Membership.Status.NOT_REQUESTED
        user.password = MD5.encode(user.password)
        if (!user.save(flush: true)) {
            user.errors.fieldErrors.each { error ->
                command.errors.rejectValue(
                        error.field,
                        error.code,
                        error.arguments,
                        error.defaultMessage
                )
            }
            command.password = params.password
            render(view: 'signup', model: [command: command])
            return
        }

        emailConfirmationService.sendConfirmation(
                user.email,
                'Please confirm your email',
                [
                        from: grailsApplication.config.grails.mail.default.from,
                        user: user.username,
                        portalUrl: grailsApplication.config.serverURL,
                        view: '/email/confirmationRequest'
                ],
                MD5.encode(user.email)
        )

        render(view: 'subscribe', model: [userInstance: user])
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

    def forgot_password(ForgotPasswordCommand command) {
        if (!params.filled) {
            return render(view: 'forgot_password', model: [command: new ForgotPasswordCommand()])
        }

        if (!command.validate()) {
            return render(view: 'forgot_password', model: [command: command])
        }

        if (!jcaptchaService.validateResponse('image', session.id, command.captcha)) {
            command.errors.rejectValue('captcha', 'griffon.portal.auth.User.invalid.captcha.message')
            return render(view: 'forgot_password', model: [command: command])
        }

        User user = User.findByUsername(command.username)
        if (!user) {
            command.errors.rejectValue('username', 'griffon.portal.auth.User.username.notfound.message')
            return render(view: 'forgot_password', model: [command: command])
        }

        sendCredentials(user)
        flash.message = "Please check your email (${user.email}) for further instructions."
        command.captcha = ''
        [command: command]
    }

    def forgot_username(ForgotUsernameCommand command) {
        if (!params.filled) {
            return render(view: 'forgot_username', model: [command: new ForgotUsernameCommand()])
        }

        if (!command.validate()) {
            return render(view: 'forgot_username', model: [command: command])
        }

        if (!jcaptchaService.validateResponse('image', session.id, command.captcha)) {
            command.errors.rejectValue('captcha', 'griffon.portal.auth.User.invalid.captcha.message')
            return render(view: 'forgot_username', model: [command: command])
        }

        User user = User.findByEmail(command.email)
        if (!user) {
            command.errors.rejectValue('email', 'griffon.portal.auth.User.email.notfound.message')
            return render(view: 'forgot_username', model: [command: command])
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

        mailService.sendMail {
            to user.email
            subject 'Password Reset'
            html(view: '/email/forgotCredentials',
                    model: [
                            ipaddress: request.remoteAddr,
                            serverURL: grailsApplication.config.serverURL,
                            username: user.username,
                            password: newPassword
                    ]
            )
        }
    }
}

@Validateable
class SignupCommand {
    boolean filled
    String username
    String fullName
    String email
    String password
    String password2
    String captcha

    static constraints = {
        username(nullable: false, blank: false)
        fullName(nullable: false, blank: true)
        email(nullable: false, blank: false, email: true)
        password(nullable: false, blank: false)
        password2(nullable: false, blank: false)
        captcha(nullable: false, blank: false)
    }
}

@Validateable
class LoginCommand {
    boolean filled
    String username
    String passwd

    static constraints = {
        username(nullable: false, blank: false)
        passwd(nullable: false, blank: false)
    }
}

@Validateable
class ForgotPasswordCommand {
    boolean filled
    String username
    String captcha

    static constraints = {
        username(nullable: false, blank: false)
        captcha(nullable: false, blank: false)
    }
}

@Validateable
class ForgotUsernameCommand {
    boolean filled
    String email
    String captcha

    static constraints = {
        email(nullable: false, email: true)
        captcha(nullable: false, blank: false)
    }
}