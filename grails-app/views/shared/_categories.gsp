<%@ page import="griffon.portal.values.Category" %>
<div class="categories">
    <table class="table table-condensed">
        <tbody>
        <tr>
            <ui:th>Plugins</ui:th>
        </tr>
        <g:each in="${Category.values()}" var="category">
            <tr>
                <td style="border: 0">
                    <g:link controller="artifact" action="${category.name}"
                            style="color: black; text-decoration: none;"
                            mapping="categories_plugin">${category.capitalizedName}</g:link>
                </td>
            <tr>
        </g:each>

        <tr>
            <ui:th>Archetypes</ui:th>
        <tr>
        <g:each in="${Category.values()}" var="category">
            <tr>
                <td style="border: 0">
                    <g:link controller="artifact" action="${category.name}"
                            style="color: black; text-decoration: none;"
                            mapping="categories_archetype">${category.capitalizedName}</g:link>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>