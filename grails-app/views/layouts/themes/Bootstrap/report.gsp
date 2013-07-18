<!DOCTYPE html>
<html>
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
                <div class="row">
                    <div class="span11">
                        <theme:layoutZone name="pagination"/>
                    </div>
                </div>
            </div>
            <theme:layoutTemplate name="footer"/>
        </div>
    </theme:body>
</html>
