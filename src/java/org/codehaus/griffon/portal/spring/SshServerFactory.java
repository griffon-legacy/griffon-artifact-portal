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

package org.codehaus.griffon.portal.spring;

import groovy.util.ConfigObject;
import org.apache.sshd.SshServer;
import org.apache.sshd.server.keyprovider.SimpleGeneratorHostKeyProvider;
import org.codehaus.griffon.portal.api.ArtifactProcessor;
import org.codehaus.griffon.portal.ssh.PasswordAuthenticator;
import org.codehaus.griffon.portal.ssh.ScpCommandFactory;
import org.codehaus.groovy.grails.commons.GrailsApplication;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.config.AbstractFactoryBean;

import static griffon.util.ConfigUtils.getConfigValueAsInt;
import static griffon.util.ConfigUtils.getConfigValueAsString;

/**
 * @author Andres Almiray
 */
public class SshServerFactory extends AbstractFactoryBean<SshServer> implements InitializingBean {
    private GrailsApplication grailsApplication;
    private PasswordAuthenticator passwordAuthenticator;
    private ArtifactProcessor artifactProcessor;

    public void setGrailsApplication(GrailsApplication grailsApplication) {
        this.grailsApplication = grailsApplication;
    }

    public void setPasswordAuthenticator(PasswordAuthenticator passwordAuthenticator) {
        this.passwordAuthenticator = passwordAuthenticator;
    }

    public void setArtifactProcessor(ArtifactProcessor artifactProcessor) {
        this.artifactProcessor = artifactProcessor;
    }

    @Override
    public Class<?> getObjectType() {
        return SshServer.class;
    }

    @Override
    protected SshServer createInstance() throws Exception {
        return SshServer.setUpDefaultServer();
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        super.afterPropertiesSet();
        ConfigObject config = grailsApplication.getConfig();
        SshServer sshd = getObject();
        sshd.setPort(getConfigValueAsInt(config, "sshd.port", 2222));
        sshd.setKeyPairProvider(new SimpleGeneratorHostKeyProvider(getConfigValueAsString(config, "sshd.keystorage", "plugin-portal.ser")));
        sshd.setCommandFactory(new ScpCommandFactory(artifactProcessor));
        sshd.setPasswordAuthenticator(passwordAuthenticator);
        sshd.start();
    }

    @Override
    public void destroy() throws Exception {
        getObject().stop(true);
        super.destroy();
    }
}
