<%@ page import="grails.util.GrailsNameUtils; griffon.portal.values.Toolkit; griffon.portal.values.Platform" %>
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
    <%
      def artifactType = GrailsNameUtils.getShortName(releaseInstance.artifact.class)
      def linkParams = [name: releaseInstance.artifact.name]
    %>
    <div class="fieldcontain">
      <span id="artifact-label" class="property-label"><%=artifactType%></span>
      <g:link controller="${artifactType.toLowerCase()}" action="show" params="${linkParams}">
        <span class="property-value" aria-labelledby="artifact-label">
          ${GrailsNameUtils.getNaturalName(fieldValue(bean: releaseInstance.artifact, field: "name").toString())}
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
    <g:form controller="release" action="download">
      <g:hiddenField name="id" value="${releaseInstance.id}"/>
      <button class="btn success pull-right" type="submit" id="download" name="download">
        ${message(code: 'griffon.portal.button.download.label', default: 'Download')}</button>
    </g:form>
  </div>
</div>
</body>
</html>
