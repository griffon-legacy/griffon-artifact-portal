<%@ page import="grails.util.GrailsNameUtils" %>
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
  <div class="span16">
    <div id="list-archetypes">
      <table>
        <thead>
        <tr>
          <th>${message(code: 'archetype.name.label', default: 'Name')}</th>
          <th>${message(code: 'archetype.title.label', default: 'Title')}</th>
          <th></th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${archetypeList}" status="i" var="archetypeInstance">
          <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
            <td>${GrailsNameUtils.getNaturalName(fieldValue(bean: archetypeInstance, field: "name").toString())}</td>
            <td>${fieldValue(bean: archetypeInstance, field: "title")}</td>
            <td>
              <div>
                <%
                  def formParams = [name: archetypeInstance.name]
                %>
                <g:form controller="archetype" action="show" params="${formParams}" mapping="showArchetype">
                  <g:hiddenField name="name" value="${archetypeInstance.name}"/>
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
