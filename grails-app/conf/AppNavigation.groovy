import griffon.portal.auth.User

navigation = {
    app {
        plugins(uri: '/plugins')
        archetypes(uri: '/archetypes')
        stats()
        api()
        profile(action: 'show', visible: { session.user != null })
        about()
        admin(visible: { User.hasAdminRole(session.user) })
    }

    hidden {
        artifact(visible: false)
        author(visible: false)
        release(visible: false)
        usage(visible: false)
        user(visible: false)
        plugin(visible: false)
        archetype(visible: false)
    }
}