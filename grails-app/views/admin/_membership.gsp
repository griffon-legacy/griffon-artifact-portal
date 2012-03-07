<%@ page import="griffon.portal.auth.Membership" %>
<div id="${user}_membership">
  <g:each in="['PENDING', 'ACCEPTED', 'REJECTED', 'NOT_REQUESTED']" var="status">
    <g:if test="${status == currentStatus}">
      <g:img id="${user}_${status}" dir="images" file="membership/${status}_active.png" alt='${status}'/>
    </g:if>
    <g:else>
      <g:remoteLink uri="/admin/user/$user/change/$status"
                    update='["success": "${user}_membership", "failure": "messages"]'>
        <g:img id="${user}_${status}" dir="images" file="membership/${status}.png" alt='${status}'/>
      </g:remoteLink>
    </g:else>
  </g:each>
</div>