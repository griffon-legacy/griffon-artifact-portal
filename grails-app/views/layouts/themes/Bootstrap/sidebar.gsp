<!DOCTYPE html>
<html>
<%-- add a body to this head tag to add any meta / common resources --%>
<theme:head>
    <r:require module="application"/>
</theme:head>
<theme:body>
    <theme:layoutTemplate name="header"/>

    <div class="container">
        <div class="content">
            <div class="row">
                <div class="span11">
                    <theme:layoutZone name="pageheader"/>
                </div>
            </div>

            <div class="row">
                <div class="span8">
                    <theme:layoutZone name="body"/>
                </div>

                <div class="span3">
                    <theme:layoutZone name="sidebar"/>
                </div>
            </div>
        </div>
        <theme:layoutTemplate name="footer"/>
    </div>
</theme:body>
</html>
