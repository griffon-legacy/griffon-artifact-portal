<div class="row">
    <div class="span8">
        <g:render template="/shared/errors_and_messages"
                  model="[bean: command]"/>
        <ui:form controller="profile" mapping="settings_update_notifications"
                 params="[username: profileInstance.user.username]">
            <g:hiddenField name="profileId" value="${profileInstance.id}"/>
            <g:hiddenField name="userId" value="${profileInstance.user.id}"/>

            <ui:field bean="${command}" name="watchlist">
                <ui:fieldLabel><label for="watchlist"
                                      class="control-label">Watchlist</label></ui:fieldLabel>
                <ui:fieldInput>
                    <g:checkBox name="watchlist"
                                value="${profileInstance.notifications.watchlist}"/> Enable all items in my watchlist.
                </ui:fieldInput>
                <ui:fieldErrors></ui:fieldErrors>
                <ui:fieldHint>
                    <p class="help-block">If left unchecked you won't receive messages whenever any artifacts in your watchlist are updated.</p>
                </ui:fieldHint>
            </ui:field>

            <ui:field bean="${command}" name="content">
                <ui:fieldLabel><label for="content"
                                      class="control-label">Content Updates</label></ui:fieldLabel>
                <ui:fieldInput>
                    <g:checkBox name="content"
                                value="${profileInstance.notifications.content}"/>  Notify me when my content is updated.
                </ui:fieldInput>
                <ui:fieldErrors></ui:fieldErrors>
                <ui:fieldHint>
                    <p class="help-block">If checked you'll receive a notification when someone updates the content of an artifact you authored.</p>
                </ui:fieldHint>
            </ui:field>

            <ui:field bean="${command}" name="comments">
                <ui:fieldLabel><label for="comments"
                                      class="control-label">Comments</label></ui:fieldLabel>
                <ui:fieldInput>
                    <g:checkBox name="comments"
                                value="${profileInstance.notifications.comments}"/> Notify me when a comment is posted.
                </ui:fieldInput>
                <ui:fieldErrors></ui:fieldErrors>
                <ui:fieldHint>
                    <p class="help-block">If checked you'll receive a notification when someone posts a comment on an artifact you authored.</p>
                </ui:fieldHint>
            </ui:field>

            <ui:actions>
                <ui:button mode="inverse">Save</ui:button>
            </ui:actions>
        </ui:form>
    </div>

    <div class="span3">
        <h3>Notifications</h3>

        <p>This information controls the type of notifications this portal will send to your e-mail.</p>
        <hr/>

        <h3>Tips</h3>

        <p><span
            class="label label-important">Important</span> The e-mail you entered on your account settings will be used as the primary contact e-mail for all notifications.
        </p>
    </div>
</div>
