#!/bin/sh
# Public Key Pinning Extension for HTTP (HKPK)
# https://tools.ietf.org/html/rfc7469
# To do: Update and reload relayd.conf

KEYFORM="rsa" # "ec"
KEYFILE="/etc/ssl/acme/private/freedns.afraid.org.key" # from etc/acme-client.conf

openssl $KEYFORM -in $KEYFILE -outform der -pubout | \
openssl dgst -sha256 -binary | \
openssl enc -base64
