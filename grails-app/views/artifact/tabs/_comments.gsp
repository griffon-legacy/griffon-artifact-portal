<div class="comments">
  <g:render template="/commentable/comment"
            collection="${artifactInstance.comments}"
            var="comment"/>
</div>

<g:if test="${!session.user}">
  <g:link controller="user" action="login" mapping="signin"
          params="[originalURI: (request.forwardURI - application.contextPath)]">Post a comment</g:link>
</g:if>
<g:else>
  <div id="comment-new" style="display: none;">
    <div class="row">
      <div class="span5">
        <h3>Syntax</h3>

        <p>This editor accepts <a target="_new"
                                  href="http://daringfireball.net/projects/markdown/basics">Markdown</a> syntax.</p>
      </div>

      <div class="span11">

        <div class="row">
          <ul id="comment-tabs" name="comment-tabs" class="tabs" data-tabs="tabs">
            <li class="active"><a href="#comment-source">Source</a></li>
            <li><a href="#comment-preview">Preview</a></li>
          </ul>

          <div class="tab-content">
            <div class="active tab-pane clearfix" id="comment-source">
              <div class="input clearfix">
                <g:textArea name="comment-source-text" rows="5" cols="60" class="xxlarge" tabindex="1"/>
              </div>
            </div>

            <div class="tab-pane" id="comment-preview"></div>
          </div>
        </div>


        <div class="row">
          <div class="actions">
            <g:form name="form-comment-post" controller="artifact" action="comment_post" mapping="comment_post"
                    params="[name: artifactInstance.name, type: artifactInstance.type]">
              <g:hiddenField id="commentSource" name="commentSource" value=""/>
              <button class="btn primary" id="postComment" name="postComment" tabindex="2">
                Post it!</button>
            </g:form>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div id="preview-error" style="display: none;"></div>

  <p><a href="#" class="btn primary" id="comment-trigger">Post a comment</a></p>

  <div style="display: none;">
    <g:formRemote name="form-comment-preview" url="[controller: 'artifact', action: 'preview_comment']"
                  mapping="comment_preview" update="[failure: 'preview-error']" onSuccess="handleCommentPreview(data)">
      <g:hiddenField id="commentPreview" name="commentPreview" value=""/>
      <g:submitButton name="send-preview" value="Preview"/>
    </g:formRemote>
  </div>

  <script language="javascript">
    $('#comment-trigger').click(function () {
      $('#comment-new').show();
      $('#comment-trigger').hide();
    });
    $('#comment-tabs').bind('change', function (e) {
      $('#comment-preview').html('');
      if (endsWith(e.target.toString(), 'comment-preview')) {
        var text = $("#comment-source-text").val();
        if (!isEmpty(text)) {
          $('#commentPreview').val(text);
          $('#send-preview').click();
        }
      }
    });
    $('#postComment').click(function () {
      var text = $("#comment-source-text").val();
      if (!isEmpty(text)) {
        $('#commentSource').val(text);
        $('#form-comment-post').submit();
      }
    });
  </script>
</g:else>