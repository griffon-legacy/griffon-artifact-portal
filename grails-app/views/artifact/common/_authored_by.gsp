<!-- BEGIN: AUTHORED_BY -->
<h3>Authored by:</h3>
<g:each in="${authorList}" var="author">
  <div class="row">
    <div class="span1">
      <ul class="media-grid">
        <li>
          <g:link controller="profile" action="show" id="${author.username}">
            <avatar:gravatar cssClass="avatar thumbnail"
                             email="${author.email}" size="40"/>
          </g:link>
        </li>
      </ul>
    </div>

    <div class="span3">
      <address>
        <strong>${author.name}</strong><br/>
        <a mailto="">${author.email}</a>
      </address>
    </div>
  </div>
</g:each>
<!-- END: AUTHORED_BY -->