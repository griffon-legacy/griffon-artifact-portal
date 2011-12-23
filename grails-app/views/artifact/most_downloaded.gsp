<%@ page import="grails.util.GrailsNameUtils" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title>${GrailsNameUtils.getNaturalName(params.type)}s - ${categoryType.capitalizedName}</title>
</head>

<body>

<div class="page-header">
  <h1>${GrailsNameUtils.getNaturalName(params.type)}s - ${categoryType.capitalizedName}</h1>
</div>


<div class="row">
  <div class="span5">
    <g:render template="/shared/categories"/>
  </div>

  <div class="span11">
    <g:render template="artifact_downloaded" collection="${downloadList}" var="downloadInstance"/>
  </div>
</div>

</body>
</html>
