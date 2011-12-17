import griffon.portal.util.MD5
import griffon.portal.values.Toolkit
import griffon.portal.*

class BootStrap {
    def init = { servletContext ->
        User user = new User(
                fullName: 'Andres Almiray',
                email: 'aalmiray@yahoo.com',
                username: 'aalmiray',
                password: MD5.encode('foo'),
                membership: new Membership(
                        status: Membership.Status.ACCEPTED,
                        reason: 'lorem impsum lorem impsum lorem impsum lorem impsum lorem impsum'
                )
        )
        user.profile = new Profile(
                user: user,
                gravatarEmail: user.email,
                website: 'http://jroller.com/aalmiray',
                twitter: 'aalmiray'
        )
        user.save()
    }
    def destroy = {
    }
}
