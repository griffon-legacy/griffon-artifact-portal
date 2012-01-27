<div class="span-two-thirds">
  <g:render template="/shared/errors_and_messages" model="[bean: command]"/>

  <g:form controller="profile" mapping="settings_update_account"
          params="[username: profileInstance.user.username, tab: tab]">
    <g:hiddenField name="profileId" value="${profileInstance.id}"/>
    <g:hiddenField name="userId" value="${profileInstance.user.id}"/>
    <div class="clearfix">
      <label for="fullName">Name</label>

      <div class="input">
        <input id="fullName" maxlength="20" name="fullName" size="20" type="text"
               value="${command.fullName}"/>

        <p class="help-block">Enter your real name, so people you know can recognize you.</p>
      </div>
    </div>

    <div class="clearfix">
      <label for="email">Email</label>

      <div class="input">
        <input id="email" name="email" size="30" type="text"
               value="${command.email}"/>

        <p class="help-block">
          Enter your primary email.
        </p>
      </div>
    </div>

    <div class="actions">
      <input class="btn primary" type="submit" value="Save"/>
    </div>

  </g:form>
</div>

<div class="span-one-third">
  <h3>Account</h3>

  <p>This information appears on your public profile, search results, and beyond.</p>
  <hr/>

  <h3>Tips</h3>

  <p><span class="label important">Important</span> The email you enter here will be used to determine the authorship of all your contributions; make sure you match this value with all artifacts you submit.</p>
  </p>

</div>
