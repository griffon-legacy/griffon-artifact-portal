<div class="row">
    <div class="span8">
        <g:render template="/shared/errors_and_messages"
                  model="[bean: command]"/>
        <ui:form controller="profile" mapping="settings_update_account"
                 params="[username: profileInstance.user.username]">
            <g:hiddenField name="profileId" value="${profileInstance.id}"/>
            <g:hiddenField name="userId" value="${profileInstance.user.id}"/>

            <g:render template="/shared/form_field"
                      model="[
                          bean: command,
                          field: 'fullName',
                          hint: 'Enter your real name, so people you know can recognize you.'
                      ]"/>
            <g:render template="/shared/form_field"
                      model="[
                          bean: command,
                          field: 'email',
                          hint: 'Enter your primary email.'
                      ]"/>

            <ui:actions>
                <ui:button mode="inverse">Save</ui:button>
            </ui:actions>
        </ui:form>
    </div>

    <div class="span3">
        <h3>Account</h3>

        <p>This information appears on your public profile, search results, and beyond.</p>
        <hr/>

        <h3>Tips</h3>

        <p><span
            class="label label-important">Important</span> The email you enter here will be used to determine the authorship of all your contributions; make sure you match this value with all artifacts you submit.
        </p>
    </div>
</div>