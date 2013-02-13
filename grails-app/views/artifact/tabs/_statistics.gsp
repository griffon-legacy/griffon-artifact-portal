<div class="row">
    <div class="span16">
        <gvisualization:apiImport/>
        <%
            def downloadColumns = [['string', 'Country'], ['number', 'Total']]
        %>
        <gvisualization:geoChart elementId="worldMap" width="900" height="500"
                                 columns="${downloadColumns}"
                                 data="${downloadsPerCountry}"/>
        <div id="worldMap"></div>
        <%
            def unresolvedDownloads = downloadsPerCountry.find{ it[0] == 'Unresolved' }?.getAt(1) ?: 0
            def plural = unresolvedDownloads > 1
        %>
        <g:if test="${unresolvedDownloads}">
           <p>There ${plural ? 'are' : 'is'} ${unresolvedDownloads} download${plural ? 's' : ''} that could not be resolved to country name${plural ? 's' : ''}.</p>
        </g:if>
    </div>
</div>