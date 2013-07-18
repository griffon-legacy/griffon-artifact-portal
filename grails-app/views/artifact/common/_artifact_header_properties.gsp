<!-- BEGIN: HEADER -->
<div class="fieldcontain">
    <span id="license-label" class="property-label"><g:message
        code="artifact.license.label"
        default="License"/></span>
    <span class="property-value" aria-labelledby="license-label">
        <g:fieldValue bean="${artifactInstance}" field="license"/>
    </span>
</div>

<div class="fieldcontain">
    <span id="source-label" class="property-label"><g:message
        code="artifact.source.label"
        default="Source"/></span>
    <span class="property-value" aria-labelledby="source-label">
        <g:if test="${artifactInstance.source}">
            <a href="<g:fieldValue bean="${artifactInstance}"
                                   field="source"/>"><g:fieldValue
                bean="${artifactInstance}"
                field="source"/></a>
        </g:if>
        <g:else>
            No source link provided
        </g:else>
    </span>
</div>

<div class="fieldcontain">
    <span id="documentation-label" class="property-label"><g:message
        code="artifact.documentation.label"
        default="Documentation"/></span>
    <span class="property-value" aria-labelledby="documentation-label">
        <g:if test="${artifactInstance.documentation}">
            <a href="<g:fieldValue bean="${artifactInstance}"
                                   field="documentation"/>"><g:fieldValue
                bean="${artifactInstance}"
                field="documentation"/></a>
        </g:if>
        <g:else>
            No documentation link provided
        </g:else>
    </span>
</div>

<g:if test="${session.user}">
    <g:render template="/artifact/common/watching"
              model="[artifactInstance: artifactInstance, watching: watching]"/>
</g:if>

<g:render template="/artifact/common/tags"
          model="[artifactInstance: artifactInstance]"/>

<div class="fieldcontain">
    <span id="downloads-label" class="property-label"><g:message
        code="artifact.downloads.label"
        default="Downloads"/></span>

    <span class="property-value"
          aria-labelledby="downloads-label">${downloads}</span>
</div>

<div class="fieldcontain">
    <span id="rating-label" class="property-label"><g:message
        code="artifact.rating.label"
        default="Rating"/></span>

    <div class="artifact-show" aria-labelledby="rating-label">
        <g:if test="${session.user}">
            <div class="artifact-ratings ratings">
                <rateable:ratings bean='${artifactInstance}'/><br clear="all"/><br clear="all"/>
            </div>
        </g:if>
        <g:else>
            <g:render template="/shared/rating_offline"
                      model="[artifactInstance: artifactInstance, login: true]"/>
            <br clear="all"/><br clear="all"/>
        </g:else>
    </div>
</div>
<!-- END: HEADER -->