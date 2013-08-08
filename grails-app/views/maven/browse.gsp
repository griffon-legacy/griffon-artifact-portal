<%@ page import="java.text.DecimalFormat" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="maven"/>
    <r:require module="bootstrap"/>
    <title>Browse</title>
</head>
<%
    final int kilo = 1024
    final int mega = kilo * kilo
    def nf = new DecimalFormat('###.#')
    def prettySize = { size ->
        if (size < kilo) return size.toString()
        if (size < mega) return nf.format(size / kilo) + 'K'
        return nf.format(size / mega) + 'M'
    }
%>
<body>
<h2>Index of ${(params.artifactPath ? params.artifactPath : '/')}</h2>
<table>
    <tr>
        <th></th>
        <th>&nbsp;</th>
        <th>Name</th>
        <th>&nbsp;&nbsp;&nbsp;&nbsp;</th>
        <th>Last modified</th>
        <th>&nbsp;&nbsp;&nbsp;&nbsp;</th>
        <th>Size</th>
    </tr>
    <g:if test="${params.artifactPath}">
        <tr>
            <td><i class="icon-arrow-up"></i></td>
            <td></td>
            <td><g:link uri="${parentPath}">Parent Directory</g:link></td>
            <td></td>
            <td></td>
            <td></td>
            <td align="right">-</td>
        </tr>
    </g:if>
    <g:each in="${files}" var="file">
        <tr>
            <td>
                <g:if test="${file.name.endsWith('.jar')}">
                    <i class="icon-briefcase"></i>
                </g:if>
                <g:elseif test="${file.directory}">
                    <i class="icon-folder-open"></i>
                </g:elseif>
                <g:else>
                    <i class="icon-file"></i>
                </g:else>
            </td>
            <td></td>
            <td><g:link
                uri="/repository/maven${params.artifactPath}/${file.name}">${file.name}</g:link></td>
            <td></td>
            <td align="right">${new Date(file.lastModified()).format('dd-MMM-yyyy HH:mm')}</td>
            <td></td>
            <td align="right">${prettySize(file.size())}</td>
        </tr>
    </g:each>
</table>
</body>
</html>