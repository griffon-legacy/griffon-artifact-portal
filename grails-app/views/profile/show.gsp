<%@ page import="griffon.portal.Membership; grails.util.GrailsNameUtils" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <g:set var="username" value="${profileInstance.user.username}"/>
  <title><g:message code="griffon.portal.Profile.show.label" args="[username]"/></title>

  <script src="http://widgets.twimg.com/j/2/widget.js"></script>

</head>

<body>

<div class="page-header">
  <div class="row">
    <div class="span2">
      <ul class="media-grid">
        <li>
          <a href="#">
            <avatar:gravatar cssClass="avatar thumbnail"
                             email="${profileInstance.gravatarEmail}" size="80"/>
          </a>
        </li>
      </ul>
    </div>

    <div class="span13">
      <div class="row">
        <div class="span9">
          <address>
            <h1><g:fieldValue bean="${profileInstance.user}" field="username"/></h1>
            <g:fieldValue bean="${profileInstance.user}" field="fullName"/><br/>
            <g:if test="${profileInstance.website}">
              <a href="${profileInstance.website}"><g:fieldValue bean="${profileInstance}" field="website"/></a><br/>
            </g:if>
            <small><g:message code="user.membership.label" default="Member since"/></small> <g:formatDate
                  date="${profileInstance.user.dateCreated}" format="MMM dd, yyyy"/>
          </address>
        </div>

        <div class="span4">
          <g:if test="${profileInstance.user.username == session.user?.username}">
            <g:if test="${profileInstance.user.membership.status == Membership.Status.ACCEPTED}">
              <g:form controller="release" action="upload">
                <button class="btn success pull-right" type="submit" id="upload" name="upload">
                  ${message(code: 'griffon.portal.button.upload.label', default: 'Upload a Release')}</button>
              </g:form>
            </g:if>
            <g:else>
              <button class="btn primary pull-right">
                ${message(code: 'griffon.portal.button.membership.label', default: 'Apply for Membership')}</button>
            </g:else>
          </g:if>
        </div>
      </div>
    </div>

  </div>
</div>

<%
  String listSpan = profileInstance.twitter ? 'span10' : 'span15'
%>

<div class="row">
  <div class="span5">
    <g:if test="${profileInstance.twitter}">
      <div class="row">
        <div class="span4">
          <widget:twitter username="${profileInstance.twitter}"/>
        </div>
      </div>
    </g:if>
  </div>

  <div class="<%=listSpan%>">
    <div class="row">
      <div class="<%=listSpan%>">
        <h2>Plugins</h2>

        <g:if test="${pluginList}">
          <div id="list-plugins">
            <table>
              <thead>
              <tr>
                <th>${message(code: 'plugin.name.label', default: 'Name')}</th>
                <th>${message(code: 'plugin.title.label', default: 'Title')}</th>
                <th></th>
              </tr>
              </thead>
              <tbody>
              <g:each in="${pluginList}" status="i" var="pluginInstance">
                <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
                  <td>${GrailsNameUtils.getNaturalName(fieldValue(bean: pluginInstance, field: "name").toString())}</td>
                  <td>${fieldValue(bean: pluginInstance, field: "title")}</td>
                  <td class="pull-right">
                    <div>
                      <%
                        def formParams = [name: pluginInstance.name]
                      %>
                      <g:form controller="plugin" action="show" params="${formParams}" mapping="showPlugin">
                        <g:hiddenField name="name" value="${pluginInstance.name}"/>
                        <button class="btn primary small" type="submit" id="info" name="info">
                          ${message(code: 'griffon.portal.button.info.label', default: 'More Info')}</button>
                      </g:form>
                    </div>
                  </td>
                </tr>
              </g:each>
              </tbody>
            </table>
          </div>
        </g:if>
        <g:else>
          <p>None available.</p>
        </g:else>
      </div>
    </div>

    <div class="row">
      <div class="<%=listSpan%>">
        <h2>Archetypes</h2>
        <g:if test="${archetypeList}">

          <div id="list-archetypes">
            <table>
              <thead>
              <tr>
                <th>${message(code: 'archetype.name.label', default: 'Name')}</th>
                <th>${message(code: 'archetype.title.label', default: 'Title')}</th>
                <th></th>
              </tr>
              </thead>
              <tbody>
              <g:each in="${archetypeList}" status="i" var="archetypeInstance">
                <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
                  <td>${GrailsNameUtils.getNaturalName(fieldValue(bean: archetypeInstance, field: "name").toString())}</td>
                  <td>${fieldValue(bean: archetypeInstance, field: "title")}</td>
                  <td class="pull-right">
                    <div>
                      <%
                        formParams = [name: archetypeInstance.name]
                      %>
                      <g:form controller="archetype" action="show" params="${formParams}" mapping="showArchetype">
                        <g:hiddenField name="name" value="${archetypeInstance.name}"/>
                        <button class="btn primary small" type="submit" id="info" name="info">
                          ${message(code: 'griffon.portal.button.info.label', default: 'More Info')}</button>
                      </g:form>
                    </div>
                  </td>
                </tr>
              </g:each>
              </tbody>
            </table>
          </div>
        </g:if>
        <g:else>
          <p>None available.</p>
        </g:else>
      </div>
    </div>

  </div>
</div>

</body>
</html>
