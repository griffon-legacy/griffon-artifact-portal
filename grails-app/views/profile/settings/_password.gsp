<div class="row">
    <div class="span8">
        <g:render template="/shared/errors_and_messages"
                  model="[bean: command]"/>
        <ui:form controller="profile" mapping="settings_update_password"
                 params="[username: profileInstance.user.username]">
            <g:hiddenField name="profileId" value="${profileInstance.id}"/>
            <g:hiddenField name="userId" value="${profileInstance.user.id}"/>

            <ui:field bean="${command}" name="oldPassword">
                <ui:fieldLabel><label for="oldPassword"
                                      class="control-label">Current Password:</label></ui:fieldLabel>
                <ui:fieldInput>
                    <input autocomplete="off" id="oldPassword"
                           name="oldPassword"
                           tabindex="1" class="input input-xlarge"
                           type="password"/>
                </ui:fieldInput>
                <ui:fieldErrors></ui:fieldErrors>
                <ui:fieldHint>
                    <span class="help-inline"><g:link controller="user"
                                                      action="forgot_password"
                                                      mapping="forgot_password">Forgot your password?</g:link></span>
                </ui:fieldHint>
            </ui:field>

            <ui:field bean="${command}" name="newPassword">
                <ui:fieldLabel><label for="newPassword"
                                      class="control-label">New Password:</label></ui:fieldLabel>
                <ui:fieldInput>
                    <g:passwordField name="newPassword" required="true"
                                     class="input-xlarge" autocomplete="off"
                                     value="${command.newPassword}"/>
                </ui:fieldInput>
                <ui:fieldErrors></ui:fieldErrors>
            </ui:field>

            <ui:field bean="${command}" name="newPassword2">
                <ui:fieldLabel><label for="newPassword2"
                                      class="control-label">Verify New Password:</label></ui:fieldLabel>
                <ui:fieldInput>
                    <g:passwordField name="newPassword2" required="true"
                                     class="input-xlarge" autocomplete="off"
                                     value="${command.newPassword2}"/>
                </ui:fieldInput>
                <ui:fieldErrors></ui:fieldErrors>
                <ui:fieldHint>
                    <small class="help-inline help-error" id="nomatch"
                           style="display:none;">Passwords don't match</small>
                </ui:fieldHint>
            </ui:field>

            <ui:actions>
                <ui:button mode="inverse">Save</ui:button>
            </ui:actions>
        </ui:form>
    </div>

    <div class="span3">
        <h3>Password</h3>

        <p>Be tricky! Your password should be at least 6 characters long and not a dictionary word or common name. Please use a password that you don't use anywhere else and change your password on occasion.</p>

        <p>Never enter your password in a third-party service or software that looks suspicious.</p>
    </div>
</div>

<script language="javascript">
    $('input:password').val('');
    $('#oldPassword').focus();
    $('#newPassword2,#newPassword').keyup(function () {
        if ($('#newPassword2').val() != '') {
            if ($('#newPassword2').val() != $('#newPassword').val()) {
                $('#nomatch').show();
                $('#newPassword2').parent().parent().addClass('error');
            } else {
                $('#nomatch').hide();
                $('#newPassword2').parent().parent().removeClass('error');
            }
        }
    });
</script>