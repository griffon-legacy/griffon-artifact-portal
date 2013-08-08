<%@ page import="griffon.portal.Plugin" %>
<%
    String latestVersion = artifactInstance.latestRelease?.artifactVersion ?: '1.0.0'
%>

<p>Follow these instructions to configure artifacts belonging to ${artifactInstance.name} with either Gradle or Maven.
</p>


<div class="row">
    <div class="span4">
        <h2>Gradle - Repository</h2>

        <p>Add a repository entry to the <code>repositories</code> section on your build file.</p>
    </div>

    <div class="span7">
        <pre class="prettyprint">
repositories {
    url '${grailsApplication.config.serverURL}/repository/maven/'
}</pre>
    </div>
</div>

<div class="row">
    <div class="span4">
        <h2>Gradle - Dependencies</h2>

        <p>Configure any of the following dependencies inside the <code>dependencies</code> section on your build file.</p>
    </div>

    <%
        String dependencies = ''
        if (artifactInstance.pomRuntime) dependencies += "    compile('${artifactInstance.groupId}:griffon-${artifactInstance.name}-runtime:${latestVersion}')\n"
        if (artifactInstance.pomCompile) dependencies += "    compile('${artifactInstance.groupId}:griffon-${artifactInstance.name}-compile:${latestVersion}')\n"
        if (artifactInstance.pomTest) dependencies += "    testCompile('${artifactInstance.groupId}:griffon-${artifactInstance.name}-test:${latestVersion}')\n"
        dependencies = dependencies[0..-2]
    %>

    <div class="span7">
        <pre class="prettyprint">
dependencies {
${dependencies}
}</pre>
    </div>
</div>

<div class="row">
    <div class="span4">
        <h2>Maven - Repository</h2>

        <p>Add a repository entry to the <code>repositories</code> section on your build file.</p>
    </div>

    <div class="span7">
        <pre class="prettyprint">
&lt;repositories&gt;
    &lt;repository&gt;
        &lt;id&gt;griffon.central&lt;/id&gt;
        &lt;url&gt;${grailsApplication.config.serverURL}/repository/maven/&lt;/url&gt;
        &lt;name&gt;Griffon Artifact Central Repository&lt;/name&gt;
        &lt;snapshots&gt;
            &lt;enabled&gt;false&lt;/enabled&gt;
        &lt;/snapshots&gt;
        &lt;releases&gt;
            &lt;enabled&gt;true&lt;/enabled&gt;
        &lt;/releases&gt;
    &lt;/repository&gt;
&lt;/repositories&gt;
        </pre>
    </div>
</div>

<div class="row">
    <div class="span4">
        <h2>Maven - Dependencies</h2>

        <p>Configure any of the following dependencies inside the <code>dependencies</code> section on your build file.</p>
    </div>

    <%
        dependencies = '<dependencies>'
        if (artifactInstance.pomRuntime) {
            dependencies += """
            |    <dependency>
            |        <groupId>${artifactInstance.groupId}</groupId>
            |        <artifactId>griffon-${artifactInstance.name}-runtime</artifactId>
            |        <version>${latestVersion}</version>
            |        <scope>compile</scope>
            |    </dependency>""".stripMargin('|')
        }

        if (artifactInstance.pomCompile) {
            dependencies += """
            |    <dependency>
            |        <groupId>${artifactInstance.groupId}</groupId>
            |        <artifactId>griffon-${artifactInstance.name}-compile</artifactId>
            |        <version>${latestVersion}</version>
            |        <scope>provided</scope>
            |    </dependency>""".stripMargin('|')
        }

        if (artifactInstance.pomTest) {
            dependencies += """
            |    <dependency>
            |        <groupId>${artifactInstance.groupId}</groupId>
            |        <artifactId>griffon-${artifactInstance.name}-runtime</artifactId>
            |        <version>${latestVersion}</version>
            |        <scope>test</scope>
            |    </dependency>""".stripMargin('|')
        }
        dependencies += '\n</dependencies>'
    %>

    <div class="span7">
        <pre class="prettyprint">
${dependencies.replace('<', '&lt;').replace('>', '&gt;')}
        </pre>
    </div>
</div>