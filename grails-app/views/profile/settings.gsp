<%@ page import="griffon.portal.values.SettingsTab" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <g:set var="username" value="${profileInstance.user.username}"/>
  <title><g:message code="griffon.portal.Profile.show.label" args="[username]"/></title>

  <meta name="layout" content="main"/>
</head>

<body>

<div class="page-header">
  <div class="row">
    <div class="span1">
      <ul class="media-grid">
        <li>
          <a href="#">
            <avatar:gravatar cssClass="avatar thumbnail"
                             email="${profileInstance.gravatarEmail}" size="40"/>
          </a>
        </li>
      </ul>
    </div>

    <div class="span15">
      <h2><g:fieldValue bean="${profileInstance.user}" field="username"/>'s settings</h2>
    </div>
  </div>
</div>

<div class="row">
  <div class="span16">
    <%
      def tabClassFor = { SettingsTab settingsTab ->
        tab == settingsTab.name ? 'active' : ''
      }
    %>
    <ul class="tabs" role="navigation">
      <g:each in="${SettingsTab.values()}" var="settingsTab">
        <li class="${tabClassFor(settingsTab)}"><g:link controller="profile" action="settings"
                                                        mappingName="settings"
                                                        params="[tab: settingsTab.name, username: profileInstance.user.username]">${settingsTab.capitalizedName}</g:link></li>
      </g:each>
    </ul>
  </div>
</div>

<div class="row">
  <g:render template="settings/${tab}"/>
</div>

</body>
</html>