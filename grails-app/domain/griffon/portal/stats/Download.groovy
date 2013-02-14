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

import griffon.portal.Release

/**
 * @author Andres Almiray
 */
class Download {
    String username
    Release release
    String type
    Date dateCreated

    String userAgent
    String ipAddress
    String osName
    String osArch
    String osVersion
    String javaVersion
    String javaVmVersion
    String javaVmName
    String griffonVersion

    static constraints = {
        username(nullable: false, blank: false)
        release(nullable: false)
        userAgent(nullable: true, blank: true)
        ipAddress(nullable: true, blank: true)
        osName(nullable: true, blank: true)
        osArch(nullable: true, blank: true)
        osVersion(nullable: true, blank: true)
        javaVersion(nullable: true, blank: true)
        javaVmVersion(nullable: true, blank: true)
        javaVmName(nullable: true, blank: true)
        griffonVersion(nullable: true, blank: true)
    }
}
