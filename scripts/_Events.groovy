import grails.util.Environment

eventCompileEnd = {
    if(Environment.current == Environment.PRODUCTION || System.getProperty('test.setup')) {
        ant.copy(todir: classesDirPath) {
            fileset(dir: "${basedir}/src/resources", includes: '*.xml, *.properties, *.groovy')
        }
    }
}
