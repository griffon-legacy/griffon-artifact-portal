<!-- BEGIN: AUTHORED_BY -->
<h3>Authored by:</h3>
<ul class="media-list">
    <g:each in="${authorList}" var="author">
        <li class="media">
            <g:if test="${author.username}">
                <g:link controller="profile" action="show"
                        id="${author.username}" class="pull-left"
                        mapping="profile">
                    <ui:avatar user="${author.email}" size="50"
                               class="media-object img-rounded"/>
                </g:link>
            </g:if>
            <g:else>
                <g:link controller="author" action="show" class="pull-left"
                        id="${author.id}" mapping="author">
                    <ui:avatar user="${author.email}" size="50"
                               class="media-object img-rounded"/>
                </g:link>
            </g:else>

            <div class="media-body">
                <div class="media-heading">
                    <address>
                        <strong>${author.name}</strong><br/>
                        <a mailto="">${author.email}</a>
                    </address>
                </div>
            </div>
        </li>
    </g:each>
</ul>
<!-- END: AUTHORED_BY -->