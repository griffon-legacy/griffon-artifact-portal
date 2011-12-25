<%@ page import="griffon.portal.values.Category" %>
<div class="categories">
  <table class="condensed-table">
    <thead>
    <th></th>
    <th>Plugins</th>
    </thead>
    <tbody>
    <g:each in="${Category.values()}" var="category">
      <tr>
        <td style="text-align: right; border: 0">
          <g:link controller="artifact" action="${category.name}"
                  mapping="categories_plugin"><g:img dir="images/categories" file="${category.name}.png"/></g:link>
        </td>
        <td style="border: 0">
          <g:link controller="artifact" action="${category.name}"
                  style="color: black; text-decoration: none;"
                  mapping="categories_plugin">${category.capitalizedName}</g:link>
        </td>
      </tr>
    </g:each>
    <tr>
      <th></th>
      <th>Archetypes</th>
    </tr>
    <g:each in="${Category.values()}" var="category">
      <tr>
        <td style="text-align: right; border: 0">
          <g:link controller="artifact" action="${category.name}"
                  mapping="categories_archetype"><g:img dir="images/categories" file="${category.name}.png"/></g:link>
        </td>
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