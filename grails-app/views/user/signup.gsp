<%@ page import="griffon.portal.User" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title><g:message code="griffon.portal.User.signup.label"/></title>
</head>

<body>

<div class="page-header">
  <h1><g:message code="griffon.portal.User.signup.label"/> <small><g:message
          code="griffon.portal.User.signup.message"/></small></h1>
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
      <g:hasErrors bean="${userInstance}">
        <% int errorIndex = 0 %>
        <g:eachError bean="${userInstance}" var="error">
          <div class="alert-message danger" id="error${errorIndex}">
            <a class="close" href="#" onclick="$('#error${errorIndex++}').hide()">×</a>
            <g:message error="${error}"/>
          </div>
        </g:eachError>
      </g:hasErrors>
      <g:form action="subscribe" name="subscriptionForm" mapping="subscribe">
        <fieldset class="form">
          <g:render template="form"/>
          <div class="fieldcontain required">
            <br clear="all"/>
            <label for="subscribe"></label>
            <button class="btn primary" type="submit" id="subscribe" name="subscribe">
              ${message(code: 'griffon.portal.button.signup.label', default: 'Sign up')}</button>
            <button class="btn danger" onclick="${application.contextPath}">
              ${message(code: 'default.button.cancel.label', default: 'Cancel')}</button>
          </div>
        </fieldset>
      </g:form>
    </div>
  </div>
</div>

<script language="javascript">
  function checkPasswords() {
    var match = $('#password2').val() == $('#password').val()
    if (match) {
      $('#password2').parent().removeClass('error')
    } else {
      $('#password2').parent().addClass('error')
    }
    return match;
  }

  $('#password2').blur(checkPasswords);
  $('#subscriptionForm').submit(function () {
    if (!checkPasswords()) {
      alert("Passwords do not match!")
      return false;
    }
    return true;
  });
</script>

</body>
</html>
