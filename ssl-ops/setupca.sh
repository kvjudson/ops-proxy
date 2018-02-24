#!/bin/bash
# CA
mkdir ca > /dev/null 2>&1
cd ca
rm -fr *
mkdir certs private
chmod 700 private
echo 01 > serial
touch index.txt
openssl req -x509 -config ../openssl.cnf -newkey rsa:4096 -out opsca-cert.pem -outform PEM -subj /CN=OpsCA/ -nodes -days 10950
# check cert info: openssl x509 -text -noout -in ca/opsca-cert.pem
# check crl info: openssl crl -text -noout -in ca/opsca.crl
#openssl genrsa -out opsca-key.pem 2048
#openssl req -x509 -config ../openssl.cnf -key opsca-key.pem -out opsca-cert.pem -outform PEM -new -nodes -days 10950 -subj /CN=OpsCA/
openssl ca -config ../openssl.cnf -gencrl -keyfile opsca-key.pem -cert opsca-cert.pem -out opsca.crl
cd ..
