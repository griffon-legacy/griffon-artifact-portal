<!-- BEGIN: ARTIFACT -->
<div class="artifact pull-right">
  <div class="artifact-header">
    <h4><g:link controller="${artifactInstance.type}" action="show"
                id="${artifactInstance.name}">${artifactInstance.capitalizedName}</g:link></h4>
    <small>${artifactInstance.title}</small>
  </div>

  <div class="more-info">
    <g:link controller="${artifactInstance.type}" action="show" params="[name: artifactInstance.name]"
            mapping="show_${artifactInstance.type}"
            class="btn small primary pull-right">${message(code: 'griffon.portal.button.info.label', default: 'More Info')}</g:link>
  </div>

  <div class="artifact-detail">
    <div><span class="artifact-label">Tags:</span></div>

    <div><span class="artifact-label">License:</span> ${artifactInstance.license}</div>

  </div>

  <ul class="artifact-links">
    <li>
      <g:if test="${artifactInstance.source}">
        <a href="${artifactInstance.source}"><g:img dir="images" file="source_on.png"/> Source</a>
      </g:if>
      <g:else>
        <g:img dir="images" file="source_off.png" title="No source link provided"/> Source
      </g:else>
    </li>
    <li>
      <g:if test="${artifactInstance.docs}">
        <g:link controller="docs" mapping="show_docs"
                params="[type: params.type, name: artifactInstance.name]"><g:img dir="images"
                                                                                 file="docs_on.png"/> Docs</g:link>
      </g:if>
      <g:else>
        <g:img dir="images" file="docs_off.png" title="No docs have been uploaded"/> Docs
      </g:else>
    </li>
  </ul>
</div>
<br clear="all"/>
<br clear="all"/>
<!-- END: ARTIFACT -->