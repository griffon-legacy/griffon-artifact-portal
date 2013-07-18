<%@ page import="griffon.portal.auth.User" %>
<!doctype html>
<html>
<head>
    <theme:layout name="sidebar"/>
    <theme:title text="griffon.portal.auth.User.signup.label"/>
</head>

<body>

<theme:zone name="pageheader">
    <tmpl:/shared/pageheader>
        <h2><g:message code="griffon.portal.auth.User.signup.label"/></h2>
        <g:message code="griffon.portal.auth.User.signup.message"/>
    </tmpl:/shared/pageheader>
</theme:zone>

<theme:zone name="sidebar">
    <h3>Account Benefits</h3>

    <p>Signing up for an account grants you the following benefits:
    <ul>
        <li>Rate and comment artifacts.</li>
        <li>Edit artifact details.</li>
        <li>Apply for developer membership.</li>
    </ul>
    </p>
</theme:zone>

<theme:zone name="body">
    <g:render template="/shared/errors_and_messages"
              model="[bean: command]"/>

    <ui:form action="subscribe" name="subscriptionForm" mapping="subscribe">
        <g:hiddenField name="filled" value="true"/>

        <g:render template="/shared/form_field" model="[bean: command, field: 'username']"/>
        <g:render template="/shared/form_field" model="[bean: command, field: 'fullName']"/>
        <g:render template="/shared/form_field" model="[bean: command, field: 'email']"/>
        <g:render template="/shared/form_field" model="[bean: command, field: 'password', password: true]"/>

        <ui:field bean="${command}" name="password2" label="Confirm password">
            <ui:fieldInput>
                <g:passwordField name="password2" id="password2" required="true"
                             class="input-xlarge" value="${command.password2}"/>
                <small class="help-inline help-error" id="nomatch"
                       style="display:none;">Passwords don't match</small>
            </ui:fieldInput>
            <ui:fieldErrors> </ui:fieldErrors>
        </ui:field>

        <g:render template="/shared/captcha_field" model="[bean: command]"/>
        <ui:actions>
            <ui:button mode="inverse">Sign up</ui:button>
            <ui:button mode="cancel">Cancel</ui:button>
        </ui:actions>
    </ui:form>

    <script language="javascript">
        $('#username').focus()
        $('#password2,#password').keyup(function () {

            if ($('#password2').val() != '') {
                if ($('#password2').val() != $('#password').val()) {
                    $('#nomatch').show();
                    $('#password2').parent().parent().addClass('error');
                } else {
                    $('#nomatch').hide();
                    $('#password2').parent().parent().removeClass('error');
                }
            }
        });
    </script>
</theme:zone>

</body>
</html>