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

<div class="topbar">
  <div class="fill">
    <div class="container">
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
      <ul class="nav">
        <li class="<%=isHomeActive()%>"><a href="${application.contextPath}">Home</a></li>
        <li class="<%=isTabActive('plugin')%>"><a href="${application.contextPath}/plugins">Plugins</a></li>
        <li class="<%=isTabActive('archetype')%>"><a href="${application.contextPath}/archetypes">Archetypes</a></li>
        <g:if test="${session.user}">
          <li class="<%=isTabActive('profile')%>"><a
                  href="${application.contextPath}/profile/${session.user.username}">Profile</a></li>
        </g:if>
      </ul>
      <g:if test="${!session.user}">
        <div class="pull-right">
          <g:form name="login" controller="user" action="login">
            <input class="input-small" type="text" id="username" name="username" placeholder="Username">
            <input class="input-small" type="password" id="password" name="password" placeholder="Password">
            <button class="btn small" onclick="return checkLogin();">Sign in</button>
          </g:form>
          <g:form controller="user" action="signup">
            &nbsp;
            <button class="btn small" type="submit">Sign up</button>
          </g:form>
        </div>
      </g:if>
      <g:else>
        <g:form controller="user" action="logout" class="pull-right">
          <button class="btn" type="submit">Logout</button>
        </g:form>
      </g:else>
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
    var password = $('#password').val();
    return !isEmpty(username) && !isEmpty(password);
  }
</script>
</body>
</html>