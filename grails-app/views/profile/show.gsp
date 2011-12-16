<%@ page import="grails.util.GrailsNameUtils" %>
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
  <ul class="media-grid">
    <li>
      <a href="#">
        <avatar:gravatar cssClass="avatar thumbnail"
                         email="${profileInstance.gravatarEmail}" size="80"/>
      </a>

      <h1>&nbsp;<g:fieldValue bean="${profileInstance.user}" field="username"/></h1>
    </li>
  </ul>
</div>

<div class="row">
  <div class="span16">
    <div id="show-profile" class="scaffold-show" role="main">
      <div class="fieldcontain">
        <span class="property-label" aria-labelledby="description-label"><g:message code="user.fullName.label"
                                                                                    default="Full Name"/></span>
        <span class="property-value" aria-labelledby="description-label"><g:fieldValue bean="${profileInstance.user}"
                                                                                       field="fullName"/></span>
      </div>

      <g:if test="${profileInstance.website}">
        <div class="fieldcontain">
          <span class="property-label" aria-labelledby="description-label"><g:message code="profile.website.label"
                                                                                      default="Website"/></span>
          <span class="property-value" aria-labelledby="description-label"><a
                  href="${profileInstance.website}"><g:fieldValue bean="${profileInstance}"
                                                                  field="website"/></a></span>
        </div>
      </g:if>

      <div class="fieldcontain">
        <span class="property-label" aria-labelledby="description-label"><g:message code="user.membership.label"
                                                                                    default="Member since"/></span>
        <span class="property-value"
              aria-labelledby="description-label">${profileInstance.user.dateCreated.format('MMM dd, yyyy')}</span>
      </div>
      <%--
            <g:if test="${profileInstance.twitter}">
              <widget:twitter username="${profileInstance.twitter}"/>
            </g:if>
      --%>
    </div>
  </div>
</div>

<g:if test="${pluginList}">
  <div class="row">
    <div class="span16">
      <h2>Plugins</h2>

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
              <td>
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
    </div>
  </div>
</g:if>

<g:if test="${archetypeList}">
  <div class="row">
    <div class="span16">
      <h2>Archetypes</h2>

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
              <td>
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
    </div>
  </div>
</g:if>

</body>
</html>
