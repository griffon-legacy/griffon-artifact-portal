<%@ page import="grails.util.GrailsNameUtils" %>
<!doctype html>
<html>
<head>
    <theme:layout name="categorized"/>
    <theme:title>${GrailsNameUtils.getNaturalName(params.type)}s - ${categoryType.capitalizedName}</theme:title>
</head>

<body>

<theme:zone name="body">
    <tmpl:/shared/pageheader>
        <h2>${GrailsNameUtils.getNaturalName(params.type)}s - ${categoryType.capitalizedName}<g:if
            test="${params.tagName}">: ${params.tagName} (${artifactTotal})</g:if></h2>
    </tmpl:/shared/pageheader>
    <g:if test="${artifactList}">
        <g:render template="artifact_box" collection="${artifactList}"
                  var="artifactInstance"/>
    </g:if>
    <g:else>
        <p><g:message code="categories.${categoryType.name}.unavailable"
                      args="[params.type]"/></p>
    </g:else>
</theme:zone>
</body>
</html>
<%--
<div class="pagination">
    <g:if test="${categoryType == griffon.portal.values.Category.TAGGED}">
      <g:paginate controller="tags" action="${params.type}" id="${params.tagName}" total="${artifactTotal}"/>
    </g:if>
    <g:else>
      <g:paginate action="${categoryType.name}" total="${artifactTotal}"/>
    </g:else>
</div>
--%>