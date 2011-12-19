<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <g:set var="username" value="${profileInstance.user.username}"/>
  <title><g:message code="griffon.portal.Profile.show.label" args="[username]"/></title>

  <meta name="layout" content="main"/>
</head>

<body>

<div class="page-header">
  <div class="row">
    <div class="span2">
      <ul class="media-grid">
        <li>
          <a href="#">
            <avatar:gravatar cssClass="avatar thumbnail"
                             email="${profileInstance.gravatarEmail}" size="80"/>
          </a>
        </li>
      </ul>
    </div>

    <div class="span14">
      <address>
        <h1><g:fieldValue bean="${profileInstance.user}" field="username"/></h1>
        <g:fieldValue bean="${profileInstance.user}" field="fullName"/><br/>
        <small><g:message code="user.membership.label" default="Member since"/></small> <g:formatDate
              date="${profileInstance.user.dateCreated}" format="MMM dd, yyyy"/>
      </address>
    </div>

  </div>
</div>

<div class="row">
  <div class="span16">
    <p>TBD</p>
  </div>
</div>
</body>
</html>