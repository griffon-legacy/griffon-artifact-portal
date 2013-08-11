import groovy.json.JsonSlurper
import groovy.transform.Canonical
import groovy.xml.MarkupBuilder

import java.util.regex.Matcher
import java.util.regex.Pattern
import java.util.zip.ZipEntry
import java.util.zip.ZipFile

/**
 * @author Andres Almiray
 * @since 1.4.0
 */
class PomGenerator {
    private final Map<String, String> MAVEN_SCOPES = [
        runtime: 'compile',
        compile: 'provided',
        test: 'test'
    ]

    private Map artifactInfo
    private String targetDirPath
    private final Map<String, List<PluginDependenciesParser.Dependency>> pluginDependencies = [
        runtime: [],
        compile: [],
        build: [],
        test: []
    ]

    PomGenerator(Map artifactInfo, File rootFile, String targetDirPath) {
        this.artifactInfo = artifactInfo
        this.targetDirPath = targetDirPath

        artifactInfo.pluginDependencies.each { dep ->
            File depZip = new File("${rootFile}/${dep.name}/${dep.version}/griffon-${dep.name}-${dep.version}.zip")
            if (!depZip.exists()) return
            ZipFile zipFile = new ZipFile(depZip)
            ZipEntry dependenciesEntry = zipFile.getEntry('plugin-dependencies.groovy')

            PluginDependenciesParser.traversePluginDependencies(zipFile.getInputStream(dependenciesEntry).text).each { k, deps ->
                pluginDependencies[k] += deps
            }
        }
    }

    private static String pomBuilder(Closure cls) {
        StringWriter sw = new StringWriter()
        MarkupBuilder builder = new MarkupBuilder(sw)
        cls.delegate = builder
        cls.resolveStrategy = Closure.DELEGATE_FIRST
        builder.project(xmlns: 'http://maven.apache.org/POM/4.0.0',
            'xmlns:xsi': 'http://www.w3.org/2001/XMLSchema-instance',
            'xsi:schemaLocation': 'http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd') {
            modelVersion('4.0.0')
            cls()
        }
        return '<?xml version="1.0"?>\n' + sw.toString()
    }

    void generatePluginPom(String scp, Collection<PluginDependenciesParser.Dependency> deps) {
        def pom = pomBuilder {
            parent {
                groupId(artifactInfo.group)
                artifactId("griffon-${artifactInfo.name}-parent")
                version(artifactInfo.version)
            }
            artifactId("griffon-${artifactInfo.name}-${scp}")
            version(artifactInfo.version)
            packaging('jar')
            name("${artifactInfo.title} [${scp.toUpperCase()}]")
            description("${artifactInfo.title} [${scp.toUpperCase()}]")

            dependencies {
                if (scp == 'runtime') {
                    dependency {
                        groupId('org.codehaus.griffon')
                        artifactId('griffon-rt')
                        version(artifactInfo.griffonVersion)
                    }
                } else if (scp == 'compile' && artifactInfo.runtime) {
                    dependency {
                        groupId(artifactInfo.group)
                        artifactId("griffon-${artifactInfo.name}-runtime")
                        version(artifactInfo.version)
                        scope(scp)
                    }
                } else {
                    if (artifactInfo.commpile) {
                        dependency {
                            groupId(artifactInfo.group)
                            artifactId("griffon-${artifactInfo.name}-compile")
                            version(artifactInfo.version)
                            scope(scp)
                        }
                    } else if (artifactInfo.runtime) {
                        dependency {
                            groupId(artifactInfo.group)
                            artifactId("griffon-${artifactInfo.name}-runtime")
                            version(artifactInfo.version)
                            scope(scp)
                        }
                    }
                }
                if (scp == 'runtime') {
                    pluginDependencies[scp].each { PluginDependenciesParser.Dependency dep ->
                        dependency {
                            groupId(dep.groupId)
                            artifactId(dep.artifactId)
                            version(dep.version)
                            if (dep.classifier) classifier(dep.classifier)
                            scope(MAVEN_SCOPES[scp])
                        }
                    }
                    pluginDependencies['compile'].each { PluginDependenciesParser.Dependency dep ->
                        dependency {
                            groupId(dep.groupId)
                            artifactId(dep.artifactId)
                            version(dep.version)
                            if (dep.classifier) classifier(dep.classifier)
                            scope(MAVEN_SCOPES[scp])
                        }
                    }
                } else if (scp == 'compile') {
                    pluginDependencies['build'].each { PluginDependenciesParser.Dependency dep ->
                        dependency {
                            groupId(dep.groupId)
                            artifactId(dep.artifactId)
                            version(dep.version)
                            if (dep.classifier) classifier(dep.classifier)
                            scope(MAVEN_SCOPES[scp])
                        }
                    }
                } else {
                    pluginDependencies[scp].each { PluginDependenciesParser.Dependency dep ->
                        dependency {
                            groupId(dep.groupId)
                            artifactId(dep.artifactId)
                            version(dep.version)
                            if (dep.classifier) classifier(dep.classifier)
                            scope(MAVEN_SCOPES[scp])
                        }
                    }
                }
                deps.each { PluginDependenciesParser.Dependency dep ->
                    dependency {
                        groupId(dep.groupId)
                        artifactId(dep.artifactId)
                        version(dep.version)
                        if (dep.classifier) classifier(dep.classifier)
                        scope(MAVEN_SCOPES[scp])
                    }
                }
            }
        }

        File parentDir = new File("${targetDirPath}/griffon-${artifactInfo.name}-${scp}/${artifactInfo.version}")
        parentDir.mkdirs()
        new File("${parentDir}/griffon-${artifactInfo.name}-${scp}-${artifactInfo.version}.pom").text = pom
    }

