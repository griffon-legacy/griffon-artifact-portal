<%@ page import="griffon.portal.values.Toolkit; griffon.portal.values.Platform" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <title><g:message code="griffon.portal.Archetype.show.label" args="[archetypeName]"/></title>
</head>

<body>

<div class="page-header">
  <h1>${archetypeName} <small><p>${archetypeInstance.title}</p></small></h1>
</div>

<div class="row">
  <div class="span10">

    <div class="fieldcontain">
      <span id="license-label" class="property-label"><g:message code="artifact.license.label"
                                                                 default="License"/></span>
      <span class="property-value" aria-labelledby="license-label">
        <g:fieldValue bean="${archetypeInstance}" field="license"/>
      </span>
    </div>
    <g:if test="${session.user}">
      <div class="fieldcontain">
        <span id="watching-label" class="property-label">
          <%-- preload images --%>
          <g:img dir="images" file="watch_off.png" style="display: none"/>
          <g:img dir="images" file="watch_on.png" style="display: none"/>
          <g:remoteLink controller="artifact" action="watch" id="${archetypeInstance.id}" mapping="watch_artifact"
                        onSuccess="toggleWatcher(data)"><g:img id="watching" name="watching"
                                                               dir="images"
                                                               file="watch_${watching? 'on' :'off'}.png"/></g:remoteLink>
        </span>
        <span class="property-value" aria-labelledby="watching-label">
          Receive updates when a release is posted
        </span>
      </div>
    </g:if>
  </div>

  <div class="span4">
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

        <div class="span2">
          <address>
            <strong>${author.name}</strong><br/>
            <a mailto="">${author.email}</a>
          </address>
        </div>
      </div>
    </g:each>
  </div>
</div>

<div class="row">
  <div class="span16">
    <table class="condensed-table zebra-stripped">
      <thead>
      <tr>
        <th>${message(code: 'release.artifactVersion.label', default: 'Version')}</th>
        <th>${message(code: 'release.griffonVersion.label', default: 'Griffon Version')}</th>
        <th>${message(code: 'release.dateCreated.label', default: 'Date')}</th>
        <th>${message(code: 'release.checksum.label', default: 'Checksum')}</th>
        <th></th>
      </tr>
      </thead>
      <tbody>
      <g:each in="${releaseList}" status="i" var="releaseInstance">
        <tr>
          <td>${fieldValue(bean: releaseInstance, field: "artifactVersion")}</td>
          <td>${fieldValue(bean: releaseInstance, field: "griffonVersion")}</td>
          <td><g:formatDate format="dd-MM-yyyy" date="${releaseInstance.dateCreated}"/></td>
          <td>${fieldValue(bean: releaseInstance, field: "checksum")}</td>
          <td>
            <g:link controller="release" action="show" params="[id: releaseInstance.id]" mapping="show_release"
                    class="btn primary small">${message(code: 'griffon.portal.button.info.label', default: 'More Info')}</g:link>
            <g:link controller="release" action="download" params="[id: releaseInstance.id]" mapping="download_release"
                    class="btn success small">${message(code: 'griffon.portal.button.download.label', default: 'Download')}</g:link>
          </td>
        </tr>
      </g:each>
      </tbody>
    </table>
  </div>
</div>

<script>
  function toggleWatcher(data) {
    var src = $('#watching').attr('src');
    src = src.substring(0, src.lastIndexOf('/'));
    if (data.status) {
      src += '/watch_on.png';
    } else {
      src += '/watch_off.png';
    }
    $('#watching').attr('src', src);
  }
</script>
</body>
</html>
