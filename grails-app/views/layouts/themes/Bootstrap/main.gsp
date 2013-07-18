<!DOCTYPE html>
<html>
    <%-- add a body to this head tag to add any meta / common resources --%>
    <theme:head/>
    <theme:body>
        <theme:layoutTemplate name="header"/>
        
        <div class="container">
            <div class="content">
                <div class="page-header">
                    <theme:layoutTitle/>
                </div>
                <div class="row">
                    <div class="span11">
                        <theme:layoutZone name="secondary-navigation"/>
                    </div>
                </div>
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
