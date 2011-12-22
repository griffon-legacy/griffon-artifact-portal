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
        mavenCentral()
    }
    dependencies {
        compile 'org.apache.mina:mina-core:2.0.4',
                'org.apache.sshd:sshd-core:0.6.0',
                'org.apache.sshd:sshd-pam:0.6.0',
                'org.pegdown:pegdown:1.1.0'
        compile('org.codehaus.griffon:griffon-rt:0.9.4') { transitive = false }
    }

    plugins {
        compile ":hibernate:$grailsVersion"
        compile ":jquery:1.7"
        compile ":resources:1.1.3"

        build ":tomcat:$grailsVersion"
    }
}
