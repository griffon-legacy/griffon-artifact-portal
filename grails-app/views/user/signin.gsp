<%@ page import="griffon.portal.User" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title><g:message code="griffon.portal.User.signin.label"/></title>
</head>

<body>

<div class="page-header">
  <h1><g:message code="griffon.portal.User.signin.label"/> <small><g:message
          code="griffon.portal.User.signin.message"/></small></h1>
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
      <g:form action="login" name="loginForm">
        <fieldset class="form"><div
                class="fieldcontain ${hasErrors(bean: command, field: 'username', 'error')} required">
          <label for="username">
            <g:message code="user.username.label" default="Username"/>
            <span class="required-indicator">*</span>
          </label>
          <g:textField name="username" required="" value="${command?.username}"/>
        </div>
          <div class="fieldcontain ${hasErrors(bean: command, field: 'passwd', 'error')} required">
            <label for="passwd">
              <g:message code="user.password.label" default="Password"/>
              <span class="required-indicator">*</span>
            </label>
            <g:passwordField id="passwd" name="passwd" required="" value="${command?.passwd}"/>
          </div>

          <div class="fieldcontain required">
            <br clear="all"/>
            <label for="signin"></label>
            <button class="btn primary" type="submit" id="signin" name="signin">
              ${message(code: 'griffon.portal.button.signin.label', default: 'Sign in')}</button>
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
