<%@ page import="griffon.portal.stats.DownloadTotal" %>
<!-- BEGIN: RELEASE_TABLE -->
<ui:table class="table-condensed">
    <thead>
    <ui:tr>
        <ui:th>${message(code: 'release.artifactVersion.label', default: 'Version')}</ui:th>
        <ui:th>${message(code: 'release.griffonVersion.label', default: 'Griffon Version')}</ui:th>
        <ui:th>${message(code: 'release.dateCreated.label', default: 'Date')}</ui:th>
        <ui:th>${message(code: 'release.comment.label', default: 'Message')}</ui:th>
        <ui:th>${message(code: 'release.downloads.label', default: 'Downloads')}</ui:th>
        <ui:th></ui:th>
    </ui:tr>
    </thead>
    <tbody>
    <g:each in="${releaseList}" status="i" var="releaseInstance">
        <ui:tr>
            <td>${fieldValue(bean: releaseInstance, field: "artifactVersion")}</td>
            <td>${fieldValue(bean: releaseInstance, field: "griffonVersion")}</td>
            <td><g:formatDate format="dd-MM-yyyy"
                              date="${releaseInstance.dateCreated}"/></td>
            <td>${fieldValue(bean: releaseInstance, field: "comment")}</td>
        <%-- A query on a GSP?! good grief! --%>
            <td>${DownloadTotal.findByRelease(releaseInstance)?.total ?: 0i}</td>
            <td>
                <div class="btn-toolbar">
                    <div class="btn-group">
                        <g:link controller="release" action="show"
                                params="[type: releaseInstance.artifact.type, name: releaseInstance.artifact.name, version: releaseInstance.artifactVersion]"
                                mapping="display_package"
                                class="btn btn-danger">
                            <i class="icon-info-sign icon-white"></i>
                        </g:link>
                        <g:link controller="release"
                                params="[id: releaseInstance.id, type: releaseInstance.artifact.type, name: releaseInstance.artifact.name, version: releaseInstance.artifactVersion]"
                                mapping="download_package"
                                class="btn btn-danger">
                            <i class="icon-arrow-down icon-white"></i>
                        </g:link>
                        <g:link controller="release"
                                params="[id: releaseInstance.id, type: releaseInstance.artifact.type, name: releaseInstance.artifact.name, version: releaseInstance.artifactVersion]"
                                mapping="download_release"
                                class="btn btn-danger">
                            <i class="icon-briefcase icon-white"></i>
                        </g:link>
                    </div>
                </div>
            </td>
        </ui:tr>
    </g:each>
    </tbody>
</ui:table>
<!-- END: RELEASE_TABLE -->