    void generatePluginParentPom(List mods) {
        def pom = pomBuilder {
            groupId(artifactInfo.group)
            artifactId("griffon-${artifactInfo.name}-parent")
            version(artifactInfo.version)
            packaging('pom')
            name("griffon-${artifactInfo.name} aggregator")
            description("griffon-${artifactInfo.name} aggregator")

            if (artifactInfo.source) {
                scm {
                    url(artifactInfo.source)
                }
            }

            licenses {
                license {
                    name(artifactInfo.license)
                }
            }

            developers {
                for (author in artifactInfo.authors) {
                    developer {
                        id(author.id)
                        name(author.name)
                        email(author.email)
                    }
                }
            }

            modules {
                mods.each { mod ->
                    module("griffon-${artifactInfo.name}-${mod}")
                }
            }
        }

        File parentDir = new File("${targetDirPath}/griffon-${artifactInfo.name}-parent/${artifactInfo.version}")
        parentDir.mkdirs()
        new File("${parentDir}/griffon-${artifactInfo.name}-parent-${artifactInfo.version}.pom").text = pom
    }

    void generatePluginBom(List mods) {
        def pom = pomBuilder {
            groupId(artifactInfo.group)
            artifactId("griffon-${artifactInfo.name}-bom")
            version(artifactInfo.version)
            packaging('pom')
            name("griffon-${artifactInfo.name} BOM")
            description("griffon-${artifactInfo.name} BOM")

            if (artifactInfo.source) {
                scm {
                    url(artifactInfo.source)
                }
            }

            licenses {
                license {
                    name(artifactInfo.license)
                }
            }

            developers {
                for (author in artifactInfo.authors) {
                    developer {
                        id(author.id)
                        name(author.name)
                        email(author.email)
                    }
                }
            }

            dependencyManagement {
                dependencies {
                    mods.each { mod ->
                        dependency {
                            groupId(artifactInfo.group)
                            artifactId("griffon-${artifactInfo.name}-${mod}")
                            version('${project.version}')
                        }
                    }
                }
            }
        }

        File parentDir = new File("${targetDirPath}/griffon-${artifactInfo.name}-bom/${artifactInfo.version}")
        parentDir.mkdirs()
        new File("${parentDir}/griffon-${artifactInfo.name}-bom-${artifactInfo.version}.pom").text = pom
    }
}

