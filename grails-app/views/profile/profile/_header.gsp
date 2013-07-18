<%@ page import="grails.util.GrailsNameUtils; griffon.portal.auth.Membership" %>

<tmpl:/shared/pageheader>
    <table>
        <tr>
            <td class="thumbnail">
                <a href="#">
                    <ui:avatar user="${profileInstance.gravatarEmail}"
                               size="100"
                               class="img-rounded"/>
                </a>
            </td>
            <td>&nbsp;</td>
            <td>
                <address>
                    <h2><g:fieldValue bean="${profileInstance.user}"
                                      field="username"/></h2>
                    <g:fieldValue bean="${profileInstance.user}"
                                  field="fullName"/>
                    <small>(<g:message code="user.membership.label"
                                       default="Member since"/></small>
                    <g:formatDate date="${profileInstance.user.dateCreated}"
                                  format="MMM dd, yyyy"/><small>)</small>
                    <br/>
                    <g:if test="${profileInstance.website}">
                        <a href="${profileInstance.website}"><g:fieldValue
                            bean="${profileInstance}" field="website"/></a>
                    </g:if>
                </address>
            </td>
        </tr>
    </table>
</tmpl:/shared/pageheader>

<g:if test="${!GrailsNameUtils.isBlank(profileInstance.bio)}">
    <h3>Bio</h3>

    <p>${profileInstance.bio}</p>
</g:if>

<g:if test="${loggedIn}">
    <g:if
        test="${profileInstance.user.membership.status == Membership.Status.ACCEPTED}">
        <div id="modal-upload" class="modal hide fade" aria-hidden="true">
            <div class="modal-header">
                <h3>${message(code: 'griffon.portal.button.upload.label', default: 'Upload a Release')}</h3>
            </div>

            <g:form url="[controller: 'release', action: 'upload']"
                    name="uploadForm" update="[failure: 'error']">
                <div class="modal-body">
                    <p>Choose an artifact release package to upload</p>
                    <g:hiddenField name="fileName" id="fileName" value=""/>
                    <input type="file" size="50" name="upload-file"
                           id="upload-file" placeholder="select a ZIP file"/>

                    <div id="upload-message"></div>
                </div>

                <div class="modal-footer">
                    <button type="submit" id="upload-submit"
                            class="btn btn-inverse">${message(code: 'default.button.submit.label', default: 'Submit')}</button>
                    <a href="#" id="upload-cancel"
                       class="btn btn-danger">${message(code: 'default.button.close.label', default: 'Close')}</a>
                    <script language="javascript">
                        $('#upload-cancel').click(function () {
                            $('#modal-upload').modal('hide');
                            $('#uploadForm').resetForm();
                        });
                    </script>
                </div>
            </g:form>
        </div>
        <a href="#modal-upload" role="button"
           class="btn btn-success pull-right"
           data-toggle="modal"
           id="upload-apply">${message(code: 'griffon.portal.button.upload.label', default: 'Upload a Release')}</a>
        <script language="javascript">
            $('#upload-apply').click(function () {
                $('#upload-submit').show();
                $('#upload-file').show();
                $('#upload-message').html('');
                $('#upload-cancel').removeClass('btn-success');
                $('#upload-cancel').addClass('btn-danger');
            });
        </script>
    </g:if>
    <g:elseif
        test="${profileInstance.user.membership.status == Membership.Status.NOT_REQUESTED}">
        <div id="modal-membership" class="modal hide fade" aria-hidden="true">
            <div class="modal-header">
                <h3>${message(code: 'griffon.portal.auth.User.membership.label', default: 'Developer Membership')}</h3>
            </div>

            <g:formRemote url="[controller: 'user', action: 'membership']"
                          name="membershipForm" update="[failure: 'error']"
                          onSuccess="handleMembershipResponse(data)">
                <div class="modal-body">
                    <p>Please tell us a bit more about the project(s) you'd like to submit to this site</p>
                    <g:hiddenField name="id"
                                   value="${profileInstance.user.id}"/>
                    <div
                        class="fieldcontain ${hasErrors(bean: profileInstance.user.membership, field: 'reason', 'error')} required">
                        <g:textArea name="reason" required="" cols="80"
                                    rows="4" class="input-xxlarge"/>
                    </div>

                    <div id="membership-error"></div>

                    <div id="membership-message"></div>
                </div>

                <div class="modal-footer">
                    <button type="submit" id="membership-submit"
                            class="btn btn-inverse">${message(code: 'default.button.submit.label', default: 'Submit')}</button>
                    <a href="#" id="membership-cancel"
                       class="btn btn-danger">${message(code: 'default.button.close.label', default: 'Close')}</a>
                    <script language="javascript">
                        $('#membership-cancel').click(function () {
                            $('#modal-membership').modal('hide');
                        });
                    </script>
                </div>
            </g:formRemote>
        </div>

        <a href="#modal-membership" role="button"
           class="btn btn-danger pull-right"
           data-toggle="modal"
           id="membership-apply">${message(code: 'griffon.portal.button.membership.label', default: 'Apply for Membership')}</a>
    </g:elseif>
    <g:elseif
        test="${profileInstance.user.membership.status == Membership.Status.PENDING}">
        <a href="#" role="button"
           class="btn btn-inverse disabled pull-right">${message(code: 'griffon.portal.button.membership.pending.label', default: 'Applied for Membership')}</a>
    </g:elseif>
</g:if>