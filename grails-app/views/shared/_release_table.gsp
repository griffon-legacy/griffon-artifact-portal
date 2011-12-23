<%@ page import="griffon.portal.DownloadTotal" %>
<!-- BEGIN: RELEASE_TABLE -->
<h2>Releases</h2>
<table class="condensed-table zebra-stripped">
  <thead>
  <tr>
    <th>${message(code: 'release.artifactVersion.label', default: 'Version')}</th>
    <th>${message(code: 'release.griffonVersion.label', default: 'Griffon Version')}</th>
    <th>${message(code: 'release.dateCreated.label', default: 'Date')}</th>
    <th>${message(code: 'release.comment.label', default: 'Comment')}</th>
    <th>${message(code: 'release.downloads.label', default: 'Downloads')}</th>
    <th></th>
  </tr>
  </thead>
  <tbody>
  <g:each in="${releaseList}" status="i" var="releaseInstance">
    <tr>
      <td>${fieldValue(bean: releaseInstance, field: "artifactVersion")}</td>
      <td>${fieldValue(bean: releaseInstance, field: "griffonVersion")}</td>
      <td><g:formatDate format="dd-MM-yyyy" date="${releaseInstance.dateCreated}"/></td>
      <td>${fieldValue(bean: releaseInstance, field: "comment")}</td>
      <%-- A query on a GSP?! good grief! --%>
      <td>${DownloadTotal.findByRelease(releaseInstance)?.total ?: 0i}</td>
      <td>
        <div class="pull-right">
          <g:link controller="release" action="show"
                  params="[type: releaseInstance.artifact.type, name: releaseInstance.artifact.name, version: releaseInstance.artifactVersion]"
                  mapping="display_release"
                  class="btn primary small">${message(code: 'griffon.portal.button.info.label', default: 'More Info')}</g:link>
          <g:link controller="release" action="download" params="[id: releaseInstance.id]" mapping="download_release"
                  class="btn success small">${message(code: 'griffon.portal.button.download.label', default: 'Download')}</g:link>
        </div>
      </td>
    </tr>
  </g:each>
  </tbody>
</table>
<!-- END: RELEASE_TABLE -->