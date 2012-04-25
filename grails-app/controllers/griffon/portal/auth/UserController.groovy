package griffon.portal.auth

import com.grailsrocks.emailconfirmation.EmailConfirmationService
import grails.converters.JSON
import grails.plugin.mail.MailService
import griffon.portal.ForgotPasswordCommand
import griffon.portal.ForgotUsernameCommand
import griffon.portal.LoginCommand
import griffon.portal.SignupCommand
import griffon.portal.util.MD5
import org.apache.commons.lang.RandomStringUtils
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.grails.plugin.jcaptcha.JcaptchaService

/**
 * @author Andres Almiray
 */
class UserController {
    JcaptchaService jcaptchaService
    MailService mailService
    EmailConfirmationService emailConfirmationService
    GrailsApplication grailsApplication

    def login(LoginCommand command) {
        if (!params.filled) {
            // renders 1st hit
            render(view: 'signin', model: [command: new LoginCommand()])
            return
        }

        if (!command.validate()) {
            // renders with errors
            render(view: 'signin', model: [command: command])
            return
        }

        User user = User.findWhere(username: command.username,
                password: MD5.encode(command.passwd))
        if (!user) {
            command.errors.rejectValue('username', 'griffon.portal.auth.User.username.nomatch.message')
            render(view: 'signin', model: [command: command, originalURI: params.orinialURI])
            return
        }

        session.user = user
        session.profile = user.profile

        if (user.username == 'admin') {
            redirect(controller: 'admin', action: 'index')
            return
        } else if (!user.profile) {
            render(view: 'subscribe', model: [userInstance: user])
            return
        }
        if (params.originalURI) {
            redirect(uri: params.originalURI)
        } else {
            redirect(controller: "profile", action: "show", id: user.username)
        }
    }

    def logout() {
        session.user = null
        session.profile = null
        redirect(uri: '/')
    }

    def signup(SignupCommand command) {
        if (!params.filled) {
            render(view: 'signup', model: [command: new SignupCommand()])
            return
        }

        if (!command.validate()) {
            render(view: 'signup', model: [command: command])
            return
        }

        if (!jcaptchaService.validateResponse('image', session.id, command.captcha)) {
            command.errors.rejectValue('captcha', 'griffon.portal.auth.User.invalid.captcha.message')
            render(view: 'signup', model: [command: command])
            return
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
            render(view: 'forgot_password', model: [command: new ForgotPasswordCommand()])
            return
        }

        if (!command.validate()) {
            render(view: 'forgot_password', model: [command: command])
            return
        }

        if (!jcaptchaService.validateResponse('image', session.id, command.captcha)) {
            command.errors.rejectValue('captcha', 'griffon.portal.auth.User.invalid.captcha.message')
            render(view: 'forgot_password', model: [command: command])
            return
        }

        User user = User.findByUsername(command.username)
        if (!user) {
            command.errors.rejectValue('username', 'griffon.portal.auth.User.username.notfound.message')
            render(view: 'forgot_password', model: [command: command])
            return
        }

        sendCredentials(user)
        flash.message = "Please check your email (${user.email}) for further instructions."
        command.captcha = ''
        [command: command]
    }

    def forgot_username(ForgotUsernameCommand command) {
        if (!params.filled) {
            render(view: 'forgot_username', model: [command: new ForgotUsernameCommand()])
            return
        }

        if (!command.validate()) {
            render(view: 'forgot_username', model: [command: command])
            return
        }

        if (!jcaptchaService.validateResponse('image', session.id, command.captcha)) {
            command.errors.rejectValue('captcha', 'griffon.portal.auth.User.invalid.captcha.message')
            render(view: 'forgot_username', model: [command: command])
            return
        }

        User user = User.findByEmail(command.email)
        if (!user) {
            command.errors.rejectValue('email', 'griffon.portal.auth.User.email.notfound.message')
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
