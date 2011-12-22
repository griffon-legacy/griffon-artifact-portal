<%@ page import="org.pegdown.PegDownProcessor; griffon.portal.values.Toolkit; griffon.portal.values.Platform" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title><g:message code="griffon.portal.Archetype.show.label" args="[archetypeName]"/></title>
</head>

<body>

<div class="page-header">
  <h1>${archetypeName} <small><p>${archetypeInstance.title}</p></small></h1>
</div>

<div class="row">
  <div class="span10">

    <div class="fieldcontain">
      <span id="license-label" class="property-label"><g:message code="artifact.license.label"
                                                                 default="License"/></span>
      <span class="property-value" aria-labelledby="license-label">
        <g:fieldValue bean="${archetypeInstance}" field="license"/>
      </span>
    </div>

    <g:if test="${session.user}">
      <g:render template="/shared/wacthing" model="[artifactInstance: archetypeInstance, watching:watching]"/>
    </g:if>
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
