<%
  String listSpan = profileInstance.twitter ? 'span11' : 'span16'
%>

<div class="<%=listSpan%>">
  <div class="row">
    <div class="<%=listSpan%>">
      <g:if test="${pluginList}">
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
      </g:if>
      <g:else>
        <p>None available.</p>
      </g:else>
    </div>
  </div>
</div>