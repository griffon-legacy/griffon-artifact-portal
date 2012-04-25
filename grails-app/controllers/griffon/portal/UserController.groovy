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

import com.grailsrocks.emailconfirmation.EmailConfirmationService
import grails.converters.JSON
import grails.plugin.mail.MailService
import griffon.portal.auth.Membership
import griffon.portal.auth.User
import griffon.portal.util.MD5
import groovy.text.SimpleTemplateEngine
import org.apache.commons.lang.RandomStringUtils
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.grails.plugin.jcaptcha.JcaptchaService



class SignupCommand {
    boolean filled
    String username
    String fullName
    String email
    String password
    String password2
    String captcha

    static constraints = {
        username(nullable: false, blank: false)
        fullName(nullable: false, blank: true)
        email(nullable: false, blank: false, email: true)
        password(nullable: false, blank: false)
        password2(nullable: false, blank: false)
        captcha(nullable: false, blank: false)
    }
}

class LoginCommand {
    boolean filled
    String username
    String passwd

    static constraints = {
        username(nullable: false, blank: false)
        passwd(nullable: false, blank: false)
    }
}

class ForgotPasswordCommand {
    boolean filled
    String username
    String captcha

    static constraints = {
        username(nullable: false, blank: false)
        captcha(nullable: false, blank: false)
    }
}

class ForgotUsernameCommand {
    boolean filled
    String email
    String captcha

    static constraints = {
        email(nullable: false, email: true)
        captcha(nullable: false, blank: false)
    }
}