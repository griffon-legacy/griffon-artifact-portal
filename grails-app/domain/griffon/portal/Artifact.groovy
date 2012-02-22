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
import griffon.portal.auth.User
import org.grails.comments.Commentable
import org.grails.rateable.Rateable
import org.grails.taggable.Taggable

/**
 * @author Andres Almiray
 */
class Artifact implements Rateable, Taggable, Commentable {
    String name
    String title
    String description
    String license

    String source
    String documentation

    Date dateCreated
    Date lastUpdated

    static hasMany = [authors: Author, releases: Release]

    static transients = ['type', 'capitalizedName', 'capitalizedType']

    static constraints = {
        name(nullable: false, blank: false)
        title(nullable: false, blank: false)
        description(nullable: false, blank: false)
        license(nullable: false, blank: false)
        source(nullable: true, blank: true, url: true)
        documentation(nullable: true, blank: true, url: true)
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
        // GrailsNameUtils.getNaturalName(name)
        name
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
                docs: documentation
        ]
    }

    static List<User> findAllAuthorsAsUsers(Artifact artifact) {
        List<User> users = []
        artifact.authors.each { Author author ->
            User user = User.findByEmail(author.email)
            if (user) users << user
        }
        users
    }
    
    Release getLatestRelease() {
        return getReleases()?.sort {Release a, Release b -> compareVersions(a.artifactVersion, b.artifactVersion)}?.last()
    }

    private compareVersions = { String a, String b ->
        def aParts = a.split(/[\.-]/)
        boolean aSnapshot = false
        aParts = aParts.inject([]) {c, i ->
            if(i.toLowerCase() == 'snapshot') aSnapshot = true
            else if (i.isNumber()) c << i.toInteger()
            return c
        }

        def bParts = b.split(/[\.-]/)
        boolean bSnapshot = false
        bParts = bParts.inject([]) {c, i ->
            if(i.toLowerCase() == 'snapshot') bSnapshot = true
            else if (i.isNumber()) c << i.toInteger()
            return c
        }
        def size = Math.min(aParts.size(), bParts.size())
        for(int i = 0; i < size; i++) {
            def diff = bParts[i] - aParts[i]
            if(diff == 0  && i == size - 1 && aSnapshot && !bSnapshot)
                return 1
            else if(diff == 0 && i == size - 1 && !aSnapshot && bSnapshot)
                return -1
            else if(diff != 0)
                return diff
        }
        return 0
    }
}
