<!-- BEGIN: ARTIFACT -->
<%
    String downloads = ''
    if (hasDownloads) {
        downloads = " (${artifactInstance.total})"
        artifactInstance = artifactInstance.release.artifact
    }
%>
<div class="artifact ">
    <g:render template="/shared/rating_offline"
              model="[artifactInstance: artifactInstance, login: false]"/>

    <div class="artifact-header">
        <h4><g:link controller="${artifactInstance.type}" action="show"
                    params="[name: artifactInstance.name]"
                    mapping="show_${artifactInstance.type}">${artifactInstance.capitalizedName}</g:link>${downloads}</h4>
        <small>${artifactInstance.title}</small>

        <div class="artifact-detail">
            <div><span
                class="artifact-label">Tags:</span> ${artifactInstance.tags.join(', ')}
            </div>

            <div><span
                class="artifact-label">License:</span> ${artifactInstance.license}
            </div>
        </div>
    </div>

    <ul class="artifact-links">
        <li>
            <g:if test="${artifactInstance.source}">
                <a href="${artifactInstance.source}"><g:img dir="images"
                                                            file="source_on.png"/> Source</a>
            </g:if>
            <g:else>
                <g:img dir="images" file="source_off.png"
                       title="No source link provided"/> Source
            </g:else>
        </li>
        <li>
            <g:if test="${artifactInstance.documentation}">
                <a href="${artifactInstance.documentation}"><g:img dir="images"
                                                                   file="docs_on.png"/> Docs</a>
            </g:if>
            <g:else>
                <g:img dir="images" file="docs_off.png"
                       title="No docs have been uploaded"/> Docs
            </g:else>
        </li>
    </ul>

    <div class="artifact-more-info">
        <g:link controller="${artifactInstance.type}" action="show"
                params="[name: artifactInstance.name]"
                mapping="show_${artifactInstance.type}"
                class="btn btn-inverse pull-right"><i
            class="icon-info-sign icon-white"></i> ${message(code: 'griffon.portal.button.info.label', default: 'More Info')}</g:link>
    </div>
</div>
<br clear="all"/>
<br clear="all"/>
<!-- END: ARTIFACT -->
