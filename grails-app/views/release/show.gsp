<%@ page import="grails.util.GrailsNameUtils" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <g:set var="releaseName" value="${releaseInstance.artifact.name}-${releaseInstance.artifactVersion}"/>
  <title><g:message code="griffon.portal.Release.show.label" args="[releaseName]"/></title>
</head>

<body>

<tmpl:/pageheader><h1>${releaseName}</h1>${releaseInstance.artifact.title}</tmpl:/pageheader>

<div class="row">
  <div class="span12">
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
      <span id="dependencies-label" class="property-label"><g:message code="release.dependencies.label"
                                                                      default="Dependencies"/></span>
      <span class="property-value" aria-labelledby="dependencies-label">
        <g:if test="${!releaseInstance.dependencies}">
          NONE
        </g:if>
        <g:each in="${releaseInstance.dependencies}" var="dependency">
          <g:link controller="plugin" action="show" params="[name: dependency.key]">
            ${GrailsNameUtils.getNaturalName(dependency.key)}
          </g:link>
        </g:each>
      </span>
    </div>

    <div class="fieldcontain">
      <span id="comment-label"
            class="property-label">${message(code: 'release.comment.label', default: 'Comment')}</span>
      <span class="property-value" aria-labelledby="comment-label">
        <g:fieldValue bean="${releaseInstance}" field="comment"/>
      </span>
    </div>

    <div class="fieldcontain">
      <span id="downloads-label"
            class="property-label">${message(code: 'release.downloads.label', default: 'Downloads')}</span>
      <span class="property-value" aria-labelledby="downloads-label">
        ${downloads}
      </span>
    </div>
  </div>

  <div class="span4">
    <g:link controller="release"
            params="[id: releaseInstance.id, type: releaseInstance.artifact.type, name: releaseInstance.artifact.name, version: releaseInstance.artifactVersion]"
            mapping="download_package"
            class="btn success">${message(code: 'griffon.portal.button.package.label', default: 'Package')}</g:link>
    <g:link controller="release"
            params="[id: releaseInstance.id, type: releaseInstance.artifact.type, name: releaseInstance.artifact.name, version: releaseInstance.artifactVersion]"
            mapping="download_release"
            class="btn success">${message(code: 'griffon.portal.button.release.label', default: 'Release')}</g:link>
  </div>
</div>

<hr/>

<div class="row">
  <div class="span16">
    <h2>Release Notes</h2>

    <p>
      <g:if test="${releaseInstance.releaseNotes}">
        <%
          out << new File(releaseNotesFilePath).text
        %>
      </g:if>
      <g:else>
        No description available.
      </g:else>
    </p>
  </div>
</div>

</body>
</html>
