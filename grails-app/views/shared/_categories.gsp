<%@ page import="griffon.portal.values.Category" %>
<div class="categories">
  <table>
    <thead>
    <th>Plugins</th>
    </thead>
    <tbody>
    <tr>
      <td>
        <ul class="categories-links">
          <g:each in="${Category.values()}" var="category">
            <li><g:link controller="artifact" action="${category.name}"
                        mapping="categories_plugin"><g:img dir="images/categories"
                                                           file="${category.name}.png"/> ${category.capitalizedName}</g:link></li>
          </g:each>
        </ul>
      </td>
    </tr>
    </tbody>
  </table>
  <table>
    <thead>
    <th>Archetypes</th>
    </thead>
    <tbody>
    <tr>
      <td>
        <ul class="categories-links">
          <g:each in="${Category.values()}" var="category">
            <li><g:link controller="artifact" action="${category.name}"
                        mapping="categories_archetype"><g:img dir="images/categories"
                                                              file="${category.name}.png"/> ${category.capitalizedName}</g:link></li>
          </g:each>
        </ul>
      </td>
    </tr>
    </tbody>
  </table>
</div>