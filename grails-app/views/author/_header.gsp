<tmpl:/shared/pageheader>
    <table>
        <tr>
            <td class="thumbnail">
                <a href="#">
                    <ui:avatar user="${authorInstance.email}" size="100"
                               class="img-rounded"/>
                </a>
            </td>
            <td>&nbsp;</td>
            <td>
                <address>
                    <h2><g:fieldValue bean="${authorInstance}"
                                      field="name"/></h2>
                    <g:fieldValue bean="${authorInstance}"
                                  field="email"/><br/>
                </address>
            </td>
        </tr>
    </table>
</tmpl:/shared/pageheader>