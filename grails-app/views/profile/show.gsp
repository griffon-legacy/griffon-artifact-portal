<%@ page import="griffon.portal.values.ProfileTab" %>
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
    <g:render template="profile/header"/>

    <%--
    <g:if test="${profileInstance.twitter}">
        <widget:twitter username="${profileInstance.twitter}"/>
    </g:if>
    --%>

    <%
        def tabs = ProfileTab.values().flatten()
        if (!loggedIn) tabs.remove ProfileTab.WATCHLIST
    %>

    <ui:tabs>
        <g:each in="${tabs}" var="profileTab">
            <ui:tab title="${profileTab.capitalizedName}"
                    active="${'Plugins' == profileTab.capitalizedName}">
                <g:render template="/profile/profile/${profileTab}"
                          model="[profileInstance: profileInstance, tab: profileTab, userId: profileInstance.user.username]"/>
            </ui:tab>
        </g:each>
    </ui:tabs>

</theme:zone>
</body>
</html>