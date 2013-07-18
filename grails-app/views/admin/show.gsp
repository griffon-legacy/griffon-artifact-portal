<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title><g:message code="admin.user.show.label"/></title>
</head>

<body>
<tmpl:/shared/pageheader>
    <h1><g:message code="admin.user.show.label"/></h1>
    <g:message code="admin.user.show.message"/>
</tmpl:/shared/pageheader>

<div class="row">
    <div class="span16">
        <div class="" role="main">
            <div id="messages">
                <g:render template="/shared/errors_and_messages" model="[cssClass: 'span16']"/>
            </div>

            <g:form action="save">
                <g:hiddenField name="id" value="${user.username}"/>
                <div class="span8" style="float: left">
                    <div class="clearfix">
                        <h2>User</h2>
                    </div>

                    <div class="clearfix ${hasErrors(bean: user, field: 'username', 'error')}">
                        <label for="username"><g:message code="user.username.label" default="Username"/></label>

                        <div class="input"><g:textField name="username" value="${user.username}" required=""
                                                        tabindex="1"></g:textField></div>
                    </div>

                    <div class="clearfix ${hasErrors(bean: user, field: 'email', 'error')}">
                        <label for="email"><g:message code="user.email.label" default="Email"/></label>

                        <div class="input"><g:textField name="email" value="${user.email}" required=""
                                                        tabindex="2"></g:textField></div>
                    </div>

                    <div class="clearfix ${hasErrors(bean: user, field: 'fullName', 'error')}">
                        <label for="fullName"><g:message code="user.fullName.label" default="Full name"/></label>

                        <div class="input"><g:textField name="fullName" value="${user.fullName}" required=""
                                                        tabindex="3"></g:textField></div>
                    </div>

                    <div class="clearfix ${hasErrors(bean: user, field: 'membership.status', 'error')}">
                        <label for="membership.status"><g:message code="user.membership.label"
                                                                  default="Membership"/></label>

                        <div class="input"><g:select name="membership.status"
                                                     from="${['ACCEPTED', 'PENDING', 'REJECTED', 'ADMIN', 'NOT_REQUESTED']}"
                                                     value="${user.membership.status}" tabindex="4" required=""/></div>
                    </div>

                    <div class="clearfix ${hasErrors(bean: user, field: 'dateCreated', 'error')}">
                        <label for="dateCreated"><g:message code="user.dateCreated.label"
                                                            default="Creation date"/></label>

                        <div class="input"><g:textField name="dateCreated" value="${user.dateCreated}" readonly="true"
                                                        tabindex="5"></g:textField></div>
                    </div>

                    <div class="clearfix ${hasErrors(bean: user, field: 'lastUpdated', 'error')}">
                        <label for="lastUpdated"><g:message code="user.lastUpdated.label"
                                                            default="Last updated"/></label>

                        <div class="input"><g:textField name="lastUpdated" value="${user.lastUpdated}" readonly="true"
                                                        tabindex="6"></g:textField></div>
                    </div>
                </div>

                <div class="span8" style="float: left">
                    <div class="clearfix">
                        <h2>Profile</h2>
                    </div>

                    <div class="clearfix ${hasErrors(bean: user, field: 'profile.gravatarEmail', 'error')}">
                        <label for="profile.gravatarEmail"><g:message code="user.profile.gravatarEmail.label"
                                                                      default="Gravatar email"/></label>

                        <div class="input"><g:textField name="profile.gravatarEmail"
                                                        value="${user.profile?.gravatarEmail}"
                                                        tabindex="7"></g:textField></div>
                    </div>

                    <div class="clearfix ${hasErrors(bean: user, field: 'profile.bio', 'error')}">
                        <label for="profile.bio"><g:message code="user.profile.bio.label" default="Biography"/></label>

                        <div class="input"><g:textArea name="profile.bio" value="${user.profile?.bio}" rows="5"
                                                       cols="50"
                                                       tabindex="8"/></div>
                    </div>

                    <div class="clearfix ${hasErrors(bean: user, field: 'profile.website', 'error')}">
                        <label for="profile.website"><g:message code="user.profile.website.label"
                                                                default="Website"/></label>

                        <div class="input"><g:textField name="profile.website" value="${user.profile?.website}"
                                                        tabindex="9"></g:textField></div>
                    </div>

                    <div class="clearfix ${hasErrors(bean: user, field: 'profile.twitter', 'error')}">
                        <label for="profile.twitter"><g:message code="user.profile.twitter.label"
                                                                default="Twitter"/></label>

                        <div class="input"><g:textField name="profile.twitter" value="${user.profile?.twitter}"
                                                        tabindex="10"></g:textField></div>
                    </div>
                </div>

                <div class="span16" style="clear: left">
                    <div class="clearfix">
                        <h3>Notifications</h3>
                            <label for="profile.notifications.watchlist"><g:message
                                    code="user.profile.notifications.watchlist.label" default="Watchlist"/></label>
                            <g:checkBox name="profile.notifications.watchlist"
                                        value="${user.profile?.notifications?.watchlist}"
                                        style="float: left; margin: 9px;"/>
                            <label for="profile.notifications.content"><g:message
                                    code="user.profile.notifications.content.label" default="Content"/></label>
                            <g:checkBox name="profile.notifications.content"
                                        value="${user.profile?.notifications?.content}"
                                        style="float: left; margin: 9px;"/>
                            <label for="profile.notifications.comments"><g:message
                                    code="user.profile.notifications.comments.label" default="Comments"/></label>
                            <g:checkBox name="profile.notifications.comments"
                                        value="${user.profile?.notifications?.comments}"
                                        style="float: left; margin: 9px;"/>
                    </div>

                    <div class="actions">
                        <input class="btn btn-inverse" type="submit" value="Save"/>
                    </div>
                </div>
            </g:form>
        </div>
    </div>
</div>
</body>
</html>