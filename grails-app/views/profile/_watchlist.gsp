<%@ page import="grails.util.GrailsNameUtils" %>

<%
  String listSpan = profileInstance.twitter ? 'span11' : 'span16'
%>

<div class="<%=listSpan%>">
  <div class="row">
    <div class="<%=listSpan%>">
      <h2>Plugins</h2>
      <g:if test="${watchlistMap.plugin}">
        <table class="condensed-table zebra-striped">
          <thead>
          <tr>
            <th>${message(code: 'plugin.name.label', default: 'Name')}</th>
            <th>${message(code: 'plugin.title.label', default: 'Title')}</th>
            <th></th>
          </tr>
          </thead>
          <tbody>
          <g:each in="${watchlistMap.plugin}" status="i" var="pluginInstance">
            <tr>
              <td>${GrailsNameUtils.getNaturalName(fieldValue(bean: pluginInstance, field: "name").toString())}</td>
              <td>${fieldValue(bean: pluginInstance, field: "title")}</td>
              <td>
                <%
                  def formParams = [name: pluginInstance.name]
                %>
                <g:form controller="plugin" action="show" params="${formParams}" mapping="showPlugin">
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
        <p>You are not watching plugins at all.</p>
      </g:else>
    </div>
  </div>

  <div class="row">
    <div class="<%=listSpan%>">
      <h2>Archetypes</h2>
      <g:if test="${watchlistMap.archetype}">
        <table class="condensed-table zebra-striped">
          <thead>
          <tr>
            <th>${message(code: 'archetype.name.label', default: 'Name')}</th>
            <th>${message(code: 'archetype.title.label', default: 'Title')}</th>
            <th></th>
          </tr>
          </thead>
          <tbody>
          <g:each in="${watchlistMap.archetype}" status="i" var="archetypeInstance">
            <tr>
              <td>${GrailsNameUtils.getNaturalName(fieldValue(bean: archetypeInstance, field: "name").toString())}</td>
              <td>${fieldValue(bean: archetypeInstance, field: "title")}</td>
              <td>
                <%
                  formParams = [name: archetypeInstance.name]
                %>
                <g:form controller="archetype" action="show" params="${formParams}" mapping="showArchetype">
                  <g:hiddenField name="name" value="${archetypeInstance.name}"/>
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
        <p>You are not watching archetypes at all.</p>
      </g:else>
    </div>
  </div>
</div>