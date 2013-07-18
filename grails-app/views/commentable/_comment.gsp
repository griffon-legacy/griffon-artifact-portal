<div id="comment${comment.id}" class="comment-container">
    <div class="comment-header">
        <div class="media">
            <g:link controller="profile" action="show"
                    class="pull-left"
                    id="${comment.poster.username}">
                <ui:avatar
                    class="media-object"
                    user="${comment.poster.profile.gravatarEmail}"
                    size="50"/>
            </g:link>

            <div class="media-body">
                <div class="media-heading">
                    <address>
                        <h3>&nbsp;${comment.poster.username} <small>[<a
                            href="#comment_${comment.id}"
                            name="comment_${comment.id}"><g:message
                                code="comment.link.text"
                                default="permalink"></g:message></a>]</small>
                        </h3>
                        <small>&nbsp;<g:formatDate format="MMM dd, yyyy HH:MM a"
                                                   date="${comment.dateCreated}"/></small>
                    </address>
                </div>
            </div>
        </div>

        <div class='commentBody'>
            ${comment?.body}
        </div>
    </div>
</div>
<br clear="all"/>