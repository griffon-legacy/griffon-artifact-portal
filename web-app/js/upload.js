$(document).ready(function () {
    var options = {
        target:'#upload-message',
        beforeSubmit:validateUpload,
        success:processUploadResponse,
        type:'post',
        dataType:'json',
        clearForm:true,
        resetForm:true

    };

    $('#uploadForm').submit(function () {
        var fileValue = $('#upload-file').val();
        $('#fileName').val(fileValue);
        $(this).ajaxSubmit(options);
        return false;
    });
});

function validateUpload(formData, jqForm, options) {
    return !isEmpty($('#upload-file').val());
}

function processUploadResponse(response, statusText, xhr, $form) {
    $('#upload-message').html(response.message);
    $('#upload-message').show();
    if (response.success) {
        $('#upload-submit').hide();
        $('#upload-file').hide();
        $('#upload-cancel').toggleClass('danger success', true);
    }
}

function handleMembershipResponse(response) {
    if (response.code == 'ERROR') {
        $('#membership-message').html('<p>An error occurred processing your membership. Please try again.</p>');
        $('#membership-message').show();
    } else if (response.code == 'OK') {
        $('#membership-message').hide();
        $('#membership-submit').hide();
        $('#reason').hide();
        $('#membership-cancel').toggleClass('danger success', true);
        $('#membership-apply').toggleClass('primary info', true);
        $('#membership-apply').attr('disabled', true);
        $('#membership-apply').val("${message(code: 'griffon.portal.button.membership.pending.label', default: 'Applied for Membership')}");
    }
}