<%@ page import="grails.util.GrailsNameUtils" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="categorized">
  <title>${GrailsNameUtils.getNaturalName(params.type)}s - ${categoryType.capitalizedName}</title>
</head>

<body>

<div class="row">
  <tmpl:/pageheader><h1>${GrailsNameUtils.getNaturalName(params.type)}s - ${categoryType.capitalizedName}<g:if test="${params.tagName}">: ${params.tagName} (${artifactTotal})</g:if></h1></tmpl:/pageheader>
</div>

<div class="row">
  <g:if test="${artifactList}">
    <g:render template="artifact_box" collection="${artifactList}" var="artifactInstance"/>
  </g:if>
  <g:else>
    <p><g:message code="categories.${categoryType.name}.unavailable" args="[params.type]"/></p>
  </g:else>
</div>
<div class="pagination">
    <g:if test="${categoryType == griffon.portal.values.Category.TAGGED}">
      <g:paginate controller="tags" action="${params.type}" id="${params.tagName}" total="${artifactTotal}"/>
    </g:if>
    <g:else>
      <g:paginate action="${categoryType.name}" total="${artifactTotal}"/>
    </g:else>
</div>
</body>
</html>
