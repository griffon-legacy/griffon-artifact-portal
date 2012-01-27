<%@ page import="griffon.portal.auth.User" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title><g:message code="griffon.portal.auth.User.signin.label"/></title>
</head>

<body>

<div class="page-header">
  <h1><g:message code="griffon.portal.auth.User.signin.label"/> <small><g:message
          code="griffon.portal.auth.User.signin.message"/></small></h1>
</div>

<div class="row">
  <div class="span-two-thirds">
    <div id="create-user" class="scaffold-create" role="main">
      <g:render template="/shared/errors_and_messages" model="[bean: command]"/>
      <g:form action="login" name="loginForm" mapping="login">
        <g:hiddenField name="originalURI" value="${params.originalURI}"/>
        <g:hiddenField name="filled" value="true"/>

        <fieldset>
          <div class="clearfix  ${hasErrors(bean: command, field: 'username', 'error')}">
            <label for="username">
              <g:message code="user.username.label" default="Username"/>
            </label>

            <div class="input">
              <g:textField name="username" required="" tabindex="1" value="${command?.username}"/>
            </div>
          </div>

          <div class="clearfix ${hasErrors(bean: command, field: 'password', 'error')}">
            <label for="passwd">
              <g:message code="user.password.label" default="Password"/>
            </label>

            <div class="input">
              <g:passwordField id="passwd" name="passwd" required="" tabindex="2" value="${command?.passwd}"/>
            </div>
          </div>
        </fieldset>

        <div class="actions">
          <button class="btn primary" type="submit" id="signin" name="signin" tabindex="3">
            ${message(code: 'griffon.portal.button.signin.label', default: 'Sign in')}</button>
        </div>
      </g:form>
    </div>
  </div>

  <div class="span-one-third">
    <h3>Options</h3>

    <p>
      Don't have an account? <g:link controller="user" name="signup" mapping="signup"
                                     action="signup">Signup!</g:link>
    </p>

    <p>
      Forgot your username? <g:link controller="user" name="forgot_username"
                                    mapping="forgot_username"
                                    action="forgot_username">Retrieve it!</g:link>
    </p>

    <p>
      Forgot your password? <g:link controller="user" name="forgot_password"
                                    mapping="forgot_password"
                                    action="forgot_password">Retrieve it!</g:link>
    </p>
  </div>

</div>

<script language="javascript">
  $('#username').focus();
</script>

</body>
</html>
