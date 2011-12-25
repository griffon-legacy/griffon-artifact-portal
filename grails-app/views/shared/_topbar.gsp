<div class="topbar" data-dropdown="dropdown">
  <div class="topbar-inner">
    <div class="container">
      <div class="static-links">
        <a class="brand" href="${application.contextPath}"><img
                src="${resource(dir: 'images', file: 'griffon-icon-24x24.png')}" alt="Griffon"
                align="left"/>&nbsp;Griffon</a>
        <%
          def isHomeActive = {->
            !params.controller || !(params.controller in ['plugin', 'archetype', 'profile', 'api']) ? 'active' : ''
          }
          def isMenuActive = { String tabName ->
            params?.controller == tabName ? 'active' : ''
          }
        %>
        <div id="global-nav">
          <ul id="global-actions">
            <li id="global-nav-home" class="<%=isHomeActive()%>"><a href="${application.contextPath}">Home</a></li>
            <li id="global-nav-plugins" class="<%=isMenuActive('plugin')%>"><a
                    href="${application.contextPath}/plugins">Plugins</a></li>
            <li id="global-nav-archetypes" class="<%=isMenuActive('archetype')%>"><a
                    href="${application.contextPath}/archetypes">Archetypes</a></li>
            <li id="global-nav-api" class="<%=isMenuActive('api')%>"><a
                    href="${application.contextPath}/api">API</a></li>
            <g:if test="${session.user}">
              <li id="global-nav-profile" class="<%=isMenuActive('profile')%>"><a
                      href="${application.contextPath}/profile/show/${session.user.username}">Profile</a></li>
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
                <li><g:link controller="profile" action="settings">Settings</g:link></li>
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