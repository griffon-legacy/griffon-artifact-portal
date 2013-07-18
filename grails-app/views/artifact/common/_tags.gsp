<!-- BEGIN: TAGS -->
<div class="fieldcontain">
    <span id="tags-label" class="property-label">
        <g:if test="${!session.user}">
            <g:link controller="user" action="login" mapping="signin"
                    params="[originalURI: (request.forwardURI - application.contextPath)]"
                    title="Add or remove tags" class="btn btn-info"><i class="icon-tags icon-white"></i></g:link>
        </g:if>
        <g:else>
            <div id="modal-tags" class="modal hide fade">
                <div class="modal-header">
                    <h3>${artifactInstance.capitalizedType} ${artifactInstance.capitalizedName} - Tags</h3>
                </div>

                <g:formRemote
                    url="[controller: 'artifact', action: 'tag', mapping: 'tag_artifact', id: artifactInstance.id]"
                    name="tagsForm" update="[failure: 'tags-error']"
                    onSuccess="handleTagsResponse(data)">
                    <div class="modal-body">
                        <p>Add or remove tags for this artifact</p>
                        <input id="tags" name="tags" class="input-xlarge"
                               size="100" type="text"
                               value="${artifactInstance.tags.join(', ')}"/>

                        <p class="help-block">
                            Comma-separated list of terms.
                        </p>

                        <div id="tags-message"></div>

                        <div id="tags-error"></div>
                    </div>

                    <div class="modal-footer">
                        <button type="submit" id="tags-submit"
                                class="btn btn-inverse">${message(code: 'default.button.submit.label', default: 'Submit')}</button>
                        <a href="#" id="tags-cancel"
                           class="btn btn-danger">${message(code: 'default.button.close.label', default: 'Close')}</a>
                        <script language="javascript">
                            $('#tags-cancel').click(function () {
                                $('#modal-tags').modal('hide');
                                $('#tagsForm').resetForm();
                            });
                        </script>
                    </div>
                </g:formRemote>
            </div>

            <a href="#modal-tags" role="button"
               class="btn btn-info"
               data-toggle="modal"
               id="tags-apply"><i class="icon-tags icon-white"></i></a>
            <script language="javascript">
                $('#tags-apply').click(function () {
                    $('#tags-submit').show();
                    $('#tags-message').html('');
                    $('#tags-cancel').removeClass('btn-success');
                    $('#tags-cancel').addClass('btn-danger');
                });
            </script>
        </g:else>
    </span>

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