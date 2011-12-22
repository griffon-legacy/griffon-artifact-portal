<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <g:set var="releaseName" value="${releaseInstance.artifact.name}-${releaseInstance.artifactVersion}"/>
  <title><g:message code="griffon.portal.Release.show.label" args="[releaseName]"/></title>
</head>

<body>

<div class="page-header">
  <h1>${releaseName} <small><p>${releaseInstance.artifact.title}</p></small></h1>
</div>

<div class="row">
  <div class="span10">
    <div class="fieldcontain">
      <span id="artifact-label" class="property-label"><%=releaseInstance.artifact.capitalizedType%></span>
      <g:link controller="${releaseInstance.artifact.type}" action="show" params="[name: releaseInstance.artifact.name]"
              mapping="show_${releaseInstance.artifact.type}">
        <span class="property-value" aria-labelledby="artifact-label">
          ${fieldValue(bean: releaseInstance.artifact, field: "capitalizedName")}
        </span>
      </g:link>
    </div>

    <div class="fieldcontain">
      <span id="releaseDate-label"
            class="property-label">${message(code: 'release.dateCreated.label', default: 'Release Date')}</span>
      <span class="property-value" aria-labelledby="releaseDate-label">
        <g:formatDate format="dd-MM-yyyy" date="${releaseInstance.dateCreated}"/>
      </span>
    </div>

    <div class="fieldcontain">
      <span id="checksum-label"
            class="property-label">${message(code: 'release.checksum.label', default: 'Checksum')}</span>
      <span class="property-value" aria-labelledby="checksum-label">
        <g:fieldValue bean="${releaseInstance}" field="checksum"/>
      </span>
    </div>

    <div class="fieldcontain">
      <span id="comment-label"
            class="property-label">${message(code: 'release.comment.label', default: 'Comment')}</span>
      <span class="property-value" aria-labelledby="comment-label">
        <g:fieldValue bean="${releaseInstance}" field="comment"/>
      </span>
    </div>
  </div>

  <div class="span4">
    <g:link controller="release" action="download" params="[id: releaseInstance.id]" mapping="download_release"
            class="btn success pull-right">${message(code: 'griffon.portal.button.download.label', default: 'Download')}</g:link>
  </div>
</div>
</body>
</html>
