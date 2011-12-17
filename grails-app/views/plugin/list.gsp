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
  <div class="span15">
    <div id="list-plugins">
      <table>
        <thead>
        <tr>
          <th>${message(code: 'plugin.name.label', default: 'Name')}</th>
          <th>${message(code: 'plugin.title.label', default: 'Title')}</th>
          <th></th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${pluginList}" status="i" var="pluginInstance">
          <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
            <td>${GrailsNameUtils.getNaturalName(fieldValue(bean: pluginInstance, field: "name").toString())}</td>
            <td>${fieldValue(bean: pluginInstance, field: "title")}</td>
            <td class="pull-right">
              <div>
                <%
                  def formParams = [name: pluginInstance.name]
                %>
                <g:form controller="plugin" action="show" params="${formParams}" mapping="showPlugin">
                  <g:hiddenField name="name" value="${pluginInstance.name}"/>
                  <button class="btn primary small" type="submit" id="info" name="info">
                    ${message(code: 'griffon.portal.button.info.label', default: 'More Info')}</button>
                </g:form>
              </div>
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
