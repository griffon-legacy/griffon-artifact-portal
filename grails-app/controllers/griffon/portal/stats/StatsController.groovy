/*
 * Copyright 2011-2013 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package griffon.portal.stats

/**
 * @author Andres Almiray
 */
class StatsController {
    def index() {
        List javaVersions = Download.createCriteria().list() {
            projections {
                groupProperty('javaVersion')
                count('javaVersion')
            }
        }

        Map versions = [:]
        javaVersions.each { entry ->
            if (!entry || !entry[0] || entry[1] == null) return
            String versionNumber = entry[0][0..4]
            def count = versions.get(versionNumber, 0)
            versions[versionNumber] = count + entry[1]
        }
        javaVersions = versions.collect { [it.key, it.value] }

        List griffonVersions = Download.createCriteria().list() {
            projections {
                groupProperty('griffonVersion')
                count('griffonVersion')
            }
        }

        versions.clear()
        griffonVersions.each { entry ->
            if (!entry || !entry[0] || entry[1] == null) return
            String versionNumber = entry[0][0..4]
            def count = versions.get(versionNumber, 0)
            versions[versionNumber] = count + entry[1]
        }
        griffonVersions = versions.collect { [it.key, it.value] }

        List osNames = Download.createCriteria().list() {
            projections {
                groupProperty('osName')
                count('osName')
            }
        }

        versions.clear()
        osNames.each { entry ->
            if (!entry || !entry[0] || entry[1] == null) return
            String osName = entry[0].contains('Windows') ? 'Windows' : entry[0]
            def count = versions.get(osName, 0)
            versions[osName] = count + entry[1]
        }
        osNames = versions.collect { [it.key, it.value] }

        [
            downloadTotalsByCountry: DownloadTotalByCountry.list(sort: 'total', order: 'asc').collect([]) {
                [it.country, it.total]
            },
            javaVersions: javaVersions,
            griffonVersions: griffonVersions,
            osNames: osNames
        ]
    }
}