class PluginDependenciesParser {
    private static final Pattern DEPENDENCY_PATTERN = Pattern.compile("([a-zA-Z0-9\\-/\\._+=]*?):([a-zA-Z0-9\\-/\\._+=]+?):([a-zA-Z0-9\\-/\\.,\\]\\[\\(\\)_+=]+)(:([a-zA-Z0-9\\-/\\.,\\]\\[\\(\\)_+=]+))?")

    final Map<String, List<Dependency>> dependencies = [
        runtime: [],
        compile: [],
        build: [],
        test: []
    ]

    private PluginDependenciesParser() {
        this.dependencies = dependencies
    }

    @Canonical
    static class Dependency {
        String groupId
        String artifactId
        String version
        String classifier
    }

    static Map<String, List<Dependency>> traversePluginDependencies(String dependenciesDescriptor) {
        GroovyClassLoader gcl = new GroovyClassLoader(PluginDependenciesParser.class.classLoader)
        Script dependenciesScript = gcl.parseClass(dependenciesDescriptor).newInstance()

        ConfigSlurper configReader = new ConfigSlurper()
        def pluginConfig = configReader.parse(dependenciesScript)
        def pluginDependencyConfig = pluginConfig.griffon.project.dependency.resolution
        PluginDependenciesParser pluginDependenciesParser = new PluginDependenciesParser()
        if (pluginDependencyConfig instanceof Closure) {
            pluginDependencyConfig.delegate = pluginDependenciesParser
            pluginDependencyConfig.resolveStrategy = Closure.DELEGATE_FIRST
            pluginDependencyConfig()
        }
        return pluginDependenciesParser.dependencies
    }

    void dependencies(Closure cls) {
        cls.delegate = this
        cls.resolveStrategy = Closure.DELEGATE_FIRST
        cls()
    }

    Object methodMissing(String name, Object args) {
        if (args == null) {
            return null
        }

        List<Object> argsList = Arrays.asList((Object[]) args)
        if (argsList.size() == 0) {
            return null
        }

        if (isOnlyStrings(argsList)) {
            addDependencyStrings(name, argsList, null, null)
        } else if (isProperties(argsList)) {
            addDependencyMaps(name, argsList, null)
        } else if (isStringsAndConfigurer(argsList)) {
            addDependencyStrings(name, argsList.subList(0, argsList.size() - 1), null, (Closure<?>) argsList.get(argsList.size() - 1));
        } else if (isPropertiesAndConfigurer(argsList)) {
            addDependencyMaps(name, argsList.subList(0, argsList.size() - 1), (Closure<?>) argsList.get(argsList.size() - 1));
        } else if (isStringsAndProperties(argsList)) {
            addDependencyStrings(name, argsList.subList(0, argsList.size() - 1), (Map<Object, Object>) argsList.get(argsList.size() - 1), null);
        }

        return null;
    }

    private static class ExportHolder {
        boolean export = true;
    }

    private void addDependencyStrings(String scope, List<Object> dependencies, Map<Object, Object> overrides, Closure<?> configurer) {
        for (Object dependency : dependencies) {
            Map<Object, Object> dependencyProperties = extractDependencyProperties(scope, dependency.toString());
            if (dependencyProperties == null) {
                continue;
            }

            if (overrides != null) {
                for (Map.Entry<Object, Object> override : overrides.entrySet()) {
                    dependencyProperties.put(override.getKey().toString(), override.getValue().toString());
                }
            }

            addDependency(scope, dependencyProperties, configurer);
        }
    }

    private void addDependencyMaps(String scope, List<Object> dependencies, Closure<?> configurer) {
        for (Object dependency : dependencies) {
            addDependency(scope, (Map<Object, Object>) dependency, configurer);
        }
    }

    private String nullSafeToString(Object value) {
        if (value == null) {
            return null;
        }
        return value.toString();
    }

    private void addDependency(String scope, Map<Object, Object> dependency, Closure<?> configurer) {
        if (configurer != null) {
            ExportHolder eh = new ExportHolder()
            configurer.delegate = eh
            configurer.resolveStrategy = Closure.DELEGATE_FIRST
            configurer()
            if (!eh.export) return;
        }

        List list = dependencies.get(scope, [])
        list << new Dependency(
            groupId: nullSafeToString(dependency.get("group")),
            artifactId: nullSafeToString(dependency.get("name")),
            version: nullSafeToString(dependency.get("version")),
            classifier: nullSafeToString(dependency.get("classifier"))
        )
    }

