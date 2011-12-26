<%@ page import="grails.util.GrailsNameUtils" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="categorized">
  <title>${GrailsNameUtils.getNaturalName(params.type)}s - ${categoryType.capitalizedName}</title>
</head>

<body>

<div class="row">
  <div class="page-header">
    <h1>${GrailsNameUtils.getNaturalName(params.type)}s - ${categoryType.capitalizedName} (${artifactTotal})</h1>
  </div>
</div>

<g:if test="${artifactMap}">
  <div class="row">
    <g:each in="${'A'..'Z'}" var="c">
      <g:if test="${artifactMap[c]}">
        <strong><a href="#section_${c}">${c}</a></strong>
      </g:if>
      <g:else>
        ${c}
      </g:else>
    </g:each>
  </div>
  <br clear="all"/>
  <br clear="all"/>
  <g:each in="${'A'..'Z'}" var="c">
    <g:if test="${artifactMap[c]}">
      <div class="row">
        <section id="#section_${c}">
          <h5>${c}</h5>
          <ul>
            <g:each in="${artifactMap[c]}" var="artifact">
              <li><g:link controller="${params.type}"
                          params="[name: artifact.name]">${artifact.name}</g:link> - ${artifact.title}</li>
            </g:each>
          </ul>
        </section>
      </div>
    </g:if>
  </g:each>
</g:if>
<g:else>
  <div class="row">
    <p><g:message code="categories.${categoryType.name}.unavailable" args="[params.type]"/></p>
  </div>
</g:else>

</body>
</html>
