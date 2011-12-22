<!doctype html>
<html>
<head>
  <meta name="layout" content="main"/>
  <title>Griffon Artifact Portal</title>
</head>

<body>

<div class="page-header">
  <h1>Welcome to the Griffon Artifact Portal!</h1>
</div>

<div class="row">
  <div class="span5">
    <g:render template="/shared/categories"/>
  </div>

  <div class="span11">
    <p>Welcome to the Griffon artifact portal. The place where you can find information about the latest plugins and archetypes available for the Griffon framework.</p>

    <p>As it happens with many open source projects, this portal is the result of the efforts of many individuals. We value your contributions and feedback, which is why we encourage you to <span
            class="label success"><g:link controller="user" action="signup">sign-up</g:link></span>
      and and let us know what you think. Registered users can vote up artifacts and edit their details. Furthermore, they may apply for <span
            class="label notice">developer membership</span>, allowing them to publish artifacts to this site.</p>

    <p>Lastly, this site sports a <span class="label important"><g:link controller="api"
                                                                        action="index">REST API</g:link></span> that can be used to query artifact metadata and download artifact files.
    </p>
  </div>
</div>

</body>
</html>
