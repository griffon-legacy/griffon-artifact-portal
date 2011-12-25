<%@ page import="griffon.portal.auth.Membership; griffon.portal.auth.User" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title><g:message code="griffon.portal.auth.User.pending.label"/></title>
</head>

<body>

<div class="page-header">
  <h1><g:message code="griffon.portal.auth.User.pending.label"/></h1>
</div>

<div class="row">
  <div class="span16">
    <div id="list-user" class="scaffold-list" role="main">
      <g:if test="${flash.message}">
        <div class="message" role="status">${flash.message}</div>
      </g:if>
      <table>
        <thead>
        <tr>

          <g:sortableColumn property="username" title="${message(code: 'user.username.label', default: 'Username')}"/>
          <g:sortableColumn property="fullName" title="${message(code: 'user.fullName.label', default: 'Full Name')}"/>
          <g:sortableColumn property="email" title="${message(code: 'user.email.label', default: 'Email')}"/>
          <th>Action</th>

        </tr>
        </thead>
        <tbody>
        <g:each in="${userInstanceList}" status="i" var="userInstance">
          <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">

            <td>${fieldValue(bean: userInstance, field: "username")}</td>
            <td>${fieldValue(bean: userInstance, field: "fullName")}</td>
            <td>${fieldValue(bean: userInstance, field: "email")}</td>

            <td>
              <div>
                <g:form action="approveOrReject">
                  <g:hiddenField name="id" value="${userInstance.id}"/>
                  <g:hiddenField id="status" name="status" value=""/>
                  <button class="btn primary" type="submit" id="approve" name="approve">
                    ${message(code: 'griffon.portal.button.approve.label', default: 'Approve')}</button>
                  <button class="btn danger" type="submit" id="reject" name="reject">
                    ${message(code: 'griffon.portal.button.reject.label', default: 'Reject')}</button>
                </g:form>
              </div>
            </td>
          </tr>
        </g:each>
        </tbody>
      </table>

      <g:if test="${userInstanceTotal> 10}">
        <div class="pagination">
          <g:paginate total="${userInstanceTotal}"/>
        </div>
      </g:if>
    </div>
  </div>
</div>

<script>
  $('#approve').click(function () {
    $('#status').val('${Membership.Status.ACCEPTED}')
  });
  $('#reject').click(function () {
    $('#status').val('${Membership.Status.REJECTED}')
  });
</script>
</body>
</html>
