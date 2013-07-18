<%@ page import="griffon.portal.auth.Membership" %>
<div id="${user}_membership">
    <div class="btn-toolbar">
        <div class="btn-group">
            <g:each
                in="['PENDING': 'icon-exclamation-sign', 'ACCEPTED': 'icon-ok-sign', 'REJECTED': 'icon-minus-sign', 'NOT_REQUESTED': ' icon-remove-sign']"
                var="status">
                <g:if test="${status.key == currentStatus}">
                    <a href="#" class="btn btn-danger"><i
                        class="${status.value} icon-white"></i></a>
                </g:if>
                <g:else>
                    <g:remoteLink
                        uri="/admin/user/${user}/change/${status.key}"
                        class="btn"
                        update='["success": "${user}_membership", "failure": "messages"]'>
                        <i class="${status.value}"></i>
                    </g:remoteLink>
                </g:else>
            </g:each>
        </div>
    </div>
</div>