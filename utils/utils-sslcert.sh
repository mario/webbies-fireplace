#!/bin/sh
# utils-sslcert.sh: OpenSSL and its certificates.

sslcert_install () {

# Installing openssl

echo 'Installing openssl'
apt-get -y install openssl
echo 'Done'

}

sslcert_certgen () {

echo 'Creating private ssl key'
cd /etc/ssl/private
openssl genrsa -out fireplace-ssl.key 1024
echo 'Done'

# We need certificate

echo 'Creating a certificate'
cd /etc/ssl/certs
openssl req -batch -new -x509 -days 365 -key ../private/fireplace-ssl.key  -out fireplace-ssl.crt
echo 'Done'

# Lets make things secure

echo 'Securing key'
cd /etc/ssl/private
chmod 400 fireplace-ssl.key
echo 'Done'

}