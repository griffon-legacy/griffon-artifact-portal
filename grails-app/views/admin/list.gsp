<%@ page import="griffon.portal.auth.Membership" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title><g:message code="admin.user.list.label"/></title>
  <script>
    function changed(user, state, data) {
      // TODO:
      $('#status').val('${Membership.Status.ACCEPTED}')
    }
  </script>
</head>

<body>

<tmpl:/pageheader>
  <h1><g:message code="admin.user.list.label"/></h1>
  <g:message code="admin.user.list.message"/>
</tmpl:/pageheader>

<div class="row">
  <div class="span16">
    <div class="" role="main">
      <div id="messages">
        <g:render template="/shared/errors_and_messages" model="[cssClass: 'span16']"/>
      </div>
      <table>
        <thead>
        <tr>
          <g:sortableColumn property="username" title="Name"/>
          <g:sortableColumn property="email" title="Email"/>
          <g:sortableColumn property="fullName" title="Full Name"/>
          <g:sortableColumn property="membership.status" title="Status"/>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${users}" status="i" var="user">
          <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
            <td><g:link controller="admin" action="show" mapping="admin_show_user"
                        params="[id: user.username]">${user.username?.encodeAsHTML()}</g:link></td>
            <td>${user.email?.encodeAsHTML()}</td>
            <td>${user.fullName?.encodeAsHTML()}</td>
            <td><g:render template="membership"
                          model="['user': user.username, 'currentStatus': user.membership?.status.toString()]"/></td>
            <td>
              <g:if test="${user.username != 'foo'}">
                <g:form name="delete_${user.username}" controller="admin" action="show" mapping="admin_delete_user"
                        params="[id: user.username]">
                  <g:submitButton class="btn primary"
                                  value="${message(code: 'admin.user.list.button.delete', default: 'Delete')}"
                                  name="delete"/>
                </g:form>
              </g:if>
            </td>
          </tr>
        </g:each>
        </tbody>
      </table>

      <div class="pagination">
        <g:paginate action="list" total="${userCount}" max="20"/>
      </div>
    </div>
  </div>
</div>
</body>
</html>
