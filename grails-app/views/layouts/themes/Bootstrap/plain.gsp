<!DOCTYPE html>
<html>
<theme:head>
    <r:require module="application"/>
</theme:head>
<theme:body>
    <theme:layoutTemplate name="header"/>
    <div class="container">
        <div class="content">
            <div class="row">
                <div class="span11">
                    <theme:layoutZone name="body"/>
                </div>
            </div>
        </div>
        <theme:layoutTemplate name="footer"/>
    </div>
</theme:body>
</html>
