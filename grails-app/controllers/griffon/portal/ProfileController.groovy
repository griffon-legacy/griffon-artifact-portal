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

import grails.validation.Validateable
import griffon.portal.auth.User
import griffon.portal.util.MD5
import griffon.portal.values.ProfileTab
import griffon.portal.values.SettingsTab

/**
 * @author Andres Almiray
 */
class ProfileController {
    static defaultAction = 'show'

    def index() {
        if (session.user) {
            return redirect(action: 'show', params: [id: session.user.username])
        }
        return redirect(uri: '/')
    }

    def show() {
        if (!params.id) {
            println "Going back to root"
            return redirect(uri: '/')
        }

        params.id = params.id == 'show' ? session.user?.username : params.id

        // attempt username resolution first
        Profile profileInstance = User.findByUsername(params.id)?.profile
        println profileInstance
        if (!profileInstance) {
            // attempt id resolution next
            try {
                Long.parseLong(params.id)
            } catch (NumberFormatException nfe) {
                return redirect(uri: '/')
            }

            profileInstance = Profile.get(params.id)
        }

        println profileInstance
        if (!profileInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'profile.label', default: 'Profile'), params.id])
            return redirect(uri: '/')
        }

        boolean loggedIn = profileInstance.user.username == session.user?.username

        params.tab = params.tab ?: ProfileTab.PLUGINS.name

        Map qparams = [
            max: params.max ?: 10,
            offset: params.offset ?: 0
        ]

        // don't let strangers see watchlists
        if (!loggedIn && params.tab == ProfileTab.WATCHLIST.name) {
            params.tab = ProfileTab.PLUGINS.name
        }

        List<Plugin> pluginList = Plugin.createCriteria().list(qparams) {
            authors {
                eq('email', profileInstance.user.email)
            }
            order('name', 'asc')
        }


        List<Archetype> archetypeList = Archetype.createCriteria().list(qparams) {
            authors {
                eq('email', profileInstance.user.email)
            }
            order('name', 'asc')
        }

        List watchers = Watcher.withCriteria {
            users {
                eq('username', profileInstance.user.username)
            }
        }
        List watchlistList = watchers.collect([]) { watcher -> watcher.artifact }
        watchlistList.sort(true) { it.name }

        [
            profileInstance: profileInstance,
            pluginList: pluginList,
            archetypeList: archetypeList,
            pluginTotal: pluginList.totalCount,
            archetypeTotal: archetypeList.totalCount,
            tab: params.tab,
            watchlistList: watchlistList,
            loggedIn: loggedIn
        ]
    }

    def settings() {
        if (!session.user) {
            return redirect(uri: '/')
        }

        params.tab = params.tab ?: SettingsTab.PROFILE.name

        def command = null
        switch (params.tab) {
            case SettingsTab.ACCOUNT.name:
                command = new UpdateAccountCommand(
                    fullName: session.user.fullName,
                    email: session.user.email
                )
                break
            case SettingsTab.PROFILE.name:
                command = new UpdateProfileCommand(
                    bio: session.profile.bio,
                    gravatarEmail: session.profile.gravatarEmail,
                    website: session.profile.website,
                    twitter: session.profile.twitter
                )
                break
            case SettingsTab.PASSWORD.name:
                command = new UpdatePasswordCommand()
                break
            case SettingsTab.NOTIFICATIONS.name:
                command = new UpdateNotificationsCommand(
                    watchlist: session.profile.notifications.watchlist,
                    content: session.profile.notifications.content,
                    comments: session.profile.notifications.comments
                )
                break
        }

        [
            profileInstance: session.profile,
            tab: params.tab,
            command: command
        ]
    }

    def update_account(UpdateAccountCommand command) {
        if (!command.validate()) {
            return render(view: 'settings', model: [
                profileInstance: Profile.get(params.profileId),
                command: command,
                tab: SettingsTab.ACCOUNT.name])
        }

        User user = User.get(params.userId)
        user.fullName = command.fullName
        user.email = command.email

        if (!user.save(flush: true)) {
            return render(view: 'settings', model: [
                profileInstance: Profile.get(params.profileId),
                command: command,
                tab: SettingsTab.ACCOUNT.name])
        }
        session.user = user

        flash.message = "Account successfully updated"
        redirect(action: 'settings', model: [name: user.username, tab: SettingsTab.ACCOUNT.name])
    }

    def update_profile(UpdateProfileCommand command) {
        Profile profile = Profile.get(params.profileId)
        if (!command.validate()) {
            return render(view: 'settings', model: [
                profileInstance: profile,
                command: command,
                tab: SettingsTab.PROFILE.name])
        }

        profile.bio = command.bio
        profile.gravatarEmail = command.gravatarEmail ?: profile.user.email
        profile.website = command.website
        profile.twitter = command.twitter

        if (!profile.save(flush: true)) {
            return render(view: 'settings', model: [
                profileInstance: profile,
                command: command,
                tab: SettingsTab.PROFILE.name])
        }

        session.profile = profile

        flash.message = "Profile successfully updated"
        redirect(action: 'settings', model: [name: profile.user.username, tab: SettingsTab.PROFILE.name])
    }

    def update_password(UpdatePasswordCommand command) {
        if (!command.validate()) {
            return render(view: 'settings', model: [
                profileInstance: Profile.get(params.profileId),
                command: command,
                tab: SettingsTab.PASSWORD.name])
        }

        User user = User.get(params.userId)
        String passwd = MD5.encode(command.oldPassword)

        if (passwd != user.password) {
            command.errors.rejectValue('password', 'griffon.portal.auth.User.credentials.nomatch.message')
            return render(view: 'settings', model: [
                profileInstance: Profile.get(params.profileId),
                command: command,
                tab: SettingsTab.PASSWORD.name])
        }

        user.password = MD5.encode(command.newPassword)
        user.profile = Profile.get(params.profileId)

        if (!user.save(flush: true)) {
            return render(view: 'settings', model: [
                profileInstance: Profile.get(params.profileId),
                command: command,
                tab: SettingsTab.PASSWORD.name])
        }
        session.user = user

        flash.message = "Password successfully updated"
        redirect(action: 'settings', model: [name: user.username, tab: SettingsTab.PASSWORD.name])
    }

    def update_notifications(UpdateNotificationsCommand command) {
        Profile profile = Profile.get(params.profileId)
        if (!command.validate()) {
            return render(view: 'settings', model: [
                profileInstance: profile,
                command: command,
                tab: SettingsTab.NOTIFICATIONS.name])
        }

        profile.notifications.watchlist = command.watchlist
        profile.notifications.content = command.content
        profile.notifications.comments = command.comments

        if (!profile.save(flush: true)) {
            return render(view: 'settings', model: [
                profileInstance: profile,
                command: command,
                tab: SettingsTab.NOTIFICATIONS.name])
        }

        session.profile = profile

        flash.message = "Notifications successfully updated"
        redirect(action: 'settings', model: [name: profile.user.username, tab: SettingsTab.NOTIFICATIONS.name])
    }
}

@Validateable
class UpdateAccountCommand {
    String fullName
    String email

    static constraints = {
        fullName(nullable: false, blank: false)
        email(nullable: true, email: true, unique: true)
    }
}

@Validateable
class UpdateProfileCommand {
    String bio
    String gravatarEmail
    String website
    String twitter

    static constraints = {
        bio(nullable: true, blank: false, maxSize: 1000)
        gravatarEmail(nullable: true, email: true)
        website(nullable: true, blank: false, url: true)
        twitter(nullable: true, blank: false)
    }
}

@Validateable
class UpdatePasswordCommand {
    String oldPassword
    String newPassword
    String newPassword2

    static constraints = {
        oldPassword(nullable: false, blank: false)
        newPassword(nullable: false, blank: false)
        newPassword2(nullable: false, blank: false)
    }
}

@Validateable
class UpdateNotificationsCommand {
    boolean watchlist
    boolean content
    boolean comments

    static constraints = {
        watchlist(nullable: false, blank: false)
        content(nullable: false, blank: false)
        comments(nullable: false, blank: false)
    }
}