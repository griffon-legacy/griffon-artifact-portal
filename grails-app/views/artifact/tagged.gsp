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
    <g:if test="${tagMap}">
      <p>Click on any tag to list all plugins tagged with it.</p>

      <div class="tags">
        <gtags:tagCloud tags="${tagMap}" mapping="list_tagged_${params.type}s"
                        controller="artifact" action="list_tagged"
                        idProperty="tagName"/>
      </div>
    </g:if>
    <g:else>
      <p><g:message code="categories.tagged.unavailable" args="[params.type]"/></p>
    </g:else>
  </div>
</div>

</body>
</html>
