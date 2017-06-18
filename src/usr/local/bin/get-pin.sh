#!/bin/sh

KEYFORM="rsa" # "ec"
KEYFILE="/etc/ssl/acme/private/freedns.afraid.org.key"

openssl $KEYFORM -in $KEYFILE -outform der -pubout | \
openssl dgst -sha256 -binary | \
openssl enc -base64
