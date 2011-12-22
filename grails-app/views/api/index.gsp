<!doctype html>
<html>
<head>
  <title>Griffon Artifact Portal - API</title>
  <meta name="layout" content="main"/>
</head>

<body>
<div class="page-header">
  <h1>Griffon Artifact Portal API</h1>
</div>

<div class="row">
  <div class="span16">
    <p>This describes the resources that make up the official Griffon Portal API v1.</p>
    <ul>
      <li><a href="#basics">Basics</a>
        <ul>
          <li><a href="#connection">Connection</a></li>
          <li><a href="#errors">Errors</a></li>
        </ul>
      </li>
      <li><a href="#queries">Queries</a>
        <ul>
          <li><a href="#allartifacts">All artifacts</a></li>
          <li><a href="#singleartifact">Single artifact</a></li>
          <li><a href="#singlerelease">Single release</a></li>
        </ul>
      </li>
      <li><a href="#download">Download</a>
        <ul>
          <li><a href="#artifacts">Artifacts</a></li>
        </ul>
      </li>
      <li><a href="#repository">Repository</a>
        <ul>
          <li><a href="#metadata">Metadata</a></li>
          <li><a href="#files">Files</a></li>
        </ul>
      </li>
    </ul>
  </div>
</div>

<br clear="all"/><br clear="all"/>

<section id="basics">
  <div class="page-header">
    <h1>Basics <small>Connections &amp; errors.</small></h1>
  </div>

  <div class="row" id="connection">
    <div class="span5">
      <h2>Connection</h2>

      <p>All API access is over HTTP, and accessed from <code>${grailsApplication.config.serverURL}/api</code>. All data is received as JSON unless an artifact file or checksum is requested.
      </p>
    </div>

    <div class="span11">
      <code>$ curl -i ${grailsApplication.config.serverURL}/api/plugins</code><br clear="all"/><br clear="all"/>
      <pre class="prettyprint">
        HTTP/1.1 200 OK
        Server: Apache-Coyote/1.1
        Content-Type: application/json;charset=UTF-8
        Transfer-Encoding: chunked
        Date: Tue, 20 Dec 2011 12:20:40 GMT

        []
      </pre>
    </div>
  </div>

  <div class="row" id="errors">
    <div class="span5">
      <h2>Errors</h2>

      <p>All requests that result in a not found record will receive an HTTP <code>404</code> error in response, with a JSON payload containing the parameters sent.
      </p>
    </div>

    <div class="span11">
      <code>$ curl -i http://localhost:8080/griffon-artifact-portal/api/plugins/bogus</code><br clear="all"/><br clear="all"/>
      <pre class="prettyprint">
        HTTP/1.1 404 Not Found
        Server: Apache-Coyote/1.1
        Content-Type: application/json;charset=UTF-8
        Transfer-Encoding: chunked
        Date: Tue, 20 Dec 2011 12:25:26 GMT

        {
            "action": "info",
            "response": "Not Found",
            "params": {
                "type": "plugin",
                "name": "bogus"
            }
        }
      </pre>
    </div>
  </div>
</section>

<br clear="all"/><br clear="all"/>

