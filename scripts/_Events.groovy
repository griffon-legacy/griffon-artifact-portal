eventCompileEnd = {
    if(System.getProperty('twitter.enabled')) {
        ant.copy(todir: classesDirPath) {
            fileset(dir: "${basedir}/src/resources", includes: '*.xml, *.properties')
        }
    }
}
