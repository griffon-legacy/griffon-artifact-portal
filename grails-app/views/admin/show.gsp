<!doctype html>
<html>
<head>
    <theme:layout name="plain"/>
    <theme:title text="admin.user.show.label"/>
</head>

<body>

<theme:zone name="body">
    <tmpl:/shared/pageheader>
        <h2><g:message code="admin.user.show.message"
                       args="[user.username]"/></h2>
    </tmpl:/shared/pageheader>

    <g:render template="/shared/errors_and_messages"
              model="[bean: user]"/>

    <ui:form action="save">
        <g:hiddenField name="id" value="${user.username}"/>

        <div class="clearfix">
            <h2>User</h2>
        </div>
        <g:render template="/shared/form_field"
                  model="[bean: user, field: 'username']"/>

        <g:render template="/shared/form_field"
                  model="[bean: user, field: 'fullName']"/>

        <g:render template="/shared/form_field"
                  model="[bean: user, field: 'email']"/>

        <ui:field bean="${user}" name="membership.status">
            <ui:fieldLabel><label for="membership.status"
                                  class="control-label">Membership</label></ui:fieldLabel>
            <ui:fieldInput>
                <g:select name="membership.status" class="input-xlarge"
                          from="${griffon.portal.auth.Membership.Status.values()}"
                          value="${user.membership.status}" required=""/>
            </ui:fieldInput>
            <ui:fieldErrors></ui:fieldErrors>
        </ui:field>

        <g:if test="${user.profile}">
            <div class="clearfix">
                <h2>Profile</h2>
                <ui:field bean="${user.profile}" name="profile.gravatarEmail">
                    <ui:fieldLabel><label for="profile.gravatarEmail"
                                          class="control-label">Avatar</label></ui:fieldLabel>
                    <ui:fieldInput>
                        <g:textField name="profile.gravatarEmail"
                                     required="true"
                                     class="input-xlarge"
                                     value="${user.profile.gravatarEmail}"/>
                    </ui:fieldInput>
                    <ui:fieldErrors></ui:fieldErrors>
                </ui:field>

                <ui:field bean="${user.profile}" name="profile.website">

                    <ui:fieldInput>
                        <g:textField name="profile.website" required="true"
                                     class="input-xlarge"
                                     value="${user.profile.website}"/>
                    </ui:fieldInput>
                    <ui:fieldErrors></ui:fieldErrors>
                </ui:field>

                <ui:field bean="${user.profile}" name="profile.twitter">
                    <ui:fieldInput>
                        <g:textField name="profile.twitter" required="true"
                                     class="input-xlarge"
                                     value="${user.profile.twitter}"/>
                    </ui:fieldInput>
                    <ui:fieldErrors></ui:fieldErrors>
                </ui:field>

                <ui:field bean="${user.profile}" name="profile.bio">
                    <ui:fieldInput>
                        <g:textArea name="profile.bio" cols="40" rows="3"
                                    maxlength="1000"
                                    class="input-xxlarge"
                                    value="${user.profile.bio}"/>
                    </ui:fieldInput>
                    <ui:fieldErrors></ui:fieldErrors>
                </ui:field>
            </div>

            <div class="clearfix">
                <h2>Notifications</h2>

                <ui:field bean="${user.profile.notifications}"
                          name="profile.notifications.watchlist">
                    <ui:fieldLabel><label for="profile.notifications.watchlist"
                                          class="control-label">Watchlist</label></ui:fieldLabel>
                    <ui:fieldInput>
                        <g:checkBox name="profile.notifications.watchlist"
                                    value="${user.profile.notifications.watchlist}"/> Enable all items in watchlist.
                    </ui:fieldInput>
                    <ui:fieldErrors></ui:fieldErrors>
                </ui:field>

                <ui:field bean="${user.profile.notifications}"
                          name="profile.notifications.content">
                    <ui:fieldLabel><label for="profile.notifications.content"
                                          class="control-label">Content Updates</label></ui:fieldLabel>
                    <ui:fieldInput>
                        <g:checkBox name="profile.notifications.content"
                                    value="${user.profile.notifications.content}"/>  Notify user when his content is updated.
                    </ui:fieldInput>
                    <ui:fieldErrors></ui:fieldErrors>
                </ui:field>

                <ui:field bean="${user.profile.notifications}"
                          name="profile.notifications.comments">
                    <ui:fieldLabel><label for="profile.notifications.comments"
                                          class="control-label">Comments</label></ui:fieldLabel>
                    <ui:fieldInput>
                        <g:checkBox name="profile.notifications.comments"
                                    value="${user.profile.notifications.comments}"/> Notify user when a comment is posted.
                    </ui:fieldInput>
                    <ui:fieldErrors></ui:fieldErrors>
                </ui:field>
            </div>

        </g:if>
        <ui:actions>
            <ui:button mode="inverse">Save</ui:button>
        </ui:actions>
    </ui:form>

</theme:zone>
</body>
</html>