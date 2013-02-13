// ###################################################################
//
//    EDIT THE FOLLOWING SETTINGS ACCORDING TO YOUR NEEDS
//
// ###################################################################

packages.store.dir = '/tmp/griffon-artifact-portal/packages'
releases.store.dir = '/tmp/griffon-artifact-portal/releases'

markdown.tables = true

twitter {
    enabled                    = false // enables Twitter status updates
    disableTwitter4jController = true
    'default' {
        debugEnabled           = false
        OAuthConsumerKey       = '****'
        OAuthConsumerSecret    = '****'
        OAuthAccessToken       = '****'
        OAuthAccessTokenSecret = '****'
    }
}

grails.mail.default.from = 'theaviary@griffon.codehaus.org'

grails {
    mail {
        host = 'smtp.gmail.com'
        port = 465
        username = 'changeme@gmail.com'
        password = 'changeme'
        props = [
                'mail.smtp.auth': 'true',
                'mail.smtp.socketFactory.port': '465',
                'mail.smtp.socketFactory.class': 'javax.net.ssl.SSLSocketFactory',
                'mail.smtp.socketFactory.fallback': 'false'
        ]
    }
}

sshd.port = 2222
sshd.keystorage = 'artifact-portal.ser'

allow.snapshots = true

geoip.data.resource= "/WEB-INF/GeoLiteCity.dat"
geoip.data.cache = 0

// ###################################################################
//
//    !!! DO NOT EDIT BEYOND THIS POINT !!!
//
// ###################################################################

grails.rateable.rater.evaluator = { session.user }

grails.commentable.poster.evaluator = { session.user }

avatarPlugin {
    defaultGravatarUrl = '/images/griffon-icon-128x128.grayscale.png'
    gravatarRating = 'G'
}

import com.octo.captcha.component.image.backgroundgenerator.GradientBackgroundGenerator
import com.octo.captcha.component.image.color.SingleColorGenerator
import com.octo.captcha.component.image.fontgenerator.RandomFontGenerator
import com.octo.captcha.component.image.textpaster.NonLinearTextPaster
import com.octo.captcha.component.image.wordtoimage.ComposedWordToImage
import com.octo.captcha.component.word.wordgenerator.RandomWordGenerator
import com.octo.captcha.engine.GenericCaptchaEngine
import com.octo.captcha.image.gimpy.GimpyFactory
import com.octo.captcha.service.multitype.GenericManageableCaptchaService
import java.awt.Color
import java.awt.Font

jcaptchas {
    image = new GenericManageableCaptchaService(
            new GenericCaptchaEngine(
                    new GimpyFactory(
                            new RandomWordGenerator(
                                    "abcdefghijkmnprstuvwxyz1234567890"
                            ),
                            new ComposedWordToImage(
                                    new RandomFontGenerator(
                                            20, // min font size
                                            30, // max font size
                                            [new Font("Monospace", 0, 10)] as Font[]
                                    ),
                                    new GradientBackgroundGenerator(
                                            140, // width
                                            35, // height
                                            new SingleColorGenerator(new Color(128, 0, 0)),
                                            new SingleColorGenerator(new Color(20, 20, 20))
                                    ),
                                    new NonLinearTextPaster(
                                            6, // minimal length of text
                                            6, // maximal length of text
                                            new Color(255, 255, 255)
                                    )
                            )
                    )
            ),
            180, // minGuarantedStorageDelayInSeconds
            180000 // maxCaptchaStoreSize
    )
}

grails.config.locations = ["classpath:${appName}-config.properties",
                           "classpath:${appName}-config.groovy"]

grails.plugins.twitterbootstrap.fixtaglib = true

grails.resources.modules = {
    portal {
        resource url: '/js/portal.js'
    }
    'jquery-form' {
        resource url: '/js/jquery.form.js', disposition: 'head'
    }
    upload {
        dependsOn 'jquery-form'
        resource url: '/js/upload.js', disposition: 'head'
    }
    twitter {
        resource url: '/js/twitter-widget.js', disposition: 'head'
    }
}

grails.project.groupId = appName // change this to alter the default package name and Maven publishing destination
grails.mime.file.extensions = true // enables the parsing of file extensions from URLs into the request format
grails.mime.use.accept.header = false
grails.mime.types = [html: ['text/html', 'application/xhtml+xml'],
        xml: ['text/xml', 'application/xml'],
        text: 'text/plain',
        js: 'text/javascript',
        rss: 'application/rss+xml',
        atom: 'application/atom+xml',
        css: 'text/css',
        csv: 'text/csv',
        all: '*/*',
        json: ['application/json', 'text/json'],
        form: 'application/x-www-form-urlencoded',
        multipartForm: 'multipart/form-data'
]

// URL Mapping Cache Max Size, defaults to 5000
//grails.urlmapping.cache.maxsize = 1000

// What URL patterns should be processed by the resources plugin
grails.resources.adhoc.patterns = ['/images/*', '/css/*', '/js/*', '/plugins/*']

// The default codec used to encode data with ${}
grails.views.default.codec = "none" // none, html, base64
grails.views.gsp.encoding = "UTF-8"
grails.converters.encoding = "UTF-8"
// enable Sitemesh preprocessing of GSP pages
grails.views.gsp.sitemesh.preprocess = true
// scaffolding templates configuration
grails.scaffolding.templates.domainSuffix = 'Instance'

// Set to false to use the new Grails 1.2 JSONBuilder in the render method
grails.json.legacy.builder = false
// enabled native2ascii conversion of i18n properties files
grails.enable.native2ascii = true
// packages to include in Spring bean scanning
grails.spring.bean.packages = []
// whether to disable processing of multi part requests
grails.web.disable.multipart = false

// request parameters to mask when logging exceptions
grails.exceptionresolver.params.exclude = ['password']

// enable query caching by default
grails.hibernate.cache.queries = true

// set per-environment serverURL stem for creating absolute links
environments {
    development {
        grails.logging.jul.usebridge = true
    }
    production {
        grails.logging.jul.usebridge = false
        // TODO: grails.serverURL = "http://www.changeme.com"
    }
}

// log4j configuration
log4j = {

    environments {
        development {
            appenders {
                console name: 'stdout', layout: pattern(conversionPattern: '%d [%t] %-5p %c - %m%n')
                file name: 'file', file: '/tmp/griffon.log'
            }

            root {
                info 'stdout', 'file'
            }
        }
    }

    error 'org.codehaus.groovy.grails.web.servlet',  //  controllers
            'org.codehaus.groovy.grails.web.pages', //  GSP
            'org.codehaus.groovy.grails.web.sitemesh', //  layouts
            'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
            'org.codehaus.groovy.grails.web.mapping', // URL mapping
            'org.codehaus.groovy.grails.commons', // core / classloading
            'org.codehaus.groovy.grails.plugins', // plugins
            'org.codehaus.groovy.grails.orm.hibernate', // hibernate integration
            'org.springframework',
            'org.hibernate',
            'net.sf.ehcache.hibernate'
    debug 'org.codehaus.griffon'
}
