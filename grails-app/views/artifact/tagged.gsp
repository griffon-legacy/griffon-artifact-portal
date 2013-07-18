<%@ page import="grails.util.GrailsNameUtils" %>
<!doctype html>
<%
    String capitalizedType = GrailsNameUtils.getNaturalName(params.type)
%>
<html>
<head>
    <theme:layout name="categorized"/>
    <theme:title>${capitalizedType}s - ${categoryType.capitalizedName}</theme:title>
</head>

<body>

<theme:zone name="body">
    <div class="row">
        <tmpl:/shared/pageheader>
            <h1>${capitalizedType}s - ${categoryType.capitalizedName}</h1>
        </tmpl:/shared/pageheader>
    </div>

    <div class="row">
        <g:if test="${tagMap}">
            <p>Click on any tag to list all ${params.type}s tagged with it.</p>

            <div class="tags">
                <gtags:tagCloud tags="${tagMap}" mapping="list_tagged"
                                params="[type: params.type]"
                                controller="artifact" action="list_tagged"
                                idProperty="tagName"/>
            </div>
        </g:if>
        <g:else>
            <p><g:message code="categories.${categoryType.name}.unavailable"
                          args="[params.type]"/></p>
        </g:else>
    </div>
</theme:zone>
</body>
</html>