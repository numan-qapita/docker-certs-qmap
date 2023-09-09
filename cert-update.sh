#!/bin/bash

source vars.sh

sudo cp $ROOT_CA /usr/local/share/ca-certificates/$ROOT_CA_CRT
sudo update-ca-certificates

openssl verify -CApath /etc/ssl/certs $ROOT_CA

sudo cp $SERVER_CERT /etc/ssl/certs/$SERVER_CERT_CRT
sudo cp $SERVER_KEY /etc/ssl/private/