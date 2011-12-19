<%@ page import="griffon.portal.Profile" %>
<!doctype html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <title><g:layoutTitle default="Grails"/></title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
  <link rel="apple-touch-icon" href="${resource(dir: 'images', file: 'apple-touch-icon.png')}">
  <link rel="apple-touch-icon" sizes="114x114" href="${resource(dir: 'images', file: 'apple-touch-icon-retina.png')}">
  <link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}" type="text/css">
  <link rel="stylesheet" href="${resource(dir: 'css', file: 'mobile.css')}" type="text/css">
  <r:require module="bootstrap"/>
  <r:require module="jquery"/>
  <g:layoutHead/>
  <r:layoutResources/>
  <link rel="stylesheet" href="${resource(dir: 'css', file: 'bootstrap-tweaks.css')}" type="text/css">
</head>

<body>

<div class="topbar" data-dropdown="dropdown">
  <div class="topbar-inner">
    <div class="container">
      <div class="static-links">
        <a class="brand" href="${application.contextPath}"><img
                src="${resource(dir: 'images', file: 'griffon-icon-24x24.png')}" alt="Griffon"
                align="left"/>&nbsp;Griffon</a>
        <%
          def isHomeActive = {->
            !params.controller || !(params.controller in ['plugin', 'archetype', 'profile']) ? 'active' : ''
          }
          def isTabActive = { String tabName ->
            params?.controller == tabName ? 'active' : ''
          }
        %>
        <div id="global-nav">
          <ul id="global-actions">
            <li id="global-nav-home" class="<%=isHomeActive()%>"><a href="${application.contextPath}">Home</a></li>
            <li id="global-nav-plugins" class="<%=isTabActive('plugin')%>"><a
                    href="${application.contextPath}/plugins">Plugins</a></li>
            <li id="global-nav-archetypes" class="<%=isTabActive('archetype')%>"><a
                    href="${application.contextPath}/archetypes">Archetypes</a></li>
            <g:if test="${session.user}">
              <li id="global-nav-profile" class="<%=isTabActive('profile')%>"><a
                      href="${application.contextPath}/profile/${session.user.username}">Profile</a></li>
            </g:if>
          </ul>
        </div>
        <g:form name="search-form" class="search-form pull-left" controller="search">
          <span class="glass js-search-action"><i></i></span>
          <input value="" placeholder="Search" name="q" id="search-query" type="text"/>
        </g:form>
      </div>

      <div class="active-links">
        <ul class="nav secondary-nav">
          <g:if test="${session.user}">
            <li class="dropdown">
              <g:link controller="profile" action="show" id="${session.user.username}"
                      class="dropdown-toggle"><avatar:gravatar
                      email="${session.profile.gravatarEmail}" size="16"/><span
                      class="screen-name">&nbsp;${session.user.username}</span></g:link>
              <ul class="dropdown-menu">
                <li><g:link controller="profile" action="settings" id="${session.user.username}">Settings</g:link></li>
                <li><a href="#">Help</a></li>
                <li class="divider"></li>
                <li><g:link controller="user" action="logout" mapping="logout">Sign out</g:link></li>
              </ul>
            </li>
          </g:if>
          <g:else>
            <li class="dropdown">
              <a href="#" class="dropdown-toggle" id="signin-link">Have an account? <strong>Sign in</strong></a>
              <ul class="dropdown-menu signin-dropdown">
                <li>
                  <div id="signin-form">
                    <g:form name="login" controller="user" action="login">
                      <fieldset class="textbox">
                        <input id="username" name="username" type="text" placeholder="Username"/>
                        <input id="passwd" name="passwd" type="password" placeholder="Password"/>
                      </fieldset>
                      <button class="btn small" type="submit" onclick="return checkLogin();">Sign in</button>
                    </g:form>
                  </div>
                </li>
                <li class="divider"></li>
                <li><g:link controller="user" action="forgot_password"
                            mapping="forgot_password">Forgot password?</g:link></li>
                <li><g:link controller="user" action="forgot_username"
                            mapping="forgot_username">Forgot username?</g:link></li>
                <li><g:link controller="user" action="signup" mapping="signup">Sign up for an account!</g:link></li>
              </ul>
            </li>
          </g:else>
        </ul>
      </div>
    </div>
  </div>
</div>

<div class="container">
  <div class="content">
    <g:layoutBody/>
  </div>

  <footer>
    <p>&copy; Griffon 2011</p>
  </footer>

</div>

<script language="javascript">
  function isEmpty(str) {
    return (!str || 0 === str.length || /^\s*$/.test(str));
  }

  function checkLogin() {
    var username = $('#username').val();
    var password = $('#passwd').val();
    return !isEmpty(username) && !isEmpty(password);
  }
</script>
</body>
</html>