<ui:field bean="${bean}" name="${field}">
    <ui:fieldInput>
        <g:if test="${password}">
            <g:passwordField name="${field}" required="true"
                         class="input-xlarge" value="${bean[field]}"/>
        </g:if>
        <g:else>
            <g:textField name="${field}" required="true"
                         class="input-xlarge" value="${bean[field]}"/>
        </g:else>
    </ui:fieldInput>
    <ui:fieldErrors></ui:fieldErrors>
</ui:field>