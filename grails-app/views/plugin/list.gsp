<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title>Plugins</title>
</head>

<body>

<div class="page-header">
  <h1>Plugins</h1>
</div>

<div class="row">
  <div class="span5">
    <g:render template="/shared/categories"/>
  </div>

  <div class="span11">
    <g:if test="${pluginList}">
      <div id="list-plugins">
        <table class="condensed-table zebra-striped">
          <thead>
          <tr>
            <th>${message(code: 'plugin.name.label', default: 'Name')}</th>
            <th>${message(code: 'plugin.title.label', default: 'Title')}</th>
            <th></th>
          </tr>
          </thead>
          <tbody>
          <g:each in="${pluginList}" status="i" var="pluginInstance">
            <tr>
              <td>${fieldValue(bean: pluginInstance, field: "capitalizedName")}</td>
              <td>${fieldValue(bean: pluginInstance, field: "title")}</td>
              <td><g:link controller="plugin" action="show" params="[name: pluginInstance.name]" mapping="show_plugin"
                          class="btn primary small">
                ${message(code: 'griffon.portal.button.info.label', default: 'More Info')}</g:link></td>
            </tr>
          </g:each>
          </tbody>
        </table>
      </div>
    </g:if>
    <g:else>
      <h2>No plugins available</h2>
    </g:else>
  </div>
</div>

</body>
</html>
