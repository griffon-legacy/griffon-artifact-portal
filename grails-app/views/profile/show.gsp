<%@ page import="griffon.portal.values.ProfileTab" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <g:set var="username" value="${profileInstance.user.username}"/>
  <title><g:message code="griffon.portal.Profile.show.label" args="[username]"/></title>

  <r:require module="twitter"/>
  <r:require module="upload"/>
</head>

<body>

<g:render template="profile/header"/>

<%
  String listSpan = profileInstance.twitter ? 'span11' : 'span16'
%>

<div class="row">
  <g:if test="${profileInstance.twitter}">
    <div class="span5">
      <div class="row">
        <div class="span4">
          <widget:twitter username="${profileInstance.twitter}"/>
        </div>
      </div>
    </div>
  </g:if>

  <%
    def tabClassFor = { ProfileTab profileTab ->
      tab == profileTab.name ? 'active' : ''
    }
  %>

  <div class="<%=listSpan%>">
    <ul class="tabs">
      <%
        def tabs = ProfileTab.values().flatten()
        if (!loggedIn) tabs.remove ProfileTab.WATCHLIST
      %>
      <g:each in="${tabs}" var="profileTab">
        <li class="${tabClassFor(profileTab)}"><g:link controller="profile" action="show"
                                                       mapping="profile"
                                                       id="${profileInstance.user.username}"
                                                       params="[tab: profileTab.name]">${profileTab.capitalizedName}</g:link></li>
      </g:each>
    </ul>
  </div>

  <g:render template="profile/${tab}" model="[profileInstance: profileInstance, listSpan: listSpan]"/>

</div>

</body>
</html>
