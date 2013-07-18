import com.grailsrocks.emailconfirmation.EmailConfirmationService
import grails.util.Environment
import grails.util.GrailsNameUtils
import griffon.portal.Profile
import griffon.portal.auth.Membership
import griffon.portal.auth.Role
import griffon.portal.auth.User
import griffon.portal.util.MD5
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.grails.rateable.Rateable

class BootStrap {
    EmailConfirmationService emailConfirmationService
    GrailsApplication grailsApplication

    def init = { servletContext ->
        grailsApplication.config.serverURL = grailsApplication.config.grails.serverURL ?: 'http://localhost:8080/' + grailsApplication.metadata.'app.name'

        // Blatantly taken from https://github.com/grails-samples/grails-website/

        def (adminRole, editorRole, observerRole) = setUpRoles()
        User admin = User.findByUsername('admin')
        if (!admin) {
            def password = Environment.current != Environment.PRODUCTION ? 'changeit' : System.getProperty('initial.admin.password')
            if (!password) {
                throw new Exception("""
During the first run you must specify a password to use for the admin account. For example:

grails -Dinitial.admin.password=changeit run-app""")
            } else {
                admin = new User(
                    username: 'admin',
                    password: MD5.encode(password),
                    membership: new Membership(status: Membership.Status.ACCEPTED, reason: 'Artifact portal admin'),
                    fullName: 'Admin',
                    email: 'theaviary@griffon-framework.org'
                )
                admin.profile = new Profile(
                    user: admin,
                    gravatarEmail: admin.email)
                assert admin.addToRoles(adminRole)
                    .addToRoles(editorRole)
                    .addToRoles(observerRole)
                    .save(flush: true, failOnError: true)

            }
        } else if (!admin.roles) {
            admin.addToRoles(adminRole)
                .addToRoles(editorRole)
                .addToRoles(observerRole)
                .save(flush: true, failOnError: true)
        }

        setupEmailConfirmationService()
        fixRateableForPostgres()

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

        user = new User(
            fullName: 'User0',
            email: 'user0@yahoo.com',
            username: 'user0',
            password: MD5.encode('user0'),
            membership: new Membership(
                status: Membership.Status.NOT_REQUESTED,
                reason: 'lorem impsum lorem impsum lorem impsum lorem impsum lorem impsum'
            )
        )
        user.profile = new Profile(
            user: user
        )
        user.save()
    }

    private void setupEmailConfirmationService() {
        emailConfirmationService.onConfirmation = { String email, String uid ->
            User user = User.findByEmail(email)
            String nuid = MD5.encode(email)
            if (nuid == uid) {
                user.profile = new Profile(user: user)
                user.profile.gravatarEmail = user.email
                user.save()
                log.info("User with id $uid has confirmed their email address $email")
                return [controller: "profile", action: "show", id: user.username]
            }

            return {
                flash.message = "We could not confirm email (${email}) as valid."
                redirect(controller: 'user', action: 'signup')
            }
        }

        emailConfirmationService.onInvalid = { String token ->
            //log.warn("User with id $uid failed to confirm email address after 30 days")
            log.warn("Someone tried to confirm email with an invalid token: $token")
        }

        emailConfirmationService.onTimeout = { String email, String uid ->
            log.warn("User with id $uid failed to confirm email address (${email}) after 30 days")
            User.findByEmail(email)?.delete()
        }
    }

    private List<Role> setUpRoles() {
        // Admin role first. Administrator can access all parts of the application.
        def admin = Role.findByName(Role.ADMINISTRATOR) ?: new Role(name: Role.ADMINISTRATOR).save(failOnError: true)
        safelyAddPermission admin, "*"

        // Editor can edit pages, add screencasts, etc.
        def editor = Role.findByName(Role.EDITOR) ?: new Role(name: Role.EDITOR).save(failOnError: true)
        safelyAddPermission editor, 'faqTab:create,edit,save,update'
        safelyAddPermission editor, 'screenshotsTab:create,edit,save,update'

        // Observer: can't do anything that an anonymous user can't do.
        def observer = Role.findByName(Role.OBSERVER) ?: new Role(name: Role.OBSERVER).save(failOnError: true)

        return [admin, editor, observer]
    }

    private void safelyAddPermission(entity, String permission) {
        if (!entity.permissions?.contains(permission)) {
            entity.addToPermissions permission
        }
    }

    private void fixRateableForPostgres() {
        for (domainClass in grailsApplication.domainClasses) {
            if (Rateable.class.isAssignableFrom(domainClass.clazz)) {
                domainClass.clazz.metaClass {
                    'static' {
                        listOrderByAverageRatingFix { Map params = [:] ->
                            if (params == null) params = [:]
                            def clazz = delegate
                            def type = GrailsNameUtils.getPropertyName(clazz)
                            if (params.cache == null) params.cache = true
                            def results = clazz.executeQuery("select r.ratingRef,avg(rating.stars),count(rating.stars) as c from RatingLink as r join r.rating rating where r.type='$type' group by r.ratingRef order by count(rating.stars) desc ,avg(rating.stars) desc", params)
                            if (results?.size()) {
                                def instances = clazz.withCriteria {
                                    inList 'id', results.collect { it[0] }
                                    cache params.cache
                                }
                                return results.collect { r -> instances.find { i -> r[0] == i.id } }
                            } else {
                                return []
                            }
                        }
                    }
                }
            }
        }
    }

    def destroy = {
    }
}
