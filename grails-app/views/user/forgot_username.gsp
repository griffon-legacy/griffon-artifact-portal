<%@ page import="griffon.portal.User" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title>Griffon</title>
</head>

<body>

<div class="page-header">
  <h1><g:message code="griffon.portal.User.forgot_username.label"/></h1>
  <g:message code="griffon.portal.User.forgot_username.message"/>
</div>

<div class="row">
  <div class="span16">
    <div id="resend-username" class="scaffold-create" role="main">
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
      <g:form action="forgot_username" mapping="forgot_username">
        <fieldset class="form">
          <div class="fieldcontain ${hasErrors(bean: command, field: 'email', 'error')} required">
            <label for="email">
              <g:message code="user.email.label" default="Email"/>
              <span class="required-indicator">*</span>
            </label>
            <g:field type="email" name="email" required="" value="${command?.email}"/>
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

          <div class="fieldcontain required">
            <br clear="all"/>
            <label for="next"></label>
            <button class="btn primary" type="submit" id="next" name="next">
              ${message(code: 'default.button.next.label', default: 'Next')}</button>
            <button class="btn danger" onclick="${application.contextPath}">
              ${message(code: 'default.button.cancel.label', default: 'Cancel')}</button>
          </div>
        </fieldset>
      </g:form>
    </div>
  </div>
</div>

</body>
</html>
