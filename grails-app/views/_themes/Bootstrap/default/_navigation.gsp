<%@ page import="griffon.portal.auth.User" %>
<%
    Map menuEntries = [
        'Plugins': [uri: '/plugins', active: {
            controllerName == 'plugin' ||
                (controllerName == 'artifact' && params.type == 'plugin') ||
                (controllerName == 'release' && params.type == 'plugin')
        }],
        'Archetypes': [uri: '/archetypes', active: {
            controllerName == 'archetype' ||
                (controllerName == 'artifact' && params.type == 'archetype') ||
                (controllerName == 'release' && params.type == 'archetype')
        }],
        'Stats': [:],
        'API': [:],
        'Profile': [visible: { session.user != null }],
        'About': [:],
        'Admin': [visible: { User.hasAdminRole(session.user) }]
    ]

    def menuIsVisible = { m ->
        m.containsKey('visible') ? m.visible.call() : true
    }

    def menuIsActive = { m ->
        ((m.containsKey('active') && m.active()) || controllerName == m.name) ? 'active' : ''
    }
%>

<div class="navbar navbar-inverse navbar-fixed-top">
    <div class="navbar-inner">
        <div class="container">
            <button type="button" class="btn btn-navbar" data-toggle="collapse"
                    data-target=".nav-collapse">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="brand" href="${g.createLink(uri: '/')}"><r:img
                uri="/images/griffon-icon-24x24.png" class="logo"
                alt="${applicationName}"/></a>

            <div class="nav-collapse collapse" role="navigation">
                <ul class="nav">
                    <g:each in="${menuEntries}" var="menuEntry">
                        <g:if
                            test="${menuIsVisible(menuEntry.value)}">
                            <%
                                menuEntry.value.name = menuEntry.key.toLowerCase()
                                Map linkArgs = menuEntry.value.uri ? [uri: menuEntry.value.uri] : [controller: menuEntry.value.name]
                            %>
                            <li class="${menuIsActive(menuEntry.value)}">
                                <p:callTag tag="g:link" attrs="${linkArgs}">
                                    ${menuEntry.key}
                                </p:callTag>
                            </li>
                        </g:if>
                    </g:each>
                </ul>

                <g:if test="${session.user}">

                    <div class="btn-group pull-right">
                        <div class="btn-group">
                            <g:link controller="profile" action="show"
                                    id="${session.user.username}"
                                    class="btn btn-small btn-inverse"><ui:avatar
                                user="${session.profile.gravatarEmail}"
                                size="16"/><span
                                class="screen-name">&nbsp;${session.user.username}</span></g:link>
                            <a href="#"
                               class="dropdown-toggle btn btn-small btn-inverse"
                               data-toggle="dropdown"><span
                                class="caret"></span></a>
                            <ul class="dropdown-menu" role="menu">
                                <li><g:link controller="profile"
                                            action="settings">Settings</g:link></li>
                                <li class="divider"></li>
                                <li><g:link controller="user" action="logout"
                                            mapping="logout">Sign out</g:link></li>
                            </ul>
                        </div>
                    </div>

                </g:if>
                <g:else>
                    <div class="btn-group pull-right">
                        <form class="navbar-form">
                            <div class="btn-group">
                                <g:link mapping="login"
                                        class="btn btn-small btn-inverse">Login</g:link>
                                <a href="#"
                                   class="dropdown-toggle btn btn-small btn-inverse"
                                   data-toggle="dropdown"><span
                                    class="caret"></span></a>
                                <ul class="dropdown-menu" role="menu">
                                    <li><g:link controller="user"
                                                action="forgot_password"
                                                mapping="forgot_password">Forgot password?</g:link></li>
                                    <li><g:link controller="user"
                                                action="forgot_username"
                                                mapping="forgot_username">Forgot username?</g:link></li>
                                    <li><g:link controller="user"
                                                action="signup"
                                                mapping="signup">Sign up for an account!</g:link></li>
                                </ul>
                            </div>
                        </form>
                    </div>
                </g:else>
            </div>
        </div>
    </div>
</div>