<section id="queries">
  <div class="page-header">
    <h1>Queries <small>Retrieving artifact metadata.</small></h1>
  </div>

  <div class="row" id="allartifacts">
    <div class="span5">
      <h2>All artifacts</h2>

      <p>Obtain a list of all available plugins and/or archetypes by defining <code>/plugins</code> or <code>/archetypes</code>
        in the path.
      </p>

      <p>Successful responses will list artifacts sorted alphabetically by name. Releases will be sorted by their version in descending order.</p>
    </div>

    <div class="span11">
      <code>$ curl -i ${grailsApplication.config.serverURL}/api/plugins</code><br clear="all"/><br clear="all"/>
      <pre class="prettyprint">
        HTTP/1.1 200 OK
        Server: Apache-Coyote/1.1
        Content-Type: application/json;charset=UTF-8
        Transfer-Encoding: chunked
        Date: Tue, 20 Dec 2011 12:20:40 GMT

        [
            {
                "name": "glazedlists",
                "title": "Adds GlazedLists support to Views",
                "license": "Apache Software License 2.0",
                "toolkits": "swing",
                "platforms": "",
                "dependencies": [
                    {
                        "name": "swing",
                        "version": "0.9.5"
                    }
                ],
                "authors": [
                    {
                        "name": "Andres Almiray",
                        "email": "aalmiray@yahoo.com"
                    }
                ],
                "releases": [
                    {
                        "version": "0.8.3",
                        "griffonVersion": "0.9.4 > *",
                        "date": "2011-12-20T13:39:45+0100",
                        "checksum": "bf05ac0ad0bfedeeeacbf53c7f0c884b"
                        "comment": "First release"
                    }
                ]
            }
        ]
      </pre>
    </div>
   </div>

  <div class="row" id="singleartifact">
    <div class="span5">
      <h2>Single artifact</h2>

      <p>Use <code>/plugins/&lt;name&gt;</code> or <code>/archetypes/&lt;name&gt;</code> where <code>&lt;name&gt;</code> stands in
      for the artifact you'd like to query. Notice that the response will include a new element <code>description</code>
        that may contain a Markdown formatted description of the artifact's capabilities.
      </p>

      <p>Releases will be sorted by their version in descending order.</p>
    </div>

    <div class="span11">
      <code>$ curl -i ${grailsApplication.config.serverURL}/api/plugins/glazedlists</code><br clear="all"/><br clear="all"/>
      <pre class="prettyprint">
        HTTP/1.1 200 OK
        Server: Apache-Coyote/1.1
        Content-Type: application/json;charset=UTF-8
        Transfer-Encoding: chunked
        Date: Tue, 20 Dec 2011 12:20:40 GMT

        {
            "name": "glazedlists",
            "title": "Adds GlazedLists support to Views",
            "description": "Adds GlazedLists support to Views",
            "license": "Apache Software License 2.0",
            "toolkits": "swing",
            "platforms": "",
            "dependencies": [
                {
                    "name": "swing",
                    "version": "0.9.5"
                }
            ],
            "authors": [
                {
                    "name": "Andres Almiray",
                    "email": "aalmiray@yahoo.com"
                }
            ],
            "releases": [
                {
                    "version": "0.8.3",
                    "griffonVersion": "0.9.4 > *",
                    "date": "2011-12-20T13:39:45+0100",
                    "checksum": "bf05ac0ad0bfedeeeacbf53c7f0c884b"
                    "comment": "First release"
                }
            ]
        }
      </pre>
    </div>
  </div>

  <div class="row" id="singlerelease">
    <div class="span5">
      <h2>Single release</h2>

      <p>Use <code>/plugins/&lt;name&gt;/&lt;version&gt;</code> or <code>/archetypes/&lt;name&gt;/&lt;version&gt;</code> where <code>&lt;name&gt;</code> stands in
      for the artifact you'd like to query; <code>&lt;version&gt;</code> stands in for a particular release. Notice that the response will include a new element <code>description</code>
        that may contain a Markdown formatted description of the artifact's capabilities.
      </p>

      <p>Releases will be sorted by their version in descending order.</p>
    </div>

    <div class="span11">
      <code>$ curl -i ${grailsApplication.config.serverURL}/api/plugins/glazedlists/0.8.3</code><br clear="all"/><br clear="all"/>
      <pre class="prettyprint">
        HTTP/1.1 200 OK
        Server: Apache-Coyote/1.1
        Content-Type: application/json;charset=UTF-8
        Transfer-Encoding: chunked
        Date: Tue, 20 Dec 2011 12:20:40 GMT

        {
            "name": "glazedlists",
            "title": "Adds GlazedLists support to Views",
            "description": "Adds GlazedLists support to Views",
            "license": "Apache Software License 2.0",
            "toolkits": "swing",
            "platforms": "",
            "dependencies": [
                {
                    "name": "swing",
                    "version": "0.9.5"
                }
            ],
            "authors": [
                {
                    "name": "Andres Almiray",
                    "email": "aalmiray@yahoo.com"
                }
            ],
            "release":
                {
                   "version": "0.8.3",
                   "griffonVersion": "0.9.4 > *",
                   "date": "2011-12-20T13:39:45+0100",
                   "checksum": "bf05ac0ad0bfedeeeacbf53c7f0c884b"
                   "comment": "First release"
                }
        }
      </pre>
    </div>
  </div>
