<%@ page import="griffon.portal.auth.Membership" %>
<div id="${user}_membership">
<g:each in="['PENDING', 'ACCEPTED', 'REJECTED', 'NOT_REQUESTED', 'ADMIN']" var="state">
    <g:if test="${state ==  currentStatus}">
        <g:img id="${user}_${state}" dir="images" file="membership/${state}_active.png" alt='${state}'/>
    </g:if>
    <g:else>
        <g:remoteLink uri="/admin/user/${user}/change/${state}" update='["success": "${user}_membership", "failure": "messages"]'>
            <g:img id="${user}_${state}" dir="images" file="membership/${state}.png" alt='${state}'/>
        </g:remoteLink>
    </g:else>
</g:each>
</div>