<div class="span-two-thirds">
  <g:render template="/shared/errors_and_messages" model="[bean: command]"/>

  <g:form controller="profile" mapping="settings_update_password" params="[username: profileInstance.user.username, tab: tab]">
    <g:hiddenField name="profileId" value="${profileInstance.id}"/>
    <g:hiddenField name="userId" value="${profileInstance.user.id}"/>

    <div class="clearfix">
      <label for="oldPassword">Current Password:</label>

      <div class="input">
        <input autocomplete="off" id="oldPassword" name="oldPassword" tabindex="1"
               type="password"/>
        <span class="help-inline"><g:link controller="user" action="forgot_password"
                                          mapping="forgot_password">Forgot your password?</g:link></span>
      </div>
    </div>

    <div class="clearfix">
      <label for="newPassword">New Password:</label>

      <div class="input">
        <input autocomplete="off" id="newPassword" name="newPassword" tabindex="2" type="password"/> <span
              class="help-inline"></span>
      </div>
    </div>

    <div class="clearfix">
      <label for="newPassword2">Verify New Password:</label>

      <div class="input">

        <input autocomplete="off" id="newPassword2" name="newPassword2" tabindex="3"
               type="password"/>
        <small class="help-inline help-error" id="nomatch" style="display:none;">Passwords don't match</small>
      </div>
    </div>

    <div class="actions">
      <input class="btn primary" tabindex="4" type="submit" value="Change"/></div>
  </g:form>
</div>

<div class="span-one-third">
  <h3>Password</h3>

  <p>Be tricky! Your password should be at least 6 characters and not a dictionary word or common name. Please use a password that you don't use anywhere else and change your password on occasion.</p>

  <p>Never enter your password in a third-party service or software that looks suspicious.</p>

</div>

<script language="javascript">
  $('input:password').val('');
  $('#oldPassword').focus();
  $('#newPassword2,#newPassword').keyup(function () {
    if ($('#newPassword2').val() != '') {
      if ($('#newPassword2').val() != $('#newPassword').val()) {
        $('#nomatch').show();
        $('#newPassword2').parent().addClass('error');
      } else {
        $('#nomatch').hide();
        $('#newPassword2').parent().removeClass('error');
      }
    }
  });
</script>