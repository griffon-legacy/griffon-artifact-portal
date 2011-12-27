<%@ page import="griffon.portal.values.ArtifactTab" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title><g:message code="griffon.portal.Plugin.show.label" args="[pluginName]"/></title>
</head>

<body>

<div class="row">
  <div class="span16">
    <div class="page-header">
      <h1>${pluginName} <small><p>${pluginInstance.title}</p></small></h1>
    </div>
  </div>
</div>

<div class="row">
  <div class="span10">
    <g:render template="plugin_header_properties" model="[pluginInstance: pluginInstance]"/>
    <g:render template="/artifact/common/artifact_header_properties"
              model="[artifactInstance: pluginInstance, downloads: downloads]"/>
  </div>

  <div class="span6">
    <g:render template="/artifact/common/authored_by" bean="${authorList}" model="[authorList: authorList]"/>
  </div>
</div>

<%
  def tabClassFor = { ArtifactTab artifactTab ->
    tab == artifactTab.name ? 'active' : ''
  }
%>

<div class="row">
  <div class="span16">
    <ul class="tabs">
      <g:each in="${ArtifactTab.values()}" var="artifactTab">
        <li class="${tabClassFor(artifactTab)}"><g:link controller="plugin" action="show"
                                                        mapping="show_plugin"
                                                        params="[name: pluginInstance.name, tab: artifactTab.name]">${artifactTab.capitalizedName}</g:link></li>
      </g:each>
    </ul>
  </div>
</div>

<div class="row">
  <div class="span16">
    <g:render template="/artifact/tabs/$tab" model="[artifactInstance: pluginInstance]"/>
  </div>
</div>

</body>
</html>
