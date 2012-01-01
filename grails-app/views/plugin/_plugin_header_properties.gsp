<%@ page import="griffon.portal.values.Toolkit; griffon.portal.values.Platform" %>
<div class="fieldcontain">
  <span id="toolkits-label" class="property-label"><g:message code="plugin.toolkits.label"
                                                              default="Toolkits"/></span>
  <g:set var="toolkits" value="${pluginInstance.toolkits.split(',')}"/>
  <span class="property-value" aria-labelledby="toolkits-label">
    <g:if test="${!pluginInstance.toolkits}">
      <g:set var="toolkits" value="${Toolkit.getLowercaseNamesAsList()}"/>
    </g:if>
    <g:each in="${toolkits}" var="toolkit">
      ${Toolkit.findByName(toolkit).name}
    </g:each>
  </span>
</div>

<div class="fieldcontain platforms">
  <span id="platforms-label" class="property-label"><g:message code="plugin.platforms.label"
                                                               default="Platforms"/></span>
  <g:set var="platforms" value="${pluginInstance.platforms.split(',')}"/>
  <g:if test="${pluginInstance.platforms.size() == 0}">
    <g:set var="platforms" value="${Platform.getLowercaseNamesAsList()}"/>
  </g:if>
  <ul>
    <g:each in="${platforms}" var="platform">
      <li>
        <g:img dir="images" class="thumbnail" file="logo-${platform.trim()}.gif"
               width="16" height="16" alt="${platform.trim()}"/>
      </li>
    </g:each>
  </ul>
</div>
