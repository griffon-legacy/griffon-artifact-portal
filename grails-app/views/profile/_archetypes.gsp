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
                <%
                  formParams = [name: archetypeInstance.name]
                %>
                <g:form controller="archetype" action="show" params="${formParams}" mapping="show_archetype">
                  <g:hiddenField name="name" value="${archetypeInstance.name}"/>
                  <button class="btn primary small" type="submit" id="info" name="info">
                    ${message(code: 'griffon.portal.button.info.label', default: 'More Info')}</button>
                </g:form>
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