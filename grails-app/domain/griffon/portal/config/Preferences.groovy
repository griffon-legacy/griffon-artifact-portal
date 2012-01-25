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

package griffon.portal.config

/**
 * @author Andres Almiray
 */
class Preferences {
    String key
    String value
    Date dateCreated
    Date lastUpdated

    String toString() {
        "$key = $value"
    }

    static constraints = {
        key(nullable: false, blank: false, unique: true)
        value(nullable: true, blank: true)
    }
}
