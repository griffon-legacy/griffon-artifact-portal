<!-- BEGIN: AUTHORED_BY -->
<h3>Authored by:</h3>
<g:each in="${authorList}" var="author">
    <table>
        <tr>
            <td class="thumbnail">
                <g:if test="${author.username}">
                    <g:link controller="profile" action="show"
                            id="${author.username}"
                            mapping="profile">
                        <ui:avatar user="${author.email}" size="50"
                                   class="img-rounded"/>
                    </g:link>
                </g:if>
                <g:else>
                    <g:link controller="author" action="show"
                            id="${author.id}" mapping="author">
                        <ui:avatar user="${author.email}" size="50"
                                   class="img-rounded"/>
                    </g:link>
                </g:else>
            </td>
            <td>&nbsp;</td>
            <td>
                <address>
                    <strong>${author.name}</strong><br/>
                    <a mailto="">${author.email}</a>
                </address>
            </td>
        </tr>
    </table>
</g:each>
<!-- END: AUTHORED_BY -->