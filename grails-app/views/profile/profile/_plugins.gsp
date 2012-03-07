<div class="<%=listSpan%>">
  <div class="row">
    <div class="<%=listSpan%>">
      <g:if test="${pluginList}">
        <table class="condensed-table zebra-striped">
          <thead>
          <tr>
            <th>${message(code: 'plugin.name.label', default: 'Name')}</th>
            <th>${message(code: 'plugin.title.label', default: 'Title')}</th>
          </tr>
          </thead>
          <tbody>
          <g:each in="${pluginList}" status="i" var="pluginInstance">
            <tr>
              <td>
                <g:link controller="${pluginInstance.type}" action="show" params="[name: pluginInstance.name]"
                        mapping="show_${pluginInstance.type}">${fieldValue(bean: pluginInstance, field: "capitalizedName")}</g:link>
              </td>
              <td>${fieldValue(bean: pluginInstance, field: "title")}</td>
            </tr>
          </g:each>
          </tbody>
        </table>
        <div class="pagination">
          <g:paginate action="show" params="[tab: tab, id: userId]" total="${pluginTotal}" maxsteps="5"/>
        </div>
      </g:if>
      <g:else>
        <p>None available.</p>
      </g:else>
    </div>
  </div>
</div>