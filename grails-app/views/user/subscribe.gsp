<!doctype html>
<html>
<head>
    <theme:layout name="plain"/>
    <theme:title>Griffon Artifact Portal - Subscription</theme:title>
</head>

<body>

<theme:zone name="pageheader">
    <tmpl:/shared/pageheader>
        <h2>Thank you!</h1>We'll get back to you soon.</h2>
    </tmpl:/shared/pageheader>
</theme:zone>

<theme:zone name="body">
    <p>A confirmation message has been sent to <span
        class="label important">${userInstance.email}</span><br/>
        Click on the link it contains to confirm your account.</p>
</theme:zone>

</body>
</html>