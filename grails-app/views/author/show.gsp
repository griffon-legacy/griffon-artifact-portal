<%@ page import="griffon.portal.values.ProfileTab" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title>Author - ${authorInstance.name}</title>
</head>

<body>

<g:render template="header"/>

<div class="row">

  <%
    def tabClassFor = { ProfileTab profileTab ->
      tab == profileTab.name ? 'active' : ''
    }
  %>

  <div class="span16">
    <ul class="tabs">
      <%
        def tabs = ProfileTab.values().flatten()
        tabs.remove ProfileTab.WATCHLIST
      %>
      <g:each in="${tabs}" var="profileTab">
        <li class="${tabClassFor(profileTab)}"><g:link controller="author" action="show"
                                                       id="${authorInstance.id}" mapping="author"
                                                       params="[tab: profileTab.name]">${profileTab.capitalizedName}</g:link></li>
      </g:each>
    </ul>
  </div>

  <g:render template="/profile/profile/${tab}" model="[listSpan: 'span16']"/>

</div>

</body>
</html>
