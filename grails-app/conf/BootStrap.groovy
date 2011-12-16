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

        Author author = new Author(
                name: 'Andres Almiray',
                email: 'aalmiray@yahoo.com'
        )
        author.save()
        Plugin plugin = new Plugin(
                name: 'miglayout',
                title: 'Adds Miglayout support to Views',
                description: 'Miglayout support http://miglayout.com',
                license: 'Apache Software License 2.0',
                toolkits: 'swing'
        )
        plugin.addToAuthors(author)
        plugin.save()

        new Release(
                artifactVersion: '0.1',
                griffonVersion: '0.9.3 > *',
                comment: 'First release',
                artifact: plugin
        ).save()
        new Release(
                artifactVersion: '0.2',
                griffonVersion: '0.9.3 > *',
                comment: 'Second release',
                artifact: plugin
        ).save()
    }
    def destroy = {
    }
}
