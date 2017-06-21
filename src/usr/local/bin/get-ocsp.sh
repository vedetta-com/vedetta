#!/bin/sh
SITE="$1"
LEDIR="/etc/ssl/acme"
DIR="$LEDIR"
HOST="ocsp.int-x3.letsencrypt.org"

# (!) relayd TLS-Server doesn't ocsp, but verify httpd instead
SITE="10.10.10.10"

# Get chain signed by ISRG Root X1 https://letsencrypt.org/certificates/
ftp -a -o chain.pem https://letsencrypt.org/certs/letsencryptauthorityx3.pem.txt

# Get OCSP response
openssl ocsp -no_nonce \
             -respout      $DIR/$SITE.ocsp.resp.new \
             -issuer       $DIR/chain.pem \
             -verify_other $DIR/chain.pem \
             -cert         $DIR/$SITE.crt \
             -url http://$HOST/ \
             -header "HOST" "$HOST" > $DIR/$SITE.ocsp.reply.txt 2>&1

if grep -q ": good" $DIR/$SITE.ocsp.reply.txt; then
    if cmp -s $DIR/$SITE.ocsp.resp.new $DIR/$SITE.ocsp.resp.der; then
        rm $DIR/$SITE.ocsp.resp.new
    else
        mv $DIR/$SITE.ocsp.resp.new $DIR/$SITE.ocsp.resp.der
        rcctl restart httpd
    fi
else
    cat $DIR/$SITE.ocsp.reply.txt
fi

mv $DIR/$SITE.ocsp.reply.txt $DIR/$SITE.ocsp.reply.old.txt

# Verify
echo | openssl s_client -connect $SITE:443 -tlsextdebug -status | grep OCSP
