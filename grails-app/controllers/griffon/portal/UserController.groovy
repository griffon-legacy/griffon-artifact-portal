package griffon.portal

import griffon.portal.util.MD5

class UserController {
    def jcaptchaService

    def login() {
        User user = User.findWhere(username: params.username,
                password: MD5.encode(params.password),
                'membership.status': Membership.Status.ACCEPTED)
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
        user.membership = new Membership(params)

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

        [userInstance: user]
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
        user.profile = new Profile(
                user: user,
                gravatarEmail: user.email,
        )
        user.save()
        redirect(action: 'pending')
    }
}