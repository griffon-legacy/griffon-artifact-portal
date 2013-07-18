<%@ page import="griffon.portal.values.ProfileTab" %>
<!doctype html>
<html>
<head>
    <theme:layout name="plain"/>
    <theme:title>Author - ${authorInstance.name}</theme:title>
</head>

<body>

<theme:zone name="body">
    <g:render template="header"/>
    <%
        def tabs = ProfileTab.values().flatten()
        tabs.remove ProfileTab.WATCHLIST
    %>

    <ui:tabs>
        <g:each in="${tabs}" var="profileTab">
            <ui:tab title="${profileTab.capitalizedName}"
                    active="${'Plugins' == profileTab.capitalizedName}">
                <g:render template="/profile/profile/${profileTab}"
                          model="[tab: profileTab, userId: authorInstance.id]"/>
            </ui:tab>
        </g:each>
    </ui:tabs>

</theme:zone>
</body>
</html>