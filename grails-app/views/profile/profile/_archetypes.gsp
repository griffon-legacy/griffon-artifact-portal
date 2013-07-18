<%@ page import="grails.util.GrailsNameUtils" %>

<g:if test="${archetypeList}">
    <ui:table class="table-condensed">
        <thead>
        <ui:tr>
            <ui:th>${message(code: 'archetype.name.label', default: 'Name')}</ui:th>
            <ui:th>${message(code: 'archetype.title.label', default: 'Title')}</ui:th>
        </ui:tr>
        </thead>
        <tbody>
        <g:each in="${archetypeList}" status="i" var="archetypeInstance">
            <ui:tr>
                <td>
                    <g:link controller="${archetypeInstance.type}" action="show"
                            params="[name: archetypeInstance.name]"
                            mapping="show_${archetypeInstance.type}">${fieldValue(bean: archetypeInstance, field: "capitalizedName")}</g:link>
                </td>
                <td>${fieldValue(bean: archetypeInstance, field: "title")}</td>
            </ui:tr>
        </g:each>
        </tbody>
    </ui:table>

    <div class="pagination">
        <g:paginate action="show" params="[tab: tab, id: userId]"
                    total="${pluginTotal}" maxsteps="5"/>
    </div>
</g:if>
<g:else>
    <p>None available.</p>
</g:else>