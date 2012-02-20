<%@ page import="grails.util.GrailsNameUtils" %>

<div class="<%=listSpan%>">
  <div class="row">
    <div class="<%=listSpan%>">
      <g:if test="${archetypeList}">
        <table class="condensed-table zebra-striped">
          <thead>
          <tr>
            <th>${message(code: 'archetype.name.label', default: 'Name')}</th>
            <th>${message(code: 'archetype.title.label', default: 'Title')}</th>
          </tr>
          </thead>
          <tbody>
          <g:each in="${archetypeList}" status="i" var="archetypeInstance">
            <tr>
              <td>
                <g:link controller="${archetypeInstance.type}" action="show" params="[name: archetypeInstance.name]"
                        mapping="show_${archetypeInstance.type}">${fieldValue(bean: archetypeInstance, field: "capitalizedName")}</g:link>
              </td>
              <td>${fieldValue(bean: archetypeInstance, field: "title")}</td>
            </tr>
          </g:each>
          </tbody>
        </table>
      </g:if>
      <g:else>
        <p>None available.</p>
      </g:else>
    </div>
  </div>
</div>