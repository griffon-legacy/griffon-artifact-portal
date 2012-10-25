/*
 * Copyright 2011-2012 the original author or authors.
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
class Usage {
    String ipAddress
    String griffonVersion
    String javaVersion
    String javaVendor
    String javaVmVersion
    String osName
    String osArch
    String osVersion
    String commandName
    String scriptName
    String username

    Date dateCreated

    static constraints = {
        griffonVersion(nullable: false, blank: false)
        javaVersion(nullable: false, blank: false)
        javaVendor(nullable: false, blank: false)
        javaVmVersion(nullable: false, blank: false)
        ipAddress(nullable: false, blank: false)
        osName(nullable: false, blank: false)
        osArch(nullable: false, blank: false)
        osVersion(nullable: false, blank: false)
        commandName(nullable: false, blank: false)
        scriptName(nullable: false, blank: false)
        username(nullable: false, blank: false)
    }
}
