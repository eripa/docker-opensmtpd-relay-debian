# OpenSMTPD mailer for Docker

## What?

This container can be used for your hobby project to add mail out functionality. It sets up [OpenSMTPD](http://www.opensmtpd.org) as a simple relay to the configured SMTP server, e.g. Gmail. It will send  **all** emails to the configured mail-to address.

### Details

 * Debian Jessie
 * latest tag is Intel x86_64
 * x86_64 uses debian:jessie
 * arm build uses armv7/armhf-debian:jessie
 * Must be configured to work! 
 * Ports 25 and 587 are exposed
 * Do **not** map the ports to outside world. The relay is configured to accept **ALL** requests without auth. Use internal Docker network

## Flow

                                        +-------------+                +-----------------+
    +-----------------+                 |             |                |                 |
    |                 |                 |  OpenSMTPd  |                |  external SMTP  |
    | your container  | smtp request    |  Container  |                |  server, such   |
    | that needs mail +----------------->             +--------------->+  as Gmail       |
    | out             |  to smtp://smtpd+-------------+                |                 |
    |                 |                 | name: smtpd |                |                 |
    +-----------------+                 +-------------+                +-----------------+
    +-------------------------------------------------+
    |                                                 |
    |                   Docker network                |
    |                                                 |
    +-------------------------------------------------+

## Configuration

Configuration is done with environment variables. Start the server with the `smtpd` command. The entrypoint script will do the rest 

### Variables

    SMTP_SERVER   # Mail server, such as smtp.gmail.com
    SMTP_USERNAME # Your SMTP username
    SMTP_PASSWORD # Your SMTP password
    MAIL_TO       # The address all mails should be forwarded to

## Usage

You can use the docker-compose-example.yml file as a reference, but generally it can be run like this:

    docker run --rm -e "SMTP_SERVER=mail.example.com" -e "SMTP_USERNAME=user@example.com" -e 'SMTP_PASSWORD=mySecretPassword1234' -e "MAIL_TO=user@example.com" opensmtpd-debian-arm smtpd

## Example send using docker-compose

Setup an opensmtpd container, create another container and send mail from it, over the internal network`

    cp docker-compose-example.yml docker-compose.yml
    # Edit docker-compose.yml with you details
    docker-compose up -d
    docker run --rm -it --net=dockeropensmtpdrelaydebian_default armv7/armhf-debian:jessie /bin/bash
    # in container
    apt-get update && apt-get -qy install heirloom-mailx
    echo "hep" | mailx -v -s "hello from other container" -S smtp=smtp://opensmtpd -S from="whale" eric@ripa.io

# License

MIT, see LICENSE file