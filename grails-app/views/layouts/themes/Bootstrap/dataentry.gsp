<!DOCTYPE html>
<html>
    <theme:head/>
    <theme:body>
        <theme:layoutTemplate name="header"/>
        
        <div class="container">
            <div class="content">
                <div class="page-header">
                    <theme:layoutTitle/>
                    <theme:layoutZone name="secondary-navigation"/>
                </div>
                <div class="row">
                    <div class="span12">
                        <theme:layoutZone name="body"/>
                    </div>
                </div>
            </div>
            <theme:layoutTemplate name="footer"/>
        </div>
    </theme:body>
</html>
