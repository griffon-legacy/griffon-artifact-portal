<%@ page import="grails.util.GrailsNameUtils" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="categorized">
  <title>${GrailsNameUtils.getNaturalName(params.type)}s - ${categoryType.capitalizedName}</title>
</head>

<body>

<div class="row">
  <tmpl:/pageheader><h1>${GrailsNameUtils.getNaturalName(params.type)}s - ${categoryType.capitalizedName} ${character ? "starting with $character ": ''}(${artifactTotal})</h1></tmpl:/pageheader>
</div>

<g:if test="${artifactMap}">
  <div class="row">
    <strong><g:link uri="/category/all/plugins">All</g:link></strong>
    <g:each in="${'A'..'Z'}" var="c">
      <g:if test="${artifactMap[c]}">
        <strong><g:link uri="/category/all/plugins/${c}">${c}</g:link></strong>
      </g:if>
      <g:else>
        ${c}
      </g:else>
    </g:each>
  </div>
  <br clear="all"/>
  <br clear="all"/>
  <g:set var="c" value=""/>
  <g:each in="${artifacts}" var="artifact">
    <g:if test="${artifact.name[0].toUpperCase() != c}">
      <g:if test="${c}">
          </ul>
        </section>
      </div>
      </g:if>
      <g:set var="c" value="${artifact.name[0].toUpperCase()}"/>
      <div class="row">
        <section id="#section_${c}">
          <h5>${c}</h5>
          <ul>
    </g:if>
            <li><g:link controller="${params.type}" params="[name: artifact.name]">${artifact.name}</g:link> - ${artifact.title}</li>
  </g:each>
          </ul>
        </section>
      </div>
</g:if>
<g:else>
  <div class="row">
    <p><g:message code="categories.${categoryType.name}.unavailable" args="[params.type]"/></p>
  </div>
</g:else>
<div class="pagination">
    <g:paginate action="all" total="${artifactTotal}" params="[character: character]"/>
</div>
</body>
</html>
