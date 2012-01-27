<g:if test="${flash.message}">
  <div class="alert-message success" id="output">
    <a class="close" href="#" onclick="$('#output').hide()">×</a>

    <p>${flash.message}</p>
  </div>
</g:if>
<g:hasErrors bean="${bean}">
  <% int errorIndex = 0 %>
  <g:eachError bean="${bean}" var="error">
    <div class="alert-message danger" id="error${errorIndex}">
      <a class="close" href="#" onclick="$('#error${errorIndex++}').hide()">×</a>
      <g:message error="${error}"/>
    </div>
  </g:eachError>
</g:hasErrors>