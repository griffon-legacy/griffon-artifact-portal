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
                <div class="pull-right">
                  <g:link controller="${pluginInstance.type}" action="show" params="[name: pluginInstance.name]"
                          mapping="show_${pluginInstance.type}"
                          class="btn primary">${message(code: 'griffon.portal.button.info.label', default: 'More Info')}</g:link>
                </div>
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