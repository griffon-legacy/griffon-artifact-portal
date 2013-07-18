<tmpl:/shared/pageheader>
    <div class="media">
        <a href="#" class="pull-left">
            <ui:avatar user="${authorInstance.email}"
                       size="90"
                       class="media-object img-rounded"/>
        </a>

        <div class="media-body">
            <address>
                <h3><g:fieldValue bean="${authorInstance}"
                                  field="name"/></h3>
                <a mailto="">${authorInstance.email}</a>
            </address>
        </div>
    </div>
</tmpl:/shared/pageheader>