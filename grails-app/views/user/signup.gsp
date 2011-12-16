<%@ page import="griffon.portal.User" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title><g:message code="griffon.portal.User.singup.label"/></title>
</head>

<body>

<div class="page-header">
  <h1><g:message code="griffon.portal.User.singup.label"/> <small><g:message
          code="griffon.portal.User.singup.message"/></small></h1>
</div>

<div class="row">
  <div class="span16">
    <div id="create-user" class="scaffold-create" role="main">
      <g:if test="${flash.message}">
        <div class="message" role="status">${flash.message}</div>
      </g:if>
      <g:hasErrors bean="${userInstance}">
        <ul class="errors" role="alert">
          <g:eachError bean="${userInstance}" var="error">
            <li
              <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message
                    error="${error}"/></li>
          </g:eachError>
        </ul>
      </g:hasErrors>
      <g:form action="subscribe" name="subscriptionForm">
        <fieldset class="form">
          <g:render template="form"/>
          <div class="fieldcontain required">
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
