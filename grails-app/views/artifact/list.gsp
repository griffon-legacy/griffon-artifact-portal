<%@ page import="grails.util.GrailsNameUtils" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title>Plugins - ${categoryType.capitalizedName}</title>
</head>

<body>

<div class="page-header">
  <h1>${categoryType.capitalizedName} ${GrailsNameUtils.getNaturalName(params.type)}s</h1>
</div>


<div class="row">
  <div class="span5">
    <g:render template="/shared/categories"/>
  </div>

  <div class="span11">
    <g:render template="artifact" collection="${artifactList}" var="artifactInstance"/>
  </div>
</div>

</body>
</html>
