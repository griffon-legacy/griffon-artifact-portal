<%@ page import="grails.util.GrailsNameUtils" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title>${GrailsNameUtils.getNaturalName(params.type)}s - ${categoryType.capitalizedName}</title>
</head>

<body>

<div class="page-header">
  <h1>${GrailsNameUtils.getNaturalName(params.type)}s - ${categoryType.capitalizedName}<g:if test="${params.tagName}">: ${params.tagName}</g:if></h1>
</div>


<div class="row">
  <div class="span5">
    <g:render template="/shared/categories"/>
  </div>

  <div class="span11">
    <g:if test="${artifactList}">
      <g:render template="artifact_box" collection="${artifactList}" var="artifactInstance"/>
    </g:if>
    <g:else>
      <p><g:message code="categories.${categoryType.name}.unavailable" args="[params.type]"/></p>
    </g:else>
  </div>
</div>

</body>
</html>
