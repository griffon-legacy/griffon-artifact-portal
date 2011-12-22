<%@ page import="grails.util.GrailsNameUtils" %>

<%
  String listSpan = profileInstance.twitter ? 'span11' : 'span16'
%>

<div class="<%=listSpan%>">
  <div class="row">
    <div class="<%=listSpan%>">
      <g:if test="${archetypeList}">
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
              <td>${fieldValue(bean: archetypeInstance, field: "capitalizedName")}</td>
              <td>${fieldValue(bean: archetypeInstance, field: "title")}</td>
              <td>
                <g:link controller="${archetypeInstance.type}" action="show" params="[name: archetypeInstance.name]"
                        mapping="show_${archetypeInstance.type}"
                        class="btn small primary">${message(code: 'griffon.portal.button.info.label', default: 'More Info')}</g:link>
              </td>
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