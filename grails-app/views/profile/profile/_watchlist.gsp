<%@ page import="grails.util.GrailsNameUtils" %>

<%
  String listSpan = profileInstance.twitter ? 'span11' : 'span16'
%>

<div class="<%=listSpan%>">
  <div class="row">
    <div class="<%=listSpan%>">
      <g:if test="${watchlistList}">
      <%-- preload images --%>
        <g:img dir="images" file="watch_off.png" style="display: none"/>
        <g:img dir="images" file="watch_on.png" style="display: none"/>
        <table class="condensed-table zebra-striped">
          <thead>
          <tr>
            <th></th>
            <th>${message(code: 'artifact.type.label', default: 'Type')}</th>
            <th>${message(code: 'artifact.name.label', default: 'Name')}</th>
            <th>${message(code: 'artifact.title.label', default: 'Title')}</th>
            <th></th>
          </tr>
          </thead>
          <tbody>
          <g:each in="${watchlistList}" status="i" var="artifactInstance">
            <tr>
              <%
                def watchingId = "watching_${artifactInstance.type}_${artifactInstance.id}"
              %>
              <td><g:remoteLink controller="artifact" action="watch" id="${artifactInstance.id}"
                                mapping="watch_artifact"
                                onSuccess="toggleWatcher(data, '${watchingId}')"><g:img id="${watchingId}"
                                                                                        name="${watchingId}"
                                                                                        dir="images"
                                                                                        file="watch_on.png"/></g:remoteLink></td>
              <td>${fieldValue(bean: artifactInstance, field: "type")}</td>
              <td>${fieldValue(bean: artifactInstance, field: "capitalizedName")}</td>
              <td>${fieldValue(bean: artifactInstance, field: "title")}</td>
              <td>
                <div class="pull-right">
                  <g:link controller="${artifactInstance.type}" action="show" params="[name: artifactInstance.name]"
                          mapping="show_${artifactInstance.type}"
                          class="btn small primary">${message(code: 'griffon.portal.button.info.label', default: 'More Info')}</g:link>
                </div>
              </td>
            </tr>
          </g:each>
          </tbody>
        </table>
      </g:if>
      <g:else>
        <p>You have no items in your watching list.</p>
      </g:else>
    </div>
  </div>
</div>