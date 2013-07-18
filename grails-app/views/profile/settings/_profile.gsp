<div class="row">
    <div class="span8">
        <g:render template="/shared/errors_and_messages"
                  model="[bean: command]"/>
        <ui:form controller="profile" mapping="settings_update_profile"
                 params="[username: profileInstance.user.username]">
            <g:hiddenField name="profileId" value="${profileInstance.id}"/>
            <g:hiddenField name="userId" value="${profileInstance.user.id}"/>

            <ui:field bean="${command}" name="gravatarEmail">
                <ui:fieldLabel><label for="gravatarEmail"
                                      class="control-label">Avatar</label></ui:fieldLabel>
                <ui:fieldInput>
                    <g:textField name="gravatarEmail" required="true"
                                 class="input-xlarge"
                                 value="${command.gravatarEmail}"/>
                </ui:fieldInput>
                <ui:fieldErrors></ui:fieldErrors>
                <ui:fieldHint>
                    <p class="help-block">Write down the email associated with your gravatar account.<br/>
                        We won't spam you, honest!<br/>
                        Change your avatar at <a
                        href="http://gravatar.com">gravatar.com</a>.</p>
                </ui:fieldHint>
            </ui:field>

            <g:render template="/shared/form_field"
                      model="[
                          bean: command,
                          field: 'website',
                          hint: 'Have a homepage or a blog? Put the address here.'
                      ]"/>

            <g:render template="/shared/form_field"
                      model="[
                          bean: command,
                          field: 'twitter',
                          hint: 'Have a twitter account? Let others know what you\'re up to.'
                      ]"/>

            <ui:field bean="${command}" name="bio">
                <ui:fieldInput>
                    <g:textArea name="bio" cols="40" rows="3" maxlength="1000"
                                class="input-xxlarge"
                                value="${command.bio}"/>
                </ui:fieldInput>
                <ui:fieldErrors></ui:fieldErrors>
                <ui:fieldHint>
                    <p class="help-block">About yourself in fewer than <span
                        class='char-counter'>1000</span> chars.</p>
                </ui:fieldHint>
            </ui:field>

            <ui:actions>
                <ui:button mode="inverse">Save</ui:button>
            </ui:actions>
        </ui:form>
    </div>

    <div class="span3">
        <h3>Profile</h3>

        <p>This information appears on your public profile, search results, and beyond.</p>
        <hr/>

        <h3>Tips</h3>

        <p>Filling in your profile information will help people find and contact you about your contributions.</p>

        <p><span
            class="label label-warning">Notice</span> You're gravatar email will be set to your account's email if you leave it blank.
        </p>
    </div>
</div>
<%--
<div class="span-two-thirds">
    <g:render template="/shared/errors_and_messages" model="[bean: command]"/>

    <g:form controller="profile" mapping="settings_update_profile"
            params="[username: profileInstance.user.username, tab: tab]">
        <g:hiddenField name="profileId" value="${profileInstance.id}"/>
        <g:hiddenField name="userId" value="${profileInstance.user.id}"/>

        <div class="clearfix">
            <label for="gravatarEmail">Avatar</label>

            <div class="input">
                <input id="gravatarEmail" name="gravatarEmail" size="30"
                       type="text"
                       value="${command.gravatarEmail}"/>

                <p class="help-block">
                    Write down the email associated with your gravatar account.<br/>
                    We won't spam you, honest!<br/>
                    Change your avatar at <a
                    href="http://gravatar.com">gravatar.com</a>.
                </p>
            </div>
        </div>

        <div class="clearfix">
            <label for="website">Web</label>

            <div class="input">
                <input id="website" name="website" rel="${command.website}"
                       size="30" type="text"
                       value="${command.website}"/>

                <p class="help-block">
                    Have a homepage or a blog? Put the address here.
                </p>
            </div>
        </div>

        <div class="clearfix">
            <label for="twitter">Twitter</label>

            <div class="input">
                <input id="twitter" name="twitter" size="30" type="text"
                       value="${command.twitter}"/>

                <p class="help-block">Have a twitter account? Let others know what you're up to.</p>
            </div>

        </div>


        <div class="clearfix">
            <label for="bio">Bio</label>

            <div class="input">
                <textarea class="xlarge" cols="40" id="bio" maxlength="1000"
                          name="bio"
                          rows="3">${command.bio}</textarea>

                <p class="help-block">

                    About yourself in fewer than <span
                    class='char-counter'>1000</span> chars.
                </p>
            </div>
        </div>

        <div class="actions">
            <input class="btn btn-inverse" type="submit" value="Save"/>
        </div>

    </g:form>
</div>

<div class="span-one-third">
    <h3>Profile</h3>

    <p>This information appears on your public profile, search results, and beyond.</p>
    <hr/>

    <h3>Tips</h3>

    <p>Filling in your profile information will help people find and contact you about your contributions.</p>

    <p><span
        class="label warning">Notice</span> You're gravatar email will be set to your account's email if you leave it blank.
    </p>

</div>
--%>