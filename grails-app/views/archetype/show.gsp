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

    <g:render template="/artifact/common/artifact_header_properties" model="[artifactInstance: archetypeInstance, downloads: downloads]"/>
  </div>

  <div class="span4">
    <g:render template="/artifact/common/authored_by" bean="${authorList}" model="[authorList: authorList]"/>
  </div>
</div>

<hr/>

<div class="row">
  <div class="span16">
    <h2>Description</h2>

    <p>
      <g:if test="${archetypeInstance.description}">
        <markdown:renderHtml>${archetypeInstance.description}</markdown:renderHtml>
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
    <g:render template="/artifact/common/release_table" model="[releaseList: releaseList]"/>
  </div>
</div>

</body>
</html>
