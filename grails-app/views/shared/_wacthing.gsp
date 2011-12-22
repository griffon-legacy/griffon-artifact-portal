<!-- BEGIN: WATCHING -->
<div class="fieldcontain">
  <span id="watching-label" class="property-label">
    <%-- preload images --%>
    <g:img dir="images" file="watch_off.png" style="display: none"/>
    <g:img dir="images" file="watch_on.png" style="display: none"/>
    <g:remoteLink controller="artifact" action="watch" id="${artifactInstance.id}" mapping="watch_artifact"
                  onSuccess="toggleWatcher(data)"><g:img id="watching" name="watching"
                                                         dir="images"
                                                         file="watch_${watching? 'on' :'off'}.png"/></g:remoteLink>
  </span>
  <span class="property-value" aria-labelledby="watching-label">
    Receive updates when a release is posted
  </span>
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
<!-- END: WATCHING -->