<%@ page import="griffon.portal.auth.Membership" %>
<!doctype html>
<html>
<head>
    <theme:layout name="plain"/>
    <theme:title text="admin.user.list.label"/>
</head>

<body>

<theme:zone name="body">
    <tmpl:/shared/pageheader>
        <h2><g:message code="admin.user.list.label"/></h2>
        <g:message code="admin.user.list.message"/>
    </tmpl:/shared/pageheader>

    <div id="messages">
        <g:render template="/shared/errors_and_messages"/>
    </div>
    <ui:table>
        <thead>
        <ui:tr>
            <g:sortableColumn property="username" title="Name"/>
            <g:sortableColumn property="email" title="Email"/>
            <g:sortableColumn property="fullName" title="Full Name"/>
            <g:sortableColumn property="membership.status" title="Status"/>
            <th>Actions</th>
        </ui:tr>
        </thead>
        <tbody>
        <g:each in="${users}" status="i" var="user">
            <ui:tr>
                <td><g:link controller="admin" action="show"
                            mapping="admin_show_user"
                            params="[id: user.username]">${user.username?.encodeAsHTML()}</g:link></td>
                <td>${user.email?.encodeAsHTML()}</td>
                <td>${user.fullName?.encodeAsHTML()}</td>
                <td><g:render template="membership"
                              model="['user': user.username, 'currentStatus': user.membership?.status.toString()]"/></td>
                <td>
                    <g:if test="${user.username != 'foo'}">
                        <g:form name="delete_${user.username}"
                                controller="admin" action="show"
                                mapping="admin_delete_user"
                                params="[id: user.username]">
                            <g:submitButton class="btn btn-inverse"
                                            value="${message(code: 'admin.user.list.button.delete', default: 'Delete')}"
                                            name="delete"/>
                        </g:form>
                    </g:if>
                </td>
            </ui:tr>
        </g:each>
        </tbody>
    </ui:table>

    <ui:paginate action="list" total="${userCount}"/>
</theme:zone>
</body>
</html>
