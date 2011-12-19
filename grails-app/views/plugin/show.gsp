<%@ page import="grails.util.GrailsNameUtils; griffon.portal.values.Toolkit; griffon.portal.values.Platform" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title><g:message code="griffon.portal.Plugin.show.label" args="[pluginName]"/></title>
</head>

<body>

<div class="page-header">
  <h1>${pluginName} <small><p>${pluginInstance.title}</p></small></h1>
</div>

<div class="row">
  <div class="span10">

    <div class="fieldcontain">
      <span id="license-label" class="property-label"><g:message code="artifact.license.label"
                                                                 default="License"/></span>
      <span class="property-value" aria-labelledby="license-label">
        <g:fieldValue bean="${pluginInstance}" field="license"/>
      </span>
    </div>

    <div class="fieldcontain">
      <span id="toolkits-label" class="property-label"><g:message code="plugin.toolkits.label"
                                                                  default="Toolkits"/></span>
      <g:set var="toolkits" value="${pluginInstance.toolkits.split(',')}"/>
      <span class="property-value" aria-labelledby="toolkits-label">
        <g:if test="${!pluginInstance.toolkits}">
          <g:set var="toolkits" value="${Toolkit.getLowercaseNamesAsList()}"/>
        </g:if>
        <g:each in="${toolkits}" var="toolkit">
          ${Toolkit.findByName(toolkit).name}
        </g:each>
      </span>
    </div>

    <div class="fieldcontain">
      <span id="platforms-label" class="property-label"><g:message code="plugin.platforms.label"
                                                                   default="Platforms"/></span>
      <g:set var="platforms" value="${pluginInstance.platforms.split(',')}"/>
      <g:if test="${pluginInstance.platforms.size() == 0}">
        <g:set var="platforms" value="${Platform.getLowercaseNamesAsList()}"/>
      </g:if>
      <ul class="media-grid">
        <g:each in="${platforms}" var="platform">
          <li>
            <a href="#"><g:img dir="images" class="thumbnail" file="logo-${platform.trim()}.gif"
                               width="16" height="16" alt="${platform.trim()}"/></a>
          </li>
        </g:each>
      </ul>
    </div>

    <div class="fieldcontain">
      <span id="dependencies-label" class="property-label"><g:message code="plugin.dependencies.label"
                                                                      default="Dependencies"/></span>
      <span class="property-value" aria-labelledby="dependencies-label">
        <g:if test="${!pluginInstance.dependencies}">
          NONE
        </g:if>
        <% def linkParams = [:] %>
        <g:each in="${pluginInstance.dependencies}" var="dependency">
          <% linkParams.name = dependency.key %>
          <g:link controller="plugin" action="show" params="${linkParams}">
            ${GrailsNameUtils.getNaturalName(dependency.key)}
          </g:link>
        </g:each>
      </span>
    </div>

  </div>

  <div class="span4">
    <h3>Authored by:</h3>
    <g:each in="${authorList}" var="author">
      <div class="row">
        <div class="span1">
          <ul class="media-grid">
            <li>
              <g:link controller="profile" action="show" id="${author.username}">
                <avatar:gravatar cssClass="avatar thumbnail"
                                 email="${author.email}" size="40"/>
              </g:link>
            </li>
          </ul>
        </div>

        <div class="span3">
          <address>
            <strong>${author.name}</strong><br/>
            <a mailto="">${author.email}</a>
          </address>
        </div>
      </div>
    </g:each>
  </div>
</div>

<div class="row">
  <div class="span16">
    <table class="condensed-table zebra-striped">
      <thead>
      <tr>
        <th>${message(code: 'release.artifactVersion.label', default: 'Version')}</th>
        <th>${message(code: 'release.griffonVersion.label', default: 'Griffon Version')}</th>
        <th>${message(code: 'release.dateCreated.label', default: 'Date')}</th>
        <th>${message(code: 'release.checksum.label', default: 'Checksum')}</th>
        <th></th>
      </tr>
      </thead>
      <tbody>
      <g:each in="${releaseList}" status="i" var="releaseInstance">
        <tr>
          <td>${fieldValue(bean: releaseInstance, field: "artifactVersion")}</td>
          <td>${fieldValue(bean: releaseInstance, field: "griffonVersion")}</td>
          <td><g:formatDate format="dd-MM-yyyy" date="${releaseInstance.dateCreated}"/></td>
          <td>${fieldValue(bean: releaseInstance, field: "checksum")}</td>
          <td>
            <g:form controller="release" action="dispatch">
              <g:hiddenField name="id" value="${releaseInstance.id}"/>
              <g:hiddenField id="release_${releaseInstance.id}" name="release_${releaseInstance.id}" value=""/>
              <button class="btn primary small" type="submit" id="info" name="info"
                      onclick="return adjustForm('${releaseInstance.id}', 'show');">
                ${message(code: 'griffon.portal.button.info.label', default: 'More Info')}</button>
              <button class="btn success small" type="submit" id="download" name="download"
                      onclick="return adjustForm('${releaseInstance.id}', 'download');">
                ${message(code: 'griffon.portal.button.download.label', default: 'Download')}</button>
            </g:form>
          </td>
        </tr>
      </g:each>
      </tbody>
    </table>
  </div>
</div>

<script>
  function adjustForm(releaseId, value) {
    $('#release_' + releaseId).val(value)
    return true;
  }
</script>
</body>
</html>
