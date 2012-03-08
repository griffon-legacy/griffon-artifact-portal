Griffon Artifact Portal
-----------------------

This is the code for [http://artifacts.griffon-framework.org][1]. You can use
this application to setup a custom Remote Artifact repository that can serve
artifacts locally to your organization.

Requirements
------------

This application was developed using [Grails 2.0.1][2] and makes use of several
plugins. You'll need a persistent database (such as PostgreSQL or MySQL) for
running the portal in production mode.

Configuration
-------------

Open up `grails-app/conf/Config.groovy` and tweak the following configuration
settings according to your needs

### Storage Directory

The portal stores zip files in two different directories. These directories
should be durable and backed up regularly. Make sure to point the following
properties to more appropriate locations

	packages.store.dir = '/tmp/griffon-artifact-portal/packages'
	releases.store.dir = '/tmp/griffon-artifact-portal/releases'
	
### Twitter

The portal has the option to send announcements via Twitter whenever a release
is uploaded. For this to work you have to configure a Twitter account; follow
the instructions found at the [Twitter4j plugin][3]. Once the tokens have been
added to the configuration, disable the Twitter4jController and switch to true
`twitter.enabled`.

### Email

Email templates are located in `grails-app/views/email`. Feel free to make any
adjustments necessary. You must configure mail settings as described by the
[Mail plugin][4].

### SSH

In order to publish artifacts via SCP you must configure the SSH access port
and the default key storage. These properties are set by default to the following
values

	sshd.port = 2222
	sshd.keystorage = 'artifact-portal.ser'

Getting Started
---------------

First you should run the application and configure an initial admin account:

	grails -Dinitial.admin.password=mypasswd prod run-app

This assigns `mypasswd` as the password for the `admin` account in the production
database. You can either continue to run the application in production mode or
quit to later package it in a war and deploy it to an application server.


[1]: http://artifacts.griffon-framework.org
[2]: http://grails.org
[3]: http://grails.org/plugin/twitter4j
[4]: http://grails.org/plugin/mail
