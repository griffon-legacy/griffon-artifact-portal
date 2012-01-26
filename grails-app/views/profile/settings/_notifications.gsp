<div class="span-two-thirds">
  <g:render template="/shared/errors_and_messages" model="[bean: command]"/>

  <g:form controller="profile" mapping="settings_update_notifications"
          params="[username: profileInstance.user.username, tab: tab]">
    <g:hiddenField name="profileId" value="${profileInstance.id}"/>
    <g:hiddenField name="userId" value="${profileInstance.user.id}"/>

    <div class="clearfix">
      <label>Watchlist</label>

      <div class="input">
        <g:checkBox name="watchlist"
                    value="${profileInstance.notifications.watchlist}"/> Enable all items in your watchlist.

        <p class="help-block">
          If left unchecked you won't receive messages whenever any artifacts in your watchlist are updated.
        </p>
      </div>
    </div>


    <div class="clearfix">
      <label>Content Updates</label>

      <div class="input">
        <g:checkBox name="content"
                    value="${profileInstance.notifications.content}"/> Notify me when my content is updated.

        <p class="help-block">
          If checked you'll receive a notification when someone updates the content of an artifact you authored.
        </p>
      </div>
    </div>

    <div class="clearfix">
      <label>Comments</label>

      <div class="input">
        <g:checkBox name="comments"
                    value="${profileInstance.notifications.comments}"/> Notify me when a comment is posted.
        <p class="help-block">
          If checked you'll receive a notification when someone posts a comment on an artifact you authored.
        </p>
      </div>
    </div>

    <div class="actions">
      <input class="btn primary small" type="submit" value="Save"/>
    </div>

  </g:form>
</div>

<div class="span-one-third">
  <h3>Notifications</h3>

  <p>This information controls the type of notifications this portal will send to your e-mail.</p>
  <hr/>

  <h3>Tips</h3>

  <p><span class="label important">Important</span> The e-mail you entered on your account settings will be used as the primary contact e-mail for all notifications.</p>
  </p>

</div>
