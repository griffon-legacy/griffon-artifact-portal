<div class="fieldcontain">
  <span id="tags-label" class="property-label">
    <g:if test="${!session.user}">
      <g:link controller="user" action="login" mapping="signin"
              params="[originalURI: (request.forwardURI - application.contextPath)]"><g:img dir="images"
                                                                                            file="tag.png"/></g:link>
    </g:if>
    <g:else>
      <div id="modal-tags" class="modal hide fade">
        <div class="modal-header">
          <a href="#" class="close">&times;</a>

          <h3>${artifactInstance.capitalizedType} ${artifactInstance.capitalizedName} - Tags</h3>
        </div>

        <g:formRemote url="[controller: 'artifact', action: 'tag', mapping: 'tag_artifact', id: artifactInstance.id]"
                      name="tagsForm" update="[failure: 'tags-error']"
                      onSuccess="handleTagsResponse(data)">
          <div class="modal-body">
            <div class="input clearfix">
              <p>Add or remove tags for this artifact</p>
              <input id="tags" name="tags" class="x-large" size="100" type="text"
                     value="${artifactInstance.tags.join(', ')}"/>

              <p class="help-block">
                Comma-separated list of terms.
              </p>
            </div>

            <div id="tags-message"></div>

            <div id="tags-error"></div>
          </div>

          <div class="modal-footer">
            <button type="submit" id="tags-submit"
                    class="btn primary">${message(code: 'default.button.submit.label', default: 'Submit')}</button>
            <a href="#" id="tags-cancel"
               class="btn danger">${message(code: 'default.button.close.label', default: 'Close')}</a>
            <script language="javascript">
              $('#tags-cancel').click(function () {
                $('#modal-tags').modal('hide');
                $('#tagsForm').resetForm();
              });
            </script>
          </div>
        </g:formRemote>
      </div>
      <a href="#" data-controls-modal="modal-tags" data-backdrop="static"
         data-keyboard="true" id="tags-apply"><g:img dir="images" file="tag.png"/></a>
      <script language="javascript">
        $('#tags-apply').click(function () {
          $('#tags-submit').show();
          $('#tags-message').html('');
          $('#tags-cancel').removeClass('success');
          $('#tags-cancel').addClass('danger');
        });

        function handleTagsResponse(data) {
          if (data.code == 'ERROR') {
            $('#tags-message').html('<p>An error occurred processing your request. Please try again.</p>');
            $('#tags-message').show();
          } else if (data.code == 'OK') {
            $('#tags-message').hide();
            $('#tags-submit').hide();
            $('#tags-cancel').toggleClass('danger success', true);
            $('#tags-apply').toggleClass('primary info', true);
            $('#tags-apply').attr('disabled', true);
            $('#artifact-tags').html(data.tags);
          }
        }
      </script>
    </g:else>
  &nbsp;<g:message code="artifact.tags.label" default="Tags"/></span>

  <span class="property-value" aria-labelledby="tags-label">
    <div id="artifact-tags">${artifactInstance.tags.join(', ')}</div>
  </span>
</div>