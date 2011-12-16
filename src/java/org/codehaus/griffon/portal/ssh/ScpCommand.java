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

package org.codehaus.griffon.portal.ssh;

import org.apache.sshd.server.SshFile;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author Andres Almiray
 */
public class ScpCommand extends org.apache.sshd.server.command.ScpCommand {
    private static final String ARTIFACT_REGEX = "griffon-([\\w][\\w\\.-]*)-([0-9][\\w\\.\\-]*)\\.zip";
    private static final Pattern ARTIFACT_PATTERN = Pattern.compile("^" + ARTIFACT_REGEX + "$");
    private static final Pattern FILE_PATTERN = Pattern.compile("^/tmp/" + ARTIFACT_REGEX + "$");

    public ScpCommand(String[] args) {
        super(args);
    }

    protected void writeFile(String header, SshFile file) throws IOException {
        if (!FILE_PATTERN.matcher(file.getAbsolutePath()).matches()) {
            throw new IOException("Not allowed: " + file.getAbsolutePath());
        }

        super.writeFile(header, file);

        Matcher matcher = ARTIFACT_PATTERN.matcher(file.getName());
        matcher.find();
        String artifactName = matcher.group(1);
        String artifactVersion = matcher.group(2);
        log.debug(artifactName + ":" + artifactVersion);

        // TODO find out the type of artifact
        // if plugin or archetype -> make release
        // else ERROR!
    }
}
