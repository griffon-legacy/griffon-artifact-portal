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

/**
 * @author Andres Almiray
 */
class Release {
    String artifactVersion
    String griffonVersion
    String comment
    String checksum
    boolean releaseNotes
    Artifact artifact

    Date dateCreated
    Date lastUpdated

    static constraints = {
        artifactVersion(nullable: false, blank: false)
        griffonVersion(nullable: false, blank: false)
        comment(nullable: false, blank: false)
        checksum(nullable: false, blank: false)
        artifact(nullable: false)
    }

    String toString() {
        [
                id: id,
                artifactVersion: artifactVersion,
                griffonVersion: griffonVersion,
                comment: comment,
                checksum: checksum,
                date: dateCreated,
                artifact: artifact,
                releaseNotes: releaseNotes
        ]
    }
}
