<!doctype html>
<html>
<head>
    <theme:layout name="categorized"/>
    <theme:title text="portal.title"/>
</head>

<body>

<theme:zone name="body">
    <tmpl:/shared/pageheader><h2>Welcome to the Griffon Artifact Portal!</h2></tmpl:/shared/pageheader>
    <p>Welcome to the Griffon artifact portal. The place where you can find
    information about the latest plugins and archetypes available for the Griffon
    framework.</p>

    <p>As it happens with many open source projects, this portal is the result of
    the efforts of many individuals. We value your contributions and feedback,
    which is why we encourage you to
    <g:link controller="user" action="signup">sign-up</g:link> and let us know what
    you think. Registered users can vote up artifacts and edit their details.
    Furthermore, they may apply for <span class="label label-important">developer membership</span>,
    allowing them to publish artifacts to this site.
    </p>

    <p>This site also sports a <g:link controller="api" action="index">REST API</g:link>
    that can be used to query artifact metadata and download artifact files.
    </p>
</theme:zone>
</body>
</html>
