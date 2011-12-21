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

  <%
    Map formParams = [username: profileInstance.user.username, tab: tab]
  %>
  <g:form controller="profile" mapping="sesstings_update_account" params="${formParams}">
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
      <input class="btn primary small" type="submit" value="Save"/>
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
