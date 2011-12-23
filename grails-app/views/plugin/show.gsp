<%@ page import="org.pegdown.PegDownProcessor; grails.util.GrailsNameUtils; griffon.portal.values.Toolkit; griffon.portal.values.Platform" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title><g:message code="griffon.portal.Plugin.show.label" args="[pluginName]"/></title>
  <style type="text/css">
  .artifact-show .artifact-ratings {
    position: relative;
    float: left;
    left: 10px;
  }
  </style>
</head>

<body>

<div class="page-header">
  <h1>${pluginName} <small><p>${pluginInstance.title}</p></small></h1>
</div>

<div class="row">
  <div class="span10">

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

    <div class="fieldcontain platforms">
      <span id="platforms-label" class="property-label"><g:message code="plugin.platforms.label"
                                                                   default="Platforms"/></span>
      <g:set var="platforms" value="${pluginInstance.platforms.split(',')}"/>
      <g:if test="${pluginInstance.platforms.size() == 0}">
        <g:set var="platforms" value="${Platform.getLowercaseNamesAsList()}"/>
      </g:if>
      <ul>
        <g:each in="${platforms}" var="platform">
          <li>
            <g:img dir="images" class="thumbnail" file="logo-${platform.trim()}.gif"
                   width="16" height="16" alt="${platform.trim()}"/>
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
        <g:each in="${pluginInstance.dependencies}" var="dependency">
          <g:link controller="plugin" action="show" params="[name: dependency.key]">
            ${GrailsNameUtils.getNaturalName(dependency.key)}
          </g:link>
        </g:each>
      </span>
    </div>

    <g:render template="/shared/header_properties" model="[artifactInstance: pluginInstance, downloads: downloads]"/>
  </div>

  <div class="span4">
    <g:render template="/shared/authored_by" bean="${authorList}" model="[authorList: authorList]"/>
  </div>
</div>

<hr/>

<div class="row">
  <div class="span16">
    <h2>Description</h2>

    <p>
      <g:if test="${pluginInstance.description}">
        <%
          out << new PegDownProcessor().markdownToHtml(pluginInstance.description)
        %>
      </g:if>
      <g:else>
        No description available.
      </g:else>
    </p>
  </div>
</div>

<hr/>

<div class="row">
  <div class="span16">
    <g:render template="/shared/release_table" model="[releaseList: releaseList]"/>
  </div>
</div>

</body>
</html>
