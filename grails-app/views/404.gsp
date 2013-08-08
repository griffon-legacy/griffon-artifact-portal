<!doctype html>
<html>
<head>
    <theme:layout name="categorized"/>
    <theme:title>Page Not Found</theme:title>
</head>

<body>

<theme:zone name="body">
    <tmpl:/shared/pageheader><h2>404 - Page Not Found</h2></tmpl:/shared/pageheader>
    <p>
        <i class="icon-warning-sign"></i> We did our best to fetch the page you were looking for but couldn't, oops!
        <br/><br/><strong>${request.forwardURI}</strong><br/><br/>does not exist at all.
    </p>
</theme:zone>
</body>
</html>
