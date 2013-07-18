<!doctype html>
<html>
<head>
    <theme:layout name="plain"/>
    <theme:title text="portal.stats.title"/>
</head>

<body>

<theme:zone name="body">
    <tmpl:/shared/pageheader><h2>Griffon Artifact Portal Stats</h2></tmpl:/shared/pageheader>
    <div class="row">
        <div class="span11">
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
        <tmpl:/shared/pageheader><h1>World Downloads</h1></tmpl:/shared/pageheader>

        <div class="row" id="all">
            <div class="span4">
                <h2>All Downloads</h2>

                <p>All artifact downloads by country.</p>
            </div>

            <div class="span7">
                <gvisualization:geoChart elementId="worldMap" width="650"
                                         height="362"
                                         columns="${[['string', 'Country'], ['number', 'Total']]}"
                                         data="${downloadTotalsByCountry}"/>
                <div id="worldMap"></div>
                <%
                    def unresolvedDownloads = downloadTotalsByCountry.find { it[0] == 'Unresolved' }?.getAt(1) ?: 0
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
        <tmpl:/shared/pageheader><h1>Versions</h1></tmpl:/shared/pageheader>

        <div class="row" id="java">
            <div class="span4">
                <h2>Java</h2>

                <p>Java version reported by <code>X-Java-Version</code>, aggregated by major release
                </p>
            </div>

            <div class="span7">
                <gvisualization:pieCoreChart elementId="javaVersions"
                                             width="660" height="400"
                                             columns="${[['string', 'Version'], ['number', 'Total']]}"
                                             data="${javaVersions}"/>
                <div id="javaVersions"></div>
            </div>
        </div>

        <div class="row" id="griffon">
            <div class="span4">
                <h2>Griffon</h2>

                <p>Griffon version reported by <code>X-Griffon-Version</code>, aggregated by release. Snapshot releases are summed up to their corresponding stable release.
                </p>
            </div>

            <div class="span7">
                <gvisualization:barCoreChart elementId="griffonVersions"
                                             width="660"
                                             height="${60 + (20 * griffonVersions.size())}"
                                             columns="${[['string', 'Version'], ['number', 'Total']]}"
                                             data="${griffonVersions}"/>
                <div id="griffonVersions"></div>
            </div>
        </div>

        <div class="row" id="operatingSystem">
            <div class="span4">
                <h2>Operating System</h2>

                <p>Operating System version reported by <code>X-Os-Name</code> aggregated by type.
                </p>
            </div>

            <div class="span7">
                <gvisualization:pieCoreChart elementId="osNames" width="660"
                                             height="400"
                                             columns="${[['string', 'Name'], ['number', 'Total']]}"
                                             data="${osNames}"/>
                <div id="osNames"></div>
            </div>
        </div>
    </section>

</theme:zone>
</body>
</html>
