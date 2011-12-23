<div class="fieldcontain">
  <span id="license-label" class="property-label"><g:message code="artifact.license.label"
                                                             default="License"/></span>
  <span class="property-value" aria-labelledby="license-label">
    <g:fieldValue bean="${artifactInstance}" field="license"/>
  </span>
</div>

<div class="fieldcontain">
  <span id="source-label" class="property-label"><g:message code="artifact.source.label"
                                                            default="Source"/></span>
  <span class="property-value" aria-labelledby="source-label">
    <g:if test="${artifactInstance.source}">
      <a href="<g:fieldValue bean="${artifactInstance}" field="source"/>"><g:fieldValue bean="${artifactInstance}"
                                                                                        field="source"/></a>
    </g:if>
    <g:else>
      No source link specified
    </g:else>
  </span>
</div>

<g:if test="${session.user}">
  <g:render template="/shared/watching" model="[artifactInstance: artifactInstance, watching:watching]"/>
</g:if>

<div class="fieldcontain">
  <span id="tags-label" class="property-label"><g:message code="artifact.tags.label"
                                                            default="Tags"/></span>

  <span class="property-value" aria-labelledby="tags-label">
    ${artifactInstance.tags.join(', ')}
  </span>
</div>

<div class="fieldcontain">
  <span id="rating-label" class="property-label"><g:message code="artifact.rating.label"
                                                            default="Rating"/></span>

  <div class="artifact-show" aria-labelledby="rating-label">
    <g:if test="${session.user}">
      <div class="artifact-ratings ratings">
        <rateable:ratings bean='${artifactInstance}'/>
      </div>
    </g:if>
    <g:else>
      <g:render template="/shared/rating_offline" model="[artifactInstance: artifactInstance, login: true]"/>
    </g:else>
  </div>
</div>