<%@ page import="griffon.portal.auth.User" %>
<!doctype html>
<html>
<head>
    <theme:layout name="sidebar"/>
    <theme:title text="griffon.portal.auth.User.signin.label"/>
</head>

<body>

<theme:zone name="pageheader">
    <tmpl:/shared/pageheader>
        <h2><g:message code="griffon.portal.auth.User.signin.label"/></h2>
        <g:message code="griffon.portal.auth.User.signin.message"/>
    </tmpl:/shared/pageheader>
</theme:zone>

<theme:zone name="sidebar">
    <h3>Options</h3>

    <p>
        Don't have an account? <g:link controller="user" name="signup"
                                       mapping="signup"
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
</theme:zone>

<theme:zone name="body">
    <g:render template="/shared/errors_and_messages"
              model="[bean: command]"/>

    <ui:form action="login" name="loginForm" mapping="login">
        <g:hiddenField name="originalURI" value="${params.originalURI}"/>
        <g:hiddenField name="filled" value="true"/>

        <g:render template="/shared/form_field"
                  model="[bean: command, field: 'username']"/>
        <g:render template="/shared/form_field"
                  model="[bean: command, field: 'passwd', password: true]"/>

        <ui:actions>
            <ui:button mode="inverse">Sign in</ui:button>
            <ui:button mode="cancel">Cancel</ui:button>
        </ui:actions>
    </ui:form>
    <script language="javascript">
        $('#username').focus();
    </script>
</theme:zone>

</body>
</html>