    private Map<Object, Object> extractDependencyProperties(String scope, String dependency) {
        Matcher matcher = DEPENDENCY_PATTERN.matcher(dependency);
        if (matcher.matches()) {
            Map<Object, Object> properties = new HashMap<Object, Object>(3);
            properties.put("name", matcher.group(2));
            properties.put("group", matcher.group(1));
            properties.put("version", matcher.group(3));
            String classifier = matcher.group(4);
            if (!isBlank(classifier) && classifier.startsWith(":")) {
                classifier = classifier.substring(1);
            }
            properties.put("classifier", classifier);
            return properties;
        }
        return null;
    }

    private boolean isOnlyStrings(List<Object> args) {
        for (Object arg : args) {
            if (!(arg instanceof CharSequence)) {
                return false;
            }
        }
        return true;
    }

    private boolean isStringsAndConfigurer(List<Object> args) {
        if (args.size() == 1) {
            return false;
        }
        return isOnlyStrings(args.subList(0, args.size() - 1)) && args.get(args.size() - 1) instanceof Closure;
    }

    private boolean isStringsAndProperties(List<Object> args) {
        if (args.size() == 1) {
            return false;
        }
        return isOnlyStrings(args.subList(0, args.size() - 1)) && args.get(args.size() - 1) instanceof Map;
    }

    private boolean isProperties(List<Object> args) {
        for (Object arg : args) {
            if (!(arg instanceof Map)) {
                return false;
            }
        }
        return true;
    }

    private boolean isPropertiesAndConfigurer(List<Object> args) {
        if (args.size() == 1) {
            return false;
        }
        return isProperties(args.subList(0, args.size() - 1)) && args.get(args.size() - 1) instanceof Closure;
    }

    private boolean isBlank(String str) {
        return str == null || str.trim().length() == 0;
    }
}

def persistsZipEntry = { ZipFile zipFile, ZipEntry zipEntry, String fileName ->
    File file = new File(fileName)
    file.parentFile.mkdirs()
    OutputStream os = new FileOutputStream(file)
    os.bytes = zipFile.getInputStream(zipEntry).bytes
    os.close()
}

