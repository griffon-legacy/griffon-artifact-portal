<%@ page import="griffon.portal.auth.Membership" %>
<div class="page-header">
  <div class="row">
    <div class="span2">
      <ul class="media-grid">
        <li>
          <a href="#">
            <avatar:gravatar cssClass="avatar thumbnail"
                             email="${profileInstance.gravatarEmail}" size="80"/>
          </a>
        </li>
      </ul>
    </div>

    <div class="span14">
      <div class="row">
        <div class="span10">
          <address>
            <h1><g:fieldValue bean="${profileInstance.user}" field="username"/></h1>
            <g:fieldValue bean="${profileInstance.user}" field="fullName"/><br/>
            <g:if test="${profileInstance.website}">
              <a href="${profileInstance.website}"><g:fieldValue bean="${profileInstance}" field="website"/></a><br/>
            </g:if>
            <small><g:message code="user.membership.label" default="Member since"/></small> <g:formatDate
                  date="${profileInstance.user.dateCreated}" format="MMM dd, yyyy"/>
          </address>
        </div>

        <div class="span4">
          <g:if test="${loggedIn}">
            <g:if test="${profileInstance.user.membership.status == Membership.Status.ACCEPTED}">
              <div id="modal-upload" class="modal hide fade">
                <div class="modal-header">
                  <a href="#" class="close">&times;</a>

                  <h3>${message(code: 'griffon.portal.button.upload.label', default: 'Upload a Release')}</h3>
                </div>

                <g:form url="[controller: 'release', action: 'upload']"
                        name="uploadForm" update="[failure: 'error']">
                  <div class="modal-body">
                    <p>Choose an artifact release package to upload</p>
                    <g:hiddenField name="fileName" id="fileName" value=""/>
                    <input type="file" size="50" name="upload-file" id="upload-file" placeholder="select a ZIP file"/>

                    <div id="upload-message"></div>
                  </div>

                  <div class="modal-footer">
                    <button type="submit" id="upload-submit"
                            class="btn primary">${message(code: 'default.button.submit.label', default: 'Submit')}</button>
                    <a href="#" id="upload-cancel"
                       class="btn danger">${message(code: 'default.button.close.label', default: 'Close')}</a>
                    <script language="javascript">
                      $('#upload-cancel').click(function () {
                        $('#modal-upload').modal('hide');
                        $('#uploadForm').resetForm();
                      });
                    </script>
                  </div>
                </g:form>
              </div>

              <button class="btn primary pull-right" data-controls-modal="modal-upload" data-backdrop="static"
                      data-keyboard="true" id="upload-apply">
                ${message(code: 'griffon.portal.button.upload.label', default: 'Upload a Release')}</button>
              <script language="javascript">
                $('#upload-apply').click(function () {
                  $('#upload-submit').show();
                  $('#upload-file').show();
                  $('#upload-message').html('');
                  $('#upload-cancel').removeClass('success');
                  $('#upload-cancel').addClass('danger');
                });
              </script>
            </g:if>
            <g:elseif test="${profileInstance.user.membership.status == Membership.Status.NOT_REQUESTED}">
              <div id="modal-membership" class="modal hide fade">
                <div class="modal-header">
                  <a href="#" class="close">&times;</a>

                  <h3>${message(code: 'griffon.portal.auth.User.membership.label', default: 'Developer Membership')}</h3>
                </div>

                <g:formRemote url="[controller: 'user', action: 'membership']"
                              name="membershipForm" update="[failure: 'error']"
                              onSuccess="handleMembershipResponse(data)">
                  <div class="modal-body">
                    <p>Please tell us a bit more about the project(s) you'd like to submit to this site</p>
                    <g:hiddenField name="id" value="${profileInstance.user.id}"/>
                    <div class="fieldcontain ${hasErrors(bean: profileInstance.user.membership, field: 'reason', 'error')} required">
                      <g:textArea name="reason" required="" cols="80" rows="4"/>
                    </div>

                    <div id="membership-error"></div>

                    <div id="membership-message"></div>
                  </div>

                  <div class="modal-footer">
                    <button type="submit" id="membership-submit"
                            class="btn primary">${message(code: 'default.button.submit.label', default: 'Submit')}</button>
                    <a href="#" id="membership-cancel"
                       class="btn danger">${message(code: 'default.button.close.label', default: 'Close')}</a>
                    <script language="javascript">
                      $('#membership-cancel').click(function () {
                        $('#modal-membership').modal('hide');
                      });
                    </script>
                  </div>
                </g:formRemote>
              </div>

              <button class="btn primary pull-right" data-controls-modal="modal-membership" data-backdrop="static"
                      data-keyboard="true" id="membership-apply">
                ${message(code: 'griffon.portal.button.membership.label', default: 'Apply for Membership')}</button>
            </g:elseif>
            <g:elseif test="${profileInstance.user.membership.status == Membership.Status.PENDING}">
              <button class="btn info disabled pull-right" id="membership-apply">
                ${message(code: 'griffon.portal.button.membership.pending.label', default: 'Applied for Membership')}</button>
            </g:elseif>
          </g:if>
        </div>
      </div>
    </div>

  </div>
</div>