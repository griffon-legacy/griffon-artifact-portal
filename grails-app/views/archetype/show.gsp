<%@ page import="griffon.portal.values.ArtifactTab" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title><g:message code="griffon.portal.Archetype.show.label" args="[archetypeName]"/></title>
</head>

<body>

<div class="row">
  <div class="span16">
    <tmpl:/pageheader><h1>${archetypeName} <small><p>${archetypeInstance.title}</p></small></h1></tmpl:/pageheader>
  </div>
</div>

<div class="row">
  <div class="span10">
    <g:render template="/artifact/common/artifact_header_properties"
              model="[artifactInstance: archetypeInstance, downloads: downloads]"/>
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
        <li class="${tabClassFor(artifactTab)}"><g:link controller="archetype" action="show"
                                                        mapping="show_archetype"
                                                        params="[name: archetypeInstance.name, tab: artifactTab.name]">${artifactTab.capitalizedName}</g:link></li>
      </g:each>
    </ul>
  </div>
</div>

<div class="row">
  <div class="span16">
    <g:render template="/artifact/tabs/$tab" model="[artifactInstance: archetypeInstance]"/>
  </div>
</div>

</body>
</html>
