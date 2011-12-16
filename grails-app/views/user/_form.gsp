<div class="fieldcontain ${hasErrors(bean: userInstance, field: 'username', 'error')} required">
  <label for="username">
    <g:message code="user.username.label" default="Username"/>
    <span class="required-indicator">*</span>
  </label>
  <g:textField name="username" required="" value="${userInstance?.username}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: userInstance, field: 'password', 'error')} required">
  <label for="password">
    <g:message code="user.password.label" default="Password"/>
    <span class="required-indicator">*</span>
  </label>
  <g:passwordField id="password" name="password" required="" value="${userInstance?.password}"/>
</div>

<div class="fieldcontain required">
  <label for="password2">
    <g:message code="user.password2.label" default="Confirm Password"/>
    <span class="required-indicator">*</span>
  </label>
  <g:passwordField id="password2" name="password2" required="" value="${params?.password2}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: userInstance, field: 'email', 'error')} required">
  <label for="email">
    <g:message code="user.email.label" default="Email"/>
    <span class="required-indicator">*</span>
  </label>
  <g:field type="email" name="email" required="" value="${userInstance?.email}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: userInstance, field: 'fullName', 'error')} required">
  <label for="fullName">
    <g:message code="user.fullName.label" default="Full Name"/>
    <span class="required-indicator">*</span>
  </label>
  <g:textField name="fullName" required="" value="${userInstance?.fullName}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: userInstance, field: 'membership.reason', 'error')} required">
  <label for="reason">
    <g:message code="user.membership.reason.label" default="Reason for joining"/>
    <span class="required-indicator">*</span>
  </label>
  <g:textArea name="reason" cols="40" rows="5" maxlength="1000" required=""
              value="${userInstance?.membership?.reason}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: userInstance, field: 'captcha', 'error')} required">
  <label for="captcha">
    <g:message code="user.captcha.label" default="Please enter the text as shown below"/>
  </label>
  <g:textField name="captcha" required="true" value=""/><br clear="all"/><br clear="all"/>
  <label for="captcha">
    <g:message code="default.empty.label" default=""/>
  </label>
  <jcaptcha:jpeg name="image"/>
</div>