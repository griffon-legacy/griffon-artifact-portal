<!doctype html>
<html>
<head>
    <theme:layout name="plain"/>
    <theme:title>Grails Runtime Exception</theme:title>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'errors.css')}" type="text/css">
</head>

<body>

<theme:zone name="body">
    <tmpl:/shared/pageheader><h2>Oh noes!</h2></tmpl:/shared/pageheader>
    <g:renderException exception="${exception}"/>
</theme:zone>
</body>
</html>
