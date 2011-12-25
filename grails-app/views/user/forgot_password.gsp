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
        <fieldset class="form">
          <div class="fieldcontain ${hasErrors(bean: command, field: 'username', 'error')} required">
            <label for="username">
              <g:message code="user.username.label" default="Username"/>
              <span class="required-indicator">*</span>
            </label>
            <g:textField name="username" required="" value="${command?.username}"/>
          </div>

          <div class="fieldcontain ${hasErrors(bean: command, field: 'captcha', 'error')} required">
            <label for="captcha">
              <g:message code="user.captcha.label" default="Please enter the text as shown below"/>
            </label>
            <g:textField name="captcha" required="true" value=""/><br clear="all"/>
            <br clear="all"/>
            <br clear="all"/>
            <label for="captcha">
              <g:message code="default.empty.label" default=""/>
            </label>
            <jcaptcha:jpeg name="image"/>
          </div>

          <div class="actions">
            <button class="btn primary" type="submit" id="next" name="next">
              ${message(code: 'default.button.next.label', default: 'Next')}</button>
          </div>
        </fieldset>
      </g:form>
    </div>
  </div>
</div>

</body>
</html>
