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
  <div class="span16">
    <div id="create-user" class="scaffold-create" role="main">
      <g:if test="${flash.message}">
        <div class="alert-message danger" id="output">
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
              <span class="help-inline"><g:link controller="user" name="signup" mapping="signup"
                                                action="signup">Don't have an account? Signup!</g:link></span>
            </div>
          </div>

          <div class="clearfix ${hasErrors(bean: command, field: 'password', 'error')}">
            <label for="passwd">
              <g:message code="user.password.label" default="Password"/>
            </label>

            <div class="input">
              <g:passwordField id="passwd" name="passwd" required="" tabindex="2" value="${command?.passwd}"/>
              <span class="help-inline"><g:link controller="user" name="forgot_password" mapping="forgot_password"
                                                action="forgotPassword">Forgot your password?</g:link></span>
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
</div>

<script language="javascript">
  $('#username').focus();
</script>

</body>
</html>
