<p>
    <g:if test="${artifactInstance.description}">
        <markdown:renderHtml>${artifactInstance.description}</markdown:renderHtml>
    </g:if>
    <g:else>
        No description available.
    </g:else>
</p>