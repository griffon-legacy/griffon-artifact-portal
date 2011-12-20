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

<g:render template="header"/>

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

  <g:if test="${session.user}">
    <div class="<%=listSpan%>">
      <ul class="tabs">
        <li class="${tab == 'contributions' ? 'active' : ''}"><g:link controller="profile" action="show"
                                                                      id="${profileInstance.user.username}"
                                                                      params="[tab: 'contributions']">Contributions</g:link></li>
        <li class="${tab == 'watchlist' ? 'active' : ''}"><g:link controller="profile" action="show"
                                                                  id="${profileInstance.user.username}"
                                                                  params="[tab: 'watchlist']">Watch List</g:link></li>
      </ul>
    </div>
  </g:if>

  <g:if test="${tab == 'contributions'}">
    <g:render template="contributions"/>
  </g:if>
  <g:elseif test="${tab == 'watchlist'}">
    <g:render template="watchlist"/>
  </g:elseif>

</div>

</body>
</html>
