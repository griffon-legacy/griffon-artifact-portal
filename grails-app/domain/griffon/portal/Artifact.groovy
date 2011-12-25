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

package griffon.portal

import grails.util.GrailsNameUtils
import org.grails.rateable.Rateable
import org.grails.taggable.Taggable

/**
 * @author Andres Almiray
 */
class Artifact implements Rateable, Taggable {
    String name
    String title
    String description
    String license

    String source
    String docs

    Date dateCreated
    Date lastUpdated

    static hasMany = [authors: Author]

    static transients = ['type', 'capitalizedName', 'capitalizedType']

    static constraints = {
        name(nullable: false, blank: false)
        title(nullable: false, blank: false)
        description(nullable: false, blank: false)
        license(nullable: false, blank: false)
        source(nullable: true, blank: false, url: true)
        docs(nullable: true, blank: false)
    }

    static mapping = {
        tablePerHierarchy false
        description type: 'text'
    }

    void setName(String name) {
        this.name = name.toLowerCase()
    }

    String getType() {
        GrailsNameUtils.getShortName(getClass()).toLowerCase()
    }

    String getCapitalizedName() {
        GrailsNameUtils.getNaturalName(name)
    }

    String getCapitalizedType() {
        GrailsNameUtils.getNaturalName(type)
    }

    String toString() {
        [
                id: id,
                type: type,
                name: name,
                title: title,
                license: license,
                authors: authors*.toString(),
                source: source,
                docs: docs
        ]
    }
}
