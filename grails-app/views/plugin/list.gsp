<%@ page import="grails.util.GrailsNameUtils" %>
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
  <div class="span16">
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
            <td>${GrailsNameUtils.getNaturalName(fieldValue(bean: pluginInstance, field: "name").toString())}</td>
            <td>${fieldValue(bean: pluginInstance, field: "title")}</td>
            <td>
              <%
                def formParams = [name: pluginInstance.name]
              %>
              <g:form controller="plugin" action="show" params="${formParams}" mapping="show_plugin">
                <g:hiddenField name="name" value="${pluginInstance.name}"/>
                <button class="btn primary small" type="submit" id="info" name="info">
                  ${message(code: 'griffon.portal.button.info.label', default: 'More Info')}</button>
              </g:form>
            </td>
          </tr>
        </g:each>
        </tbody>
      </table>
    </div>
  </div>
</div>

</body>
</html>
