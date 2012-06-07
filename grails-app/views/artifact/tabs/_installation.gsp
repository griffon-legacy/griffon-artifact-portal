<%@ page import="griffon.portal.Plugin" %>
<div class="row">
  <%
    String latestVersion = artifactInstance.latestRelease?.artifactVersion ?: '1.0'
  %>
  <div class="span16">
    <p>There are several ways to install a release of ${artifactInstance.name} using the <code>install-${artifactInstance.type}</code> target of the griffon command line tool.
    </p>

    <div class="row">
      <div class="span7">
        <h2>Name and Version</h2>

        <p>You can specify the name of the ${artifactInstance.type} alone. When you do this the command line tool will do its best to find the best match for your current settings: current Griffon version, UI toolkit, platform and JDK. If no suitable match is found you'll have to select a particular version yourself.
        </p>
      </div>

      <div class="span9">
        <br clear="all"/>
        <code>$ griffon install-${artifactInstance.type} ${artifactInstance.name}</code>
        <br clear="all"/><br clear="all"/>
        <code>$ griffon install-${artifactInstance.type} ${artifactInstance.name} ${latestVersion}</code>
      </div>
    </div>

    <div class="row">
      <div class="span7">
        <h2>URL</h2>

        <p>Alternatively you can specify an URL that contains the resource you want to install. For example, using this same portal you can point the <code>install-${artifactInstance.type}</code> command to either of the following URLs
        </p>
      </div>

      <div class="span9">
        <br clear="all"/>
        <code>$ griffon install-${artifactInstance.type} ${grailsApplication.config.serverURL}/api/${artifactInstance.type}s/${artifactInstance.name}/${latestVersion}/download</code>
        <br clear="all"/><br clear="all"/>
        <code>$ griffon install-${artifactInstance.type} ${grailsApplication.config.serverURL}/repository/${artifactInstance.type}s/${artifactInstance.name}/${latestVersion}/griffon-${artifactInstance.name}-${latestVersion}.zip</code>
      </div>
    </div>

    <div class="row">
      <div class="span7">
        <h2>Zip File</h2>

        <p>As a last resort you can specify the location of the zip file if it's available in your filesystem, like so.
        </p>
      </div>

      <div class="span9">
        <br clear="all"/>
        <code>$ griffon install-${artifactInstance.type} /path/to/griffon-${artifactInstance.name}-${latestVersion}.zip</code>
      </div>
    </div>

    <g:if test="${artifactInstance instanceof Plugin}">
        <g:if test="${artifactInstance.framework}">
            <div class="row">
                <div class="span7">
                    <h2>Framework</h2>

                    <p>This plugin can be installed at the framework level. Either call the <code>install-${artifactInstance.type}</code> command outside of a Griffon project or specify a command flag <code>--framework=true</code> as shown.
                    </p>
                </div>

                <div class="span9">
                    <br clear="all"/>
                    <code>$ griffon install-${artifactInstance.type} ${artifactInstance.name}-${latestVersion} --framework=true</code>
                </div>
            </div>
        </g:if>
    </g:if>
  </div>
</div>
