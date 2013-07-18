<g:if test="${pluginList}">
    <ui:table class="table-condensed">
        <thead>
        <ui:tr>
            <ui:th>${message(code: 'plugin.name.label', default: 'Name')}</ui:th>
            <ui:th>${message(code: 'plugin.title.label', default: 'Title')}</ui:th>
        </ui:tr>
        </thead>
        <tbody>
        <g:each in="${pluginList}" status="i" var="pluginInstance">
            <ui:tr>
                <td>
                    <g:link controller="${pluginInstance.type}" action="show"
                            params="[name: pluginInstance.name]"
                            mapping="show_${pluginInstance.type}">${fieldValue(bean: pluginInstance, field: "capitalizedName")}</g:link>
                </td>
                <td>${fieldValue(bean: pluginInstance, field: "title")}</td>
            </ui:tr>
        </g:each>
        </tbody>
    </ui:table>

    <ui:paginate action="show" total="${pluginTotal}" params="[tab: tab, id: userId]"/>
</g:if>
<g:else>
    <p>None available.</p>
</g:else>