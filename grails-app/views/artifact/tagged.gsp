<%@ page import="grails.util.GrailsNameUtils" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="categorized">
  <title>${GrailsNameUtils.getNaturalName(params.type)}s - ${categoryType.capitalizedName}</title>
</head>

<body>

<div class="row">
  <tmpl:/pageheader><h1>${GrailsNameUtils.getNaturalName(params.type)}s - ${categoryType.capitalizedName}</h1></tmpl:/pageheader>
</div>

<div class="row">
  <g:if test="${tagMap}">
    <p>Click on any tag to list all plugins tagged with it.</p>

    <div class="tags">
      <gtags:tagCloud tags="${tagMap}" mapping="list_tagged_${params.type}s"
                      controller="artifact" action="list_tagged"
                      idProperty="tagName"/>
    </div>
  </g:if>
  <g:else>
    <p><g:message code="categories.${categoryType.name}.unavailable" args="[params.type]"/></p>
  </g:else>
</div>

</body>
</html>
