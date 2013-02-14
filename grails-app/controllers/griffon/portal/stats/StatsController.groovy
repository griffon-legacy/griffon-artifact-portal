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

        List griffonVersions = Download.createCriteria().list() {
            projections {
                groupProperty('griffonVersion')
                count('griffonVersion')
            }
        }

        List osNames = Download.createCriteria().list() {
            projections {
                groupProperty('osName')
                count('osName')
            }
        }

        Map osVersions = [:]
        osNames.each { osentry ->
            osVersions[osentry[0]] = Download.createCriteria().list() {
                eq('osName', osentry[0])
                projections {
                    groupProperty('osVersion')
                    count('osVersion')
                }
            }
        }
        println osVersions

        [
            downloadTotalsByCountry: DownloadTotalByCountry.list(sort: 'total', order: 'asc').collect([]) {
                [it.country, it.total]
            },
            javaVersions: javaVersions,
            griffonVersions: griffonVersions,
            osNames: osNames,
            osVersions: osVersions
        ]
    }
}
