<%@ page import="griffon.portal.values.SettingsTab" %>
<!doctype html>
<html>
<head>
    <theme:layout name="plain"/>
    <g:set var="username" value="${profileInstance.user.username}"/>
    <theme:title><g:message code="griffon.portal.Profile.show.label"
                            args="[username]"/></theme:title>
</head>

<body>
<theme:zone name="body">
    <tmpl:/shared/pageheader>
        <div class="media">
            <a href="#" class="pull-left">
                <ui:avatar user="${profileInstance.gravatarEmail}"
                           size="90"
                           class="media-object img-rounded"/>
            </a>

            <div class="media-body">
                <h3 class="media-heading"><g:fieldValue
                    bean="${profileInstance.user}"
                    field="username"/>'s settings</h3>
            </div>
        </div>
    </tmpl:/shared/pageheader>

    <ui:tabs>
        <g:each in="${SettingsTab.values().flatten()}" var="settingsTab">
            <ui:tab title="${settingsTab.capitalizedName}"
                    active="${tab == settingsTab.name}">
                <g:render template="settings/${settingsTab.name}" model="[
                    command: commands[settingsTab.name],
                    tab: settingsTab.name,
                    profileInstance: profileInstance
                ]"/>
            </ui:tab>
        </g:each>
    </ui:tabs>
</theme:zone>
</body>
</html>
