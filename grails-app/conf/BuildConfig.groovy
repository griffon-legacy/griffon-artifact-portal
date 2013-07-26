grails.servlet.version = "2.5" // Change depending on target container compliance (2.5 or 3.0)
grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir = "target/test-reports"
grails.project.target.level = 1.6
grails.project.source.level = 1.6
//grails.project.war.file = "target/${appName}-${appVersion}.war"

grails.project.dependency.resolution = {
    // inherit Grails' default dependencies
    inherits("global") {
        // uncomment to disable ehcache
        // excludes 'ehcache'
    }
    log "error" // log level of Ivy resolver, either 'error', 'warn', 'info', 'debug' or 'verbose'
    checksums true // Whether to verify checksums on resolve

    repositories {
        inherits true // Whether to inherit repository definitions from plugins
        grailsPlugins()
        grailsHome()
        grailsCentral()
        grailsRepo("http://svn.codehaus.org/grails-plugins", "grailsCore2")
        mavenCentral()
    }
    dependencies {
        compile 'org.apache.mina:mina-core:2.0.4',
                'org.apache.sshd:sshd-core:0.6.0',
                'org.apache.sshd:sshd-pam:0.6.0',
                'org.twitter4j:twitter4j-core:3.0.3'
        compile('org.codehaus.griffon:griffon-rt:1.3.0',
                'org.codehaus.griffon:griffon-cli:1.3.0') {
            transitive = false
        }
        runtime 'postgresql:postgresql:9.0-801.jdbc4'
        test "org.spockframework:spock-grails-support:0.7-groovy-2.0"
    }

    plugins {
        test    ":code-coverage:1.2.6"
        test(":spock:0.7") {
            exclude "spock-grails-support"
        }
        compile ":hibernate:$grailsVersion",
                ":jquery:1.8.3",
                ":resources:1.2",
                ":commentable:0.8.1",
                ":email-confirmation:1.0.5",
                ":executor:0.3",
                ":jcaptcha:1.2.1",
                ":mail:1.0",
                ":markdown:1.0.0.RC1",
                ":quartz:1.0-RC9",
                ":rateable:0.7.1",
                ":taggable:1.0.1",
                ":webxml:1.4.1",
                ":yui:2.8.2.1",
                ":yui-minify-resources:0.1.5",
                ":zipped-resources:1.0",
                ":cached-resources:1.0",
                ":cache-headers:1.1.5",
                ":google-visualization:0.6.1",
                ":geoip:0.2",
                ":bootstrap-theme:1.0.RC3",
                ":platform-ui:1.0.RC5-SNAPSHOT"

        build ":tomcat:$grailsVersion"
    }
}

grails.plugin.location.'platform-ui' = 'inline_plugins/grails-platform-ui'