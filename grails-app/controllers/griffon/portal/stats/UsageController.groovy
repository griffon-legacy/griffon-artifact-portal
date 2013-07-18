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

import grails.converters.JSON

/**
 * @author Andres Almiray
 */
class UsageController {
    static navigationScope = 'hidden'
    static defaultAction = 'usage'

    def usage() {
        String usageStatsVersion = request.getHeader('x-griffon-usage-stats')
        if (!usageStatsVersion) {
            response.status = 401
            render([output: 'Unauthorized'] as JSON)
            return
        }

        new Usage(
            ipAddress: request.remoteAddr,
            griffonVersion: params.gv,
            javaVersion: params.jv,
            javaVendor: params.ve,
            javaVmVersion: params.vm,
            osName: params.on,
            osArch: params.oa,
            osVersion: params.ov,
            commandName: params.cn,
            scriptName: params.sn,
            username: params.un
        ).save()

        render([output: 'OK'] as JSON)
    }
}
