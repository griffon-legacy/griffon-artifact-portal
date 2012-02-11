<%@ page import="griffon.portal.values.Category" %>
<div class="categories">
  <table class="condensed-table">
    <thead>
    <th>Plugins</th>
    </thead>
    <tbody>
    <g:each in="${Category.values()}" var="category">
      <tr>
        <td style="border: 0">
          <g:link controller="artifact" action="${category.name}"
                  style="color: black; text-decoration: none;"
                  mapping="categories_plugin">${category.capitalizedName}</g:link>
        </td>
      </tr>
    </g:each>
    <tr>
      <th>Archetypes</th>
    </tr>
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