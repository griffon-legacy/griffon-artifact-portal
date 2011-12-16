package griffon.portal

class ProfileController {
    static defaultAction = 'show'

    def show() {
        if (!params.id) {
            redirect(uri: '/')
            return
        }

        // attempt username resolution first
        Profile profileInstance = User.findByUsername(params.id)?.profile
        if (!profileInstance) {
            // attempt id resolution next
            try {
                Long.parseLong(params.id)
            } catch (NumberFormatException nfe) {
                redirect(uri: '/')
                return
            }

            profileInstance = Profile.get(params.id)
        }

        if (!profileInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'profile.label', default: 'Profile'), params.id])
            redirect(uri: '/')
            return
        }

        List<Plugin> pluginList = Plugin.withCriteria(sort: 'name', order: 'asc') {
            authors {
                eq('email', profileInstance.user.email)
            }
        }

        List<Archetype> archetypeList = Archetype.withCriteria(sort: 'name', order: 'asc') {
            authors {
                eq('email', profileInstance.user.email)
            }
        }

        [
                profileInstance: profileInstance,
                pluginList: pluginList,
                archetypeList: archetypeList
        ]
    }
}