</section>

<br clear="all"/><br clear="all"/>

<section id="download">
  <div class="page-header">
    <h1>Download <small>Retrieving Zip files</small></h1>
  </div>

  <div class="row" id="artifacts">
    <div class="span5">
      <h2>Artifacts</h2>

      <p>Use <code>/plugins/&lt;name&gt;/download/&lt;version&gt;</code> or <code>/archetypes/&lt;name&gt;/download/&lt;version&gt;</code> where <code>&lt;name&gt;</code> stands in
      for the artifact you'd like to query; <code>&lt;version&gt;</code> stands in for a particular release.
      </p>
    </div>

    <div class="span11">
      <code>$ curl -i ${grailsApplication.config.serverURL}/api/plugins/glazedlists/download/0.8.3</code>
      <br clear="all"/><br clear="all"/>
      <pre class="prettyprint">
        HTTP/1.1 200 OK
        Server: Apache-Coyote/1.1
        Cache-Control: must-revalidate
        Accept-Ranges: bytes
        Last-Modified: Tue, 20 Dec 2011 13:39:45 CET
        Content-disposition: attachment; filename=griffon-glazedlists-0.8.3.zip
        Content-Type: application/octet-stream
        Content-Length: 173550
        Date: Tue, 20 Dec 2011 13:20:22 GMT

        *BINARY DATA*
      </pre>
    </div>
  </div>
</section>

<br clear="all"/><br clear="all"/>

<section id="repository">
  <div class="page-header">
    <h1>Repository <small>Ivy style repository view</small></h1>
  </div>

  <div class="row" id="metadata">
    <div class="span5">
      <h2>Metadata</h2>

      <p>It's possible to query all kinds of artifact metadata using an Ivy style repository with custom layout.</p>
    </div>

    <div class="span11">
      <p><code>/repository/plugins/</code><br/>
        Returns a JSON list of all plugins.</p>
      <p><code>/repository/plugins/&lt;name&gt;</code><br/>
        Returns metadata for a plugin named &lt;name&gt;.</p>
      <p><code>/repository/plugins/&lt;name&gt;/&lt;version&gt;</code><br/>
        Returns metadata for a plugin named &lt;name&gt; with version &lt;version&gt;.</p>
      <p><code>/repository/plugins/&lt;name&gt;/&lt;version&gt;/griffon-&lt;name&gt;-&lt;version&gt;.zip</code><br/>
        Downloads the plugin named &lt;name&gt; with version &lt;version&gt;.</p>
      <p><code>/repository/plugins/&lt;name&gt;/&lt;version&gt;/griffon-&lt;name&gt;-&lt;version&gt;.zip.md5</code><br/>
        Downloads the plugin's checksum whose name matches &lt;name&gt; and version matches &lt;version&gt;.</p>
      <br/><br/>
      <p><code>/repository/archetypes/</code><br/>
        Returns a JSON list of all archetypes.</p>
      <p><code>/repository/archetypes/&lt;name&gt;</code><br/>
        Returns metadata for a archetype named &lt;name&gt;.</p>
      <p><code>/repository/archetypes/&lt;name&gt;/&lt;version&gt;</code><br/>
        Returns metadata for a archetype named &lt;name&gt; with version &lt;version&gt;.</p>
      <p><code>/repository/archetypes/&lt;name&gt;/&lt;version&gt;/griffon-&lt;name&gt;-&lt;version&gt;.zip</code><br/>
        Downloads the archetype named &lt;name&gt; with version &lt;version&gt;.</p>
      <p><code>/repository/archetypes/&lt;name&gt;/&lt;version&gt;/griffon-&lt;name&gt;-&lt;version&gt;.zip.md5</code><br/>
        Downloads the archetype's checksum whose name matches &lt;name&gt; and version matches &lt;version&gt;.</p>
    </div>
  </div>
</section>

</body>
</html>