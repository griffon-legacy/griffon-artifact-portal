<%@ page import="grails.util.GrailsNameUtils" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title>Plugins - ${categoryType.capitalizedName}</title>
</head>

<body>

<div class="page-header">
  <h1>${categoryType.capitalizedName} ${GrailsNameUtils.getNaturalName(params.type)}s (${artifactTotal})</h1>
</div>


<div class="row">
  <div class="span5">
    <g:render template="/shared/categories"/>
  </div>

  <div class="span11">
    <div class="row">
      <div class="span11">
        <g:each in="${'A'..'Z'}" var="c">
          <g:if test="${artifactMap[c]}">
            <strong><a href="#section_${c}">${c}</a></strong>
          </g:if>
          <g:else>
            ${c}
          </g:else>
        </g:each>
      </div>
    </div>

    <g:each in="${'A'..'Z'}" var="c">
      <g:if test="${artifactMap[c]}">
        <br clear="all"/>
        <br clear="all"/>

        <div class="row">
          <div class="span11">
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
        </div>
      </g:if>
    </g:each>
  </div>
</div>

</body>
</html>
