<!DOCTYPE html>
<html>
    <theme:head/>
    <theme:body>
        <theme:layoutTemplate name="header"/>
        <header class="masthead">
            <div class="inner">
                <div class="container">
                    <theme:layoutZone name="banner"/>
                </div>
            </div>  
        </header>
        <div class="container">
            <div class="content">
                <div class="row">
                    <div class="span11">
                        <theme:layoutZone name="body"/>
                    </div>
                </div>
                <div class="row">
                    <div class="span4">
                        <theme:layoutZone name="panel1"/>
                    </div>
                    <div class="span3">
                        <theme:layoutZone name="panel2"/>
                    </div>
                    <div class="span4">
                        <theme:layoutZone name="panel3"/>
                    </div>
                </div>
            </div>
            <theme:layoutTemplate name="footer"/>
        </div>
    </theme:body>
</html>