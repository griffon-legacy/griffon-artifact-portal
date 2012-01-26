<%@ page import="griffon.portal.auth.User" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title><g:message code="griffon.portal.auth.User.signup.label"/></title>
</head>

<body>

<tmpl:/pageheader>
  <h1><g:message code="griffon.portal.auth.User.signup.label"/> <small><g:message
          code="griffon.portal.auth.User.signup.message"/></small></h1>
</tmpl:/pageheader>

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
      <g:form action="subscribe" name="subscriptionForm" mapping="subscribe">
        <g:hiddenField name="filled" value="true"/>
        <fieldset>
          <div class="clearfix ${hasErrors(bean: command, field: 'username', 'error')}">
            <label for="username">
              <g:message code="user.username.label" default="Username"/>
            </label>

            <div class="input">
              <g:textField name="username" required="" tabindex="1" value="${command?.username}"/>
            </div>
          </div>

          <div class="clearfix ${hasErrors(bean: command, field: 'password', 'error')}">
            <label for="password">
              <g:message code="user.email.label" default="Email"/>
            </label>

            <div class="input">
              <g:passwordField id="password" name="password" autocomplete="off" required="" tabindex="2"
                               value="${command?.password}"/>
            </div>
          </div>

          <div class="clearfix required" id="containerPassword2">
            <label for="password2">
              Confirm password
            </label>

            <div class="input">
              <g:passwordField id="password2" name="password2" autocomplete="off" required="" tabindex="3"
                               value="${command?.password2}"/>
              <small class="help-inline help-error" id="nomatch" style="display:none;">Passwords don't match</small>
            </div>
          </div>

          <div class="clearfix ${hasErrors(bean: command, field: 'captcha', 'error')}">
            <label for="captcha">
              <g:message code="user.captcha.label" default="Please enter the text as shown below"/>
            </label>

            <div class="input">
              <g:textField name="captcha" required="true" tabindex="4" value=""/>
              <br/><br/><br/>
              <jcaptcha:jpeg name="image"/>
            </div>
          </div>
        </fieldset>

        <div class="actions">
          <button class="btn primary" type="submit" id="subscribe" name="subscribe" tabindex="7">
            ${message(code: 'griffon.portal.button.signup.label', default: 'Sign up')}</button>
        </div>
      </g:form>
    </div>
  </div>
</div>

<script language="javascript">
  $('#username').focus()
  $('#password2,#password').keyup(function () {
    if ($('#password2').val() != '') {
      if ($('#password2').val() != $('#password').val()) {
        $('#nomatch').show();
        $('#password2').parent().addClass('error');
      } else {
        $('#nomatch').hide();
        $('#password2').parent().removeClass('error');
      }
    }
  });
</script>

</body>
</html>
