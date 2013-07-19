<%@ page import="griffon.portal.values.ArtifactTab" %>
<!doctype html>
<html>
<head>
    <theme:layout name="plain"/>
    <theme:title><g:message code="griffon.portal.Plugin.show.label"
                            args="[pluginName]"/></theme:title>
</head>

<body>

<theme:zone name="body">
    <tmpl:/shared/pageheader><h2>${pluginName}</h2>${pluginInstance.title}</tmpl:/shared/pageheader>

    <div class="row">
        <div class="span7">
            <g:render template="plugin_header_properties"
                      model="[pluginInstance: pluginInstance]"/>
            <g:render template="/artifact/common/artifact_header_properties"
                      model="[artifactInstance: pluginInstance, downloads: downloads]"/>
        </div>

        <div class="span4">
            <g:render template="/artifact/common/authored_by"
                      bean="${authorList}" model="[authorList: authorList]"/>
        </div>
    </div>

    <ui:tabs>
        <g:each in="${ArtifactTab.values()}" var="artifactTab">
            <ui:tab title="${artifactTab.capitalizedName}" active="${'Description' == artifactTab.capitalizedName}">
                <g:render template="/artifact/tabs/$artifactTab"
                          model="[artifactInstance: pluginInstance]"/>
                </ui:tab>
        </g:each>
    </ui:tabs>

</theme:zone>
</body>
</html>