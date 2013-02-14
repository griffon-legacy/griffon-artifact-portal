<!doctype html>
<html>
<head>
    <title>Griffon Artifact Portal - Stats</title>
    <meta name="layout" content="main"/>
    <gvisualization:apiImport/>
</head>

<body>
<tmpl:/pageheader><h1>Griffon Artifact Portal Stats</h1></tmpl:/pageheader>

<div class="row">
    <div class="span16">
        <p>The following statistics were collected when artifacts were downloaded from this site.</p>
        <ul>
            <li><a href="#worldDownloads">World Downloads</a>
                <ul>
                    <li><a href="#all">All Downloads</a></li>
                </ul>
            </li>
            <li><a href="#versions">Versions</a>
                <ul>
                    <li><a href="#java">Java</a></li>
                    <li><a href="#griffon">Griffon</a></li>
                    <li><a href="#operatingSystem">Operating System</a></li>
                </ul>
            </li>
        </ul>
    </div>
</div>

<br/><br/>

<section id="worldDownloads">
    <tmpl:/pageheader><h1>World Downloads</h1></tmpl:/pageheader>

    <div class="row" id="all">
        <div class="span4">
            <h2>All Downloads</h2>

            <p>All artifact downloads by country.</p>
        </div>

        <div class="span12">
            <gvisualization:geoChart elementId="worldMap" width="650" height="362"
                                     columns="${[['string', 'Country'], ['number', 'Total']]}"
                                     data="${downloadTotalsByCountry}"/>
            <div id="worldMap"></div>
            <%
                def unresolvedDownloads = downloadTotalsByCountry.find{ it[0] == 'Unresolved' }?.getAt(1) ?: 0
                def plural = unresolvedDownloads > 1
            %>
            <g:if test="${unresolvedDownloads}">
                <p>There ${plural ? 'are' : 'is'} ${unresolvedDownloads} download${plural ? 's' : ''} that could not be resolved to country name${plural ? 's' : ''}.</p>
            </g:if>
        </div>
    </div>
</section>

<br/><br/>

<section id="versions">
    <tmpl:/pageheader><h1>Versions</h1></tmpl:/pageheader>

    <div class="row" id="java">
        <div class="span4">
            <h2>Java</h2>

            <p>Java version as reported by <code>X-Java-Version</code>.</p>
        </div>

        <div class="span12">
            <gvisualization:barCoreChart elementId="javaVersions" width="660" height="${60 + (20*javaVersions.size())}"
                                     columns="${[['string', 'Version'], ['number', 'Total']]}"
                                     data="${javaVersions}"/>
            <div id="javaVersions"></div>
        </div>
    </div>
    <div class="row" id="griffon">
        <div class="span4">
            <h2>Griffon</h2>

            <p>Griffon version as reported by <code>X-Griffon-Version</code>.</p>
        </div>

        <div class="span12">
            <gvisualization:barCoreChart elementId="griffonVersions" width="660" height="${60 + (20*griffonVersions.size())}"
                                         columns="${[['string', 'Version'], ['number', 'Total']]}"
                                         data="${griffonVersions}"/>
            <div id="griffonVersions"></div>
        </div>
    </div>
    <div class="row" id="operatingSystem">
        <div class="span4">
            <h2>Operating System</h2>

            <p>Operating System version as reported by <code>X-Os-Name</code>.</p>
        </div>

        <div class="span12">
            <gvisualization:barCoreChart elementId="osNames" width="660" height="${60 + (20*osNames.size())}"
                                         columns="${[['string', 'Version'], ['number', 'Total']]}"
                                         data="${osNames}"/>
            <div id="osNames"></div>
        </div>

        <g:each in="${osVersions}" var="os" status="index">
            <div class="span4">
                <h3>${os.key}</h3>
            </div>

            <div class="span12">
                <gvisualization:pieCoreChart elementId="osversion-${index}" width="660" height="400"
                                             columns="${[['string', 'Version'], ['number', 'Total']]}"
                                             data="${os.value}"/>
                <div id="osversion-${index}"></div>
            </div>
        </g:each>
    </div>
</section>

</body>
</html>