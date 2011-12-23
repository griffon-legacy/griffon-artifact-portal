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

import org.apache.sshd.common.util.DirectoryScanner;
import org.apache.sshd.server.Environment;
import org.apache.sshd.server.SshFile;
import org.codehaus.griffon.portal.api.ArtifactInfo;
import org.codehaus.griffon.portal.api.ArtifactProcessor;

import java.io.IOException;
import java.io.OutputStream;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.ZipFile;

/**
 * @author Andres Almiray
 */
public class ScpCommand extends org.apache.sshd.server.command.ScpCommand {
    private static final String ARTIFACT_REGEX = "griffon-([\\w][\\w\\.-]*)-([0-9][\\w\\.\\-]*)\\.zip";
    private static final Pattern ARTIFACT_PATTERN = Pattern.compile("^" + ARTIFACT_REGEX + "$");
    private static final Pattern FILE_PATTERN = Pattern.compile("^/tmp/" + ARTIFACT_REGEX + "$");

    private final ArtifactProcessor artifactProcessor;
    private String username;

    public ScpCommand(String[] args, ArtifactProcessor artifactProcessor) {
        super(args);
        this.artifactProcessor = artifactProcessor;
    }

    @Override
    public void start(Environment env) throws IOException {
        username = env.getEnv().get(Environment.ENV_USER);
        super.start(env);
    }

    protected void writeFile(String header, SshFile file) throws IOException {
        if (!FILE_PATTERN.matcher(file.getAbsolutePath()).matches()) {
            throw new IOException("Not allowed: " + file.getAbsolutePath());
        }

        doWriteFile(header, file);

        Matcher matcher = ARTIFACT_PATTERN.matcher(file.getName());
        matcher.find();
        String artifactName = matcher.group(1);
        String artifactVersion = matcher.group(2);
        artifactProcessor.process(new ArtifactInfo(new ZipFile(file.getAbsolutePath()), artifactName, artifactVersion, username));

        ack();
        readAck(false);
    }

    @Override
    public void run() {
        int exitValue = OK;
        String exitMessage = null;

        try {
            if (optT) {
                ack();
                for (; ; ) {
                    String line;
                    boolean isDir = false;
                    int c = readAck(true);
                    switch (c) {
                        case -1:
                            return;
                        case 'D':
                            isDir = true;
                        case 'C':
                            line = ((char) c) + readLine();
                            break;
                        case 'E':
                            readLine();
                            return;
                        default:
                            //a real ack that has been acted upon already
                            continue;
                    }

                    if (optR && isDir) {
                        writeDir(line, root.getFile(path));
                    } else {
                        writeFile(line, root.getFile(path));
                    }
                }
            } else if (optF) {
                String pattern = path;
                int idx = pattern.indexOf('*');
                if (idx >= 0) {
                    String basedir = "";
                    int lastSep = pattern.substring(0, idx).lastIndexOf('/');
                    if (lastSep >= 0) {
                        basedir = pattern.substring(0, lastSep);
                        pattern = pattern.substring(lastSep + 1);
                    }
                    String[] included = new DirectoryScanner(basedir, pattern).scan();
                    for (String path : included) {
                        SshFile file = root.getFile(basedir + "/" + path);
                        if (file.isFile()) {
                            readFile(file);
                        } else if (file.isDirectory()) {
                            if (!optR) {
                                out.write(WARNING);
                                out.write((path + " not a regular file\n").getBytes());
                            } else {
                                readDir(file);
                            }
                        } else {
                            out.write(WARNING);
                            out.write((path + " unknown file type\n").getBytes());
                        }
                    }
                } else {
                    String basedir = "";
                    int lastSep = pattern.lastIndexOf('/');
                    if (lastSep >= 0) {
                        basedir = pattern.substring(0, lastSep);
                        pattern = pattern.substring(lastSep + 1);
                    }
                    SshFile file = root.getFile(basedir + "/" + pattern);
                    if (!file.doesExist()) {
                        throw new IOException(file + ": no such file or directory");
                    }
                    if (file.isFile()) {
                        readFile(file);
                    } else if (file.isDirectory()) {
                        if (!optR) {
                            throw new IOException(file + " not a regular file");
                        } else {
                            readDir(file);
                        }
                    } else {
                        throw new IOException(file + ": unknown file type");
                    }
                }
            } else {
                throw new IOException("Unsupported mode");
            }
        } catch (IOException e) {
            try {
                exitValue = ERROR;
                // copied the whole method just that we could decorate the error message *sigh*
                exitMessage = "ERROR: " + e.getMessage();
                out.write(exitValue);
                out.write(exitMessage.getBytes());
                out.write('\n');
                out.flush();
            } catch (IOException e2) {
                // Ignore
            }
            log.info("Error in scp command", e);
        } finally {
            if (callback != null) {
                callback.onExit(exitValue, exitMessage);
            }
        }
    }

    private void doWriteFile(String header, SshFile path) throws IOException {
        if (log.isDebugEnabled()) {
            log.debug("Writing file {}", path);
        }
        if (!header.startsWith("C")) {
            throw new IOException("Expected a C message but got '" + header + "'");
        }

        String perms = header.substring(1, 5);
        long length = Long.parseLong(header.substring(6, header.indexOf(' ', 6)));
        String name = header.substring(header.indexOf(' ', 6) + 1);

        SshFile file;
        if (path.doesExist() && path.isDirectory()) {
            file = root.getFile(path, name);
        } else if (path.doesExist() && path.isFile()) {
            file = path;
        } else if (!path.doesExist() && path.getParentFile().doesExist() && path.getParentFile().isDirectory()) {
            file = path;
        } else {
            throw new IOException("Can not write to " + path);
        }
        if (file.doesExist() && file.isDirectory()) {
            throw new IOException("File is a directory: " + file);
        } else if (file.doesExist() && !file.isWritable()) {
            throw new IOException("Can not write to file: " + file);
        }
        OutputStream os = file.createOutputStream(0);
        try {
            ack();

            byte[] buffer = new byte[8192];
            while (length > 0) {
                int len = (int) Math.min(length, buffer.length);
                len = in.read(buffer, 0, len);
                if (len <= 0) {
                    throw new IOException("End of stream reached");
                }
                os.write(buffer, 0, len);
                length -= len;
            }
        } finally {
            os.close();
        }
    }
}
