#!/bin/bash
set -euo pipefail

SMTP_SERVER="${SMTP_SERVER:-"mail.example.com"}"
SMTP_USERNAME="${SMTP_USERNAME:-"user@example.com"}"
SMTP_PASSWORD="${SMTP_PASSWORD:-"mySuperS3cretPassword1234"}"
MAIL_TO="${MAIL_TO:-"user@example.com"}"
ALIAS_NAME="${ALIAS_NAME:-"user"}"
COMMAND="${1:-"smtpd"}"

sed "s/MAIL_TO_PLACEHOLDER/$MAIL_TO/g" /etc/smtpd-template/aliases > /etc/smtpd/aliases
sed -i "s/ALIAS_NAME_PLACEHOLDER/$ALIAS_NAME/g" /etc/smtpd/aliases
sed "s/MAIL_TO_PLACEHOLDER/$MAIL_TO/g" /etc/smtpd-template/recipients > /etc/smtpd/recipients
sed "s/SMTP_USERNAME_PLACEHOLDER/$SMTP_USERNAME/g" /etc/smtpd-template/secrets > /etc/smtpd/secrets
sed -i "s/SMTP_PASSWORD_PLACEHOLDER/$SMTP_PASSWORD/g" /etc/smtpd/secrets
sed "s/SMTP_SERVER_PLACEHOLDER/$SMTP_SERVER/g" /etc/smtpd-template/smtpd.conf > /etc/smtpd/smtpd.conf
sed -i "s/SMTP_USERNAME_PLACEHOLDER/$SMTP_USERNAME/g" /etc/smtpd/smtpd.conf

if [ "$COMMAND" = 'smtpd' ]; then
  exec /usr/sbin/smtpd -f /etc/smtpd/smtpd.conf -d
fi

exec "$@"
