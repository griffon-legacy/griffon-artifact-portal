<div class="page-header">
  <div class="row">
    <div class="span2">
      <ul class="media-grid">
        <li>
          <a href="#">
            <avatar:gravatar cssClass="avatar thumbnail"
                             email="${authorInstance.email}" size="80"/>
          </a>
        </li>
      </ul>
    </div>

    <div class="span14">
      <div class="row">
        <div class="span10">
          <address>
            <h1><g:fieldValue bean="${authorInstance}" field="name"/></h1>
            <g:fieldValue bean="${authorInstance}" field="email"/><br/>
          </address>
        </div>
      </div>
    </div>
  </div>
</div>