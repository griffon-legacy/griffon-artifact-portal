<%@ page import="griffon.portal.values.Category" %>
<div class="categories">
  <table>
    <thead>
    <th>Plugins</th>
    <th>Archetypes</th>
    </thead>
    <tbody>
    <tr>
      <td>
        <ul class="categories-links">
          <g:each in="${Category.values()}" var="category">
            <li><g:link controller="artifact" action="${category.name}"
                        mapping="categories_plugin">${category.capitalizedName}</g:link></li>
          </g:each>
        </ul>
      </td>
      <td>
        <ul class="categories-links">
          <g:each in="${Category.values()}" var="category">
            <li><g:link controller="artifact" action="${category.name}"
                        mapping="categories_archetype">${category.capitalizedName}</g:link></li>
          </g:each>
        </ul>
      </td>
    </tr>
    </tbody>
  </table>
</div>