def processPlugin = { File rootFile, File destinadionDir, File pluginFile ->
    ZipFile zipFile = new ZipFile(pluginFile)
    ZipEntry pluginDescEntry = zipFile.entries().find { it.name == 'plugin.json' }

    def json = null
    zipFile.getInputStream(pluginDescEntry).withReader { reader ->
        json = new JsonSlurper().parse(reader)
    }

    ZipEntry dependenciesEntry = zipFile.getEntry('dependencies.groovy')
    ZipEntry runtimeJarEntry = zipFile.getEntry("dist/griffon-${json.name}-runtime-${json.version}.jar")
    ZipEntry compileJarEntry = zipFile.getEntry("dist/griffon-${json.name}-compile-${json.version}.jar")
    ZipEntry testJarEntry = zipFile.getEntry("dist/griffon-${json.name}-test-${json.version}.jar")
    ZipEntry sourceJarEntry = zipFile.getEntry("docs/griffon-${json.name}-runtime-${json.version}-sources.jar")
    ZipEntry javadocJarEntry = zipFile.getEntry("docs/griffon-${json.name}-runtime-${json.version}-javadoc.jar")

    Map info = [
        name: json.name,
        version: json.version,
        authors: json.authors,
        title: json.title,
        source: json.source,
        license: json.license,
        pluginDependencies: json.dependencies,
        griffonVersion: (json.griffonVersion =~ /(.*) >.*/)[0][1],
        group: 'org.codehaus.griffon.plugins',
        runtime: runtimeJarEntry != null,
        compile: compileJarEntry != null,
        test: testJarEntry != null
    ]

    Map<String, List<PluginDependenciesParser.Dependency>> dependencies = [
        runtime: [],
        compile: [],
        build: [],
        test: []
    ]

    if (dependenciesEntry != null) {
        dependencies = PluginDependenciesParser.traversePluginDependencies(zipFile.getInputStream(dependenciesEntry).text)
    }

    String group = info.group.replace('.', '/')
    List modules = []
    PomGenerator pomGenerator = new PomGenerator(info, rootFile, new File("${destinadionDir}/${info.group.replace('.', '/')}").absolutePath)
    if (runtimeJarEntry != null) {
        pomGenerator.generatePluginPom('runtime', dependencies.runtime + dependencies.compile)
        String filename = "${destinadionDir}/${group}/griffon-${info.name}-runtime/${info.version}/griffon-${info.name}-runtime-${info.version}.jar"
        persistsZipEntry(zipFile, sourceJarEntry, filename)
        modules << 'runtime'
    }
    if (compileJarEntry != null) {
        pomGenerator.generatePluginPom('compile', dependencies.build)
        String filename = "${destinadionDir}/${group}/griffon-${info.name}-compile/${info.version}/griffon-${info.name}-compile-${info.version}.jar"
        persistsZipEntry(zipFile, sourceJarEntry, filename)
        modules << 'compile'
    }
    if (testJarEntry != null) {
        pomGenerator.generatePluginPom('test', dependencies.test)
        String filename = "${destinadionDir}/${group}/griffon-${info.name}-test/${info.version}/griffon-${info.name}-test-${info.version}.jar"
        persistsZipEntry(zipFile, sourceJarEntry, filename)
        modules << 'test'
    }
    if (modules) {
        pomGenerator.generatePluginParentPom(modules)
        pomGenerator.generatePluginBom(modules)
    }

    if (sourceJarEntry != null) {
        String filename = "${destinadionDir}/${group}/griffon-${info.name}-runtime/${info.version}/griffon-${info.name}-runtime-${info.version}-sources.jar"
        persistsZipEntry(zipFile, sourceJarEntry, filename)
    }
    if (javadocJarEntry != null) {
        String filename = "${destinadionDir}/${group}/griffon-${info.name}-runtime/${info.version}/griffon-${info.name}-runtime-${info.version}-javadoc.jar"
        persistsZipEntry(zipFile, javadocJarEntry, filename)
    }

    info
}

def makeMavenMetadata = { Map info, String filePath, List<String> versionList, String scope, String updated ->
    StringWriter sw = new StringWriter()
    MarkupBuilder builder = new MarkupBuilder(sw)
    builder.metadata {
        groupId(info.group)
        artifactId("griffon-${info.name}-${scope}")
        version(versionList[0])
        versioning {
            release(versionList.last())
            versions {
                versionList.each { v -> version(v) }
            }
            lastUpdated(updated)
        }
    }
    new File("${filePath}/maven-metadata.xml").text = '<?xml version="1.0"?>\n' + sw.toString()
}

def processMetadata = { File destinationDir, Map info, List versions, String lastUpdated ->
    ['bom', 'parent', 'runtime', 'compile', 'test'].each { scope ->
        String artifactName = "griffon-${info.name}-${scope}"
        File artifactDir = new File("${destinationDir}/${artifactName}")
        if (!artifactDir.exists()) return
        makeMavenMetadata(info, artifactDir.absolutePath, versions, scope, lastUpdated)
    }
}

root = new File('/tmp/griffon-artifact-portal/packages/plugin')
destination = new File('/tmp/griffon-artifact-portal/maven')
for (pluginDir in root.listFiles()) {
    Map info = null
    for (versionDir in pluginDir.listFiles()) {
        versionDir.eachFileMatch({ it.endsWith('.zip') }) {
            info = processPlugin(root, destination, it)
        }
    }
    List versions = pluginDir.list()
    String lastUpdated = new Date().format('yyyyMMddHHmmss')
    for (versionDir in pluginDir.listFiles()) {
        versionDir.eachFileMatch({ it.endsWith('.zip') }) {
            processMetadata(new File("${destination}/${info.group.replace('.', '/')}"), info, versions, lastUpdated)
        }
    }
}