<!-- BEGIN: TAGS -->
<div class="fieldcontain">
    <span id="tags-label" class="property-label">
        <g:if test="${!session.user}">
            <g:link controller="user" action="login" mapping="signin"
                    params="[originalURI: (request.forwardURI - application.contextPath)]"
                    title="Add or remove tags"><g:img
                dir="images"
                file="tag.png" style="vertical-align: middle"/></g:link>
        </g:if>
        <g:else>
            <div id="modal-tags" class="modal hide fade">
                <div class="modal-header">
                    <a href="#" class="close">&times;</a>

                    <h3>${artifactInstance.capitalizedType} ${artifactInstance.capitalizedName} - Tags</h3>
                </div>

                <g:formRemote
                    url="[controller: 'artifact', action: 'tag', mapping: 'tag_artifact', id: artifactInstance.id]"
                    name="tagsForm" update="[failure: 'tags-error']"
                    onSuccess="handleTagsResponse(data)">
                    <div class="modal-body">
                        <div class="input clearfix">
                            <p>Add or remove tags for this artifact</p>
                            <input id="tags" name="tags" class="x-large"
                                   size="100" type="text"
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
                                class="btn btn-inverse">${message(code: 'default.button.submit.label', default: 'Submit')}</button>
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
               data-keyboard="true" id="tags-apply"
               title="Add or remove tags"><g:img dir="images" file="tag.png"
                                                 style="vertical-align: middle"/></a>
            <script language="javascript">
                $('#tags-apply').click(function () {
                    $('#tags-submit').show();
                    $('#tags-message').html('');
                    $('#tags-cancel').removeClass('success');
                    $('#tags-cancel').addClass('danger');
                });
            </script>
        </g:else>
    &nbsp;<g:message code="artifact.tags.label" default="Tags"/></span>

    <span class="property-value" aria-labelledby="tags-label">
        <div id="artifact-tags">
            <g:if test="${!artifactInstance.tags}"><br/></g:if>
            <g:else>
                <g:each in="${artifactInstance.tags}" var="tag">
                    <g:link
                        uri="/tags/${artifactInstance.type}/${tag}">${tag}</g:link>
                </g:each>
            </g:else>
        </div>
    </span>
</div>
<!-- END: TAGS -->