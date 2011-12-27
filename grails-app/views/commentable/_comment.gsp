<div class="row">
  <div class="span16">
    <div id="comment${comment.id}" class="comment-container">
      <div class="row comment-header">
        <div class="span1">
          <ul class="media-grid">
            <li>
              <g:link controller="profile" action="show" id="${comment.poster.username}">
                <avatar:gravatar cssClass="avatar thumbnail"
                                 email="${comment.poster.profile.gravatarEmail}" size="50"/>
              </g:link>
            </li>
          </ul>
        </div>

        <div class="span10">
          <address>
            <h3>&nbsp;${comment.poster.username} <small>[<a href="#comment_${comment.id}"
                                                            name="comment_${comment.id}"><g:message
                      code="comment.link.text" default="permalink"></g:message></a>]</small></h3>
            <small>&nbsp;<g:formatDate format="MMM dd, yyyy HH:MM a" date="${comment.dateCreated}"/></small>
          </address>
        </div>
      </div>

      <div class="row">
        <div class="span1">&nbsp;</div>

        <div class="span14">
          <div class='commentBody'>
            ${comment?.body}
          </div>
        </div>

        <div class="span1">&nbsp;</div>
      </div>

    </div>
  </div>
</div>
<br clear="all"/>