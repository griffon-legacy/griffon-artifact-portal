/*
 * Copyright 2011 the original author or authors.
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

package griffon.portal

import grails.util.GrailsNameUtils

/**
 * @author Andres Almiray
 */
class Artifact {
    String name
    String title
    String description
    String license

    Date dateCreated
    Date lastUpdated

    static hasMany = [authors: Author]

    static constraints = {
        name(nullable: false, blank: false)
        title(nullable: false, blank: false)
        description(nullable: false, blank: false)
        license(nullable: false, blank: false)
    }

    static mapping = {
        tablePerHierarchy false
    }

    void setName(String name) {
        this.name = name.toLowerCase()
    }

    String toString() {
        [
                id: id,
                type: GrailsNameUtils.getShortName(getClass()).toLowerCase(),
                name: name,
                title: title,
                license: license,
                authors: authors*.toString()
        ]
    }
}
