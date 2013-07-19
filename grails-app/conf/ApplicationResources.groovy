modules = {
    application {
        dependsOn 'jquery'
        resource url: 'js/application.js'
        resource url: '/js/portal.js'
        resource url: '/js/jquery.form.js', disposition: 'head'
        resource url: '/js/upload.js', disposition: 'head'
        resource url: '/js/twitter-widget.js', disposition: 'head'

        resource url: '/css/griffon.css'
        resource url: '/css/griffon_bootstrap.css'
    }
}