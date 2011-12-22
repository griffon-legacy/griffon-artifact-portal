<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title>Archetypes</title>
</head>

<body>

<div class="page-header">
  <h1>Archetypes</h1>
</div>

<div class="row">
  <div class="span5">
    <g:render template="/shared/categories"/>
  </div>

  <div class="span11">
    <g:if test="${artifactlist}">
      <table class="condensed-table zebra-striped">
        <thead>
        <tr>
          <th>${message(code: 'archetype.name.label', default: 'Name')}</th>
          <th>${message(code: 'archetype.title.label', default: 'Title')}</th>
          <th></th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${archetypeList}" status="i" var="archetypeInstance">
          <tr>
          <tr>
            <td>${fieldValue(bean: archetypeInstance, field: "capitalizedName")}</td>
            <td>${fieldValue(bean: archetypeInstance, field: "title")}</td>
            <td><g:link controller="archetype" action="show" params="[name: archetypeInstance.name]" mapping="show_archetype"
                        class="btn primary small">
              ${message(code: 'griffon.portal.button.info.label', default: 'More Info')}</g:link></td>
          </tr>
          </tr>
        </g:each>
        </tbody>
      </table>
    </g:if>
    <g:else>
      <h2>No archetypes available</h2>
    </g:else>
  </div>
</div>

</body>
</html>
