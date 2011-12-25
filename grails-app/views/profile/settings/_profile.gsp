<div class="span-two-thirds">
  <g:if test="${flash.message}">
    <div class="alert-message success" id="output">
      <a class="close" href="#" onclick="$('#output').hide()">×</a>

      <p>${flash.message}</p>
    </div>
  </g:if>
  <g:hasErrors bean="${command}">
    <% int errorIndex = 0 %>
    <g:eachError bean="${command}" var="error">
      <div class="alert-message danger" id="error${errorIndex}">
        <a class="close" href="#" onclick="$('#error${errorIndex++}').hide()">×</a>
        <g:message error="${error}"/>
      </div>
    </g:eachError>
  </g:hasErrors>

  <g:form controller="profile" mapping="sesstings_update_profile" params="[username: profileInstance.user.username, tab: tab]">
    <g:hiddenField name="profileId" value="${profileInstance.id}"/>
    <g:hiddenField name="userId" value="${profileInstance.user.id}"/>

    <div class="clearfix">
      <label for="gravatarEmail">Avatar</label>

      <div class="input">
        <input id="gravatarEmail" name="gravatarEmail" size="30" type="text"
               value="${command.gravatarEmail}"/>

        <p class="help-block">
          Write down the email associated with your gravatar account.<br/>
          We won't spam you, honest!<br/>
          Change your avatar at <a href="http://gravatar.com">gravatar.com</a>.
        </p>
      </div>
    </div>

    <div class="clearfix">
      <label for="website">Web</label>

      <div class="input">
        <input id="website" name="website" rel="${command.website}" size="30" type="text"
               value="${command.website}"/>

        <p class="help-block">
          Have a homepage or a blog? Put the address here.
        </p>
      </div>
    </div>

    <div class="clearfix">
      <label for="twitter">Twitter</label>

      <div class="input">
        <input id="twitter" name="twitter" size="30" type="text" value="${command.twitter}"/>

        <p class="help-block">Have a twitter account? Let others know what you're up to.</p>
      </div>

    </div>


    <div class="clearfix">
      <label for="bio">Bio</label>

      <div class="input">
        <textarea class="xlarge" cols="40" id="bio" maxlength="500" name="bio"
                  rows="3">${command.bio}</textarea>

        <p class="help-block">

          About yourself in fewer than <span class='char-counter'>500</span> chars.
        </p>
      </div>
    </div>

    <div class="actions">
      <input class="btn primary small" type="submit" value="Save"/>
    </div>

  </g:form>
</div>

<div class="span-one-third">
  <h3>Profile</h3>

  <p>This information appears on your public profile, search results, and beyond.</p>
  <hr/>

  <h3>Tips</h3>

  <p>Filling in your profile information will help people find and contact you about your contributions.</p>

  <p><span
          class="label warning">Notice</span> You're gravatar email will be set to your account's email if you leave it blank.
  </p>

</div>
