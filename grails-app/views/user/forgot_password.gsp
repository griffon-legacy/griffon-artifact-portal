<%@ page import="griffon.portal.auth.User" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title>Griffon</title>
</head>

<body>

<div class="page-header">
  <h1><g:message code="griffon.portal.auth.User.forgot_password.label"/></h1>
  <g:message code="griffon.portal.auth.User.forgot_password.message"/>
</div>

<div class="row">
  <div class="span16">
    <div id="resend-password" class="scaffold-create" role="main">
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
      <g:form action="forgot_password" mapping="forgot_password">
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
          <button class="btn primary" type="submit" id="next" name="next">
            ${message(code: 'default.button.next.label', default: 'Next')}</button>
        </div>
      </g:form>
    </div>
  </div>
</div>

</body>
</html>
