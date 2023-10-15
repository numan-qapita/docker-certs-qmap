#!/bin/bash

source vars.sh

sudo cp $ROOT_CA /usr/local/share/ca-certificates/$ROOT_CA_CRT
sudo update-ca-certificates

openssl verify -CApath /etc/ssl/certs $ROOT_CA

sudo cp $SERVER_CERT /etc/ssl/certs/$SERVER_CERT_CRT
sudo cp $SERVER_KEY /etc/ssl/private/


# On Mac run these, if you use hte homebrew default locations for nginx
#sudo cp $SERVER_CERT /opt/homebrew/etc/nginx/ssl/certs/qapitacorp.local-bundle.crt
#sudo cp $SERVER_KEY /opt/homebrew/etc/nginx/ssl/private/qapitacorp.local.key