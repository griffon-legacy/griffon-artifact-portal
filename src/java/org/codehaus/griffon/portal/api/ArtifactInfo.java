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

package org.codehaus.griffon.portal.api;

import java.util.zip.ZipFile;

/**
 * @author Andres Almiray
 */
public final class ArtifactInfo {
    private final ZipFile zipFile;
    private final String artifactName;
    private final String artifactVersion;
    private final String username;

    public ArtifactInfo(ZipFile zipFile, String artifactName, String artifactVersion, String username) {
        this.zipFile = zipFile;
        this.artifactVersion = artifactVersion;
        this.artifactName = artifactName;
        this.username = username;
    }

    public ZipFile getZipFile() {
        return zipFile;
    }

    public String getArtifactName() {
        return artifactName;
    }

    public String getArtifactVersion() {
        return artifactVersion;
    }

    public String getUsername() {
        return username;
    }
}
