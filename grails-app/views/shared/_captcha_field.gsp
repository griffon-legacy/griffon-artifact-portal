<ui:field bean="${bean}" name="captcha"
          label="Please enter the text as shown below">
    <ui:fieldInput>
        <g:textField name="captcha" required="true" class="input-xlarge"
                     value=""/>
        <br/><br/>
        <jcaptcha:jpeg name="image"/>
    </ui:fieldInput>
    <ui:fieldErrors> </ui:fieldErrors>
</ui:field>