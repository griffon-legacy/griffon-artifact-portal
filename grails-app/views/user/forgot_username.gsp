<%@ page import="griffon.portal.auth.User" %>
<!doctype html>
<html>
<head>
    <theme:layout name="sidebar"/>
    <theme:title text="griffon.portal.auth.User.forgot_username.label"/>
</head>

<body>

<theme:zone name="pageheader">
    <tmpl:/shared/pageheader>
        <h2><g:message code="griffon.portal.auth.User.forgot_username.label"/></h2>
        <g:message code="griffon.portal.auth.User.forgot_username.message"/>
    </tmpl:/shared/pageheader>
</theme:zone>

<theme:zone name="sidebar">
</theme:zone>

<theme:zone name="body">
    <g:render template="/shared/errors_and_messages"
              model="[bean: command]"/>

    <ui:form action="forgot_username" mapping="forgot_username">
        <g:hiddenField name="filled" value="true"/>

        <g:render template="/shared/form_field" model="[bean: command, field: 'email']"/>
        <g:render template="/shared/captcha_field" model="[bean: command]"/>
        <ui:actions>
            <ui:button mode="inverse">Next</ui:button>
            <ui:button mode="cancel">Cancel</ui:button>
        </ui:actions>
    </ui:form>
</theme:zone>

</body>
</html>