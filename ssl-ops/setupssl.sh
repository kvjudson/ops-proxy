#!/bin/bash
# Setup self signed CA and SSL cert
# Example CN=ops-proxy.somecompany.com
# Example SUBJECT_DETAIL='C=US/ST=Utah/L=Lehi/O=SomeCompany'
mkdir testca > /dev/null 2>&1
cd testca
rm -fr *
mkdir certs private
chmod 700 private
echo 01 > serial
touch index.txt
openssl req -x509 -config ../openssl.cnf -newkey rsa:2048 -out cacert.pem -outform PEM -subj /CN=OpsCA/ -nodes
cd ..
# Server
mkdir server > /dev/null 2>&1
cd server
openssl genrsa -out key.pem 2048
openssl req -new -key key.pem -out req.pem -outform PEM -subj /CN=$CN/O=server/ -nodes
cd ../testca
openssl ca -config ../openssl.cnf -in ../server/req.pem -out ../server/cert.pem -notext -batch -extensions server_ca_extensions
cd ../server
cat cert.pem > server.pem
cat key.pem >> server.pem
cd ..
# Client
mkdir client > /dev/null 2>&1
cd client
openssl genrsa -out key.pem 2048
openssl req -new -key key.pem -out req.pem -outform PEM -subj /CN=$CN/O=client/ -nodes
cd ../testca
openssl ca -config ../openssl.cnf -in ../client/req.pem -out ../client/cert.pem -notext -batch -extensions client_ca_extensions
cd ..
mkdir client2 > /dev/null 2>&1
# Client 2 (will be revoked)
cd client2
openssl genrsa -out key.pem 2048
openssl req -new -key key.pem -out req.pem -outform PEM -subj /CN=$CN/O=client/ -nodes
cd ../testca
openssl ca -config ../openssl.cnf -in ../client2/req.pem -out ../client2/cert.pem -notext -batch -extensions client_ca_extensions
# Revoke client2
#openssl ca -config ../openssl.cnf -revoke ../client2/cert.pem -keyfile private/cakey.pem -cert cacert.pem
#openssl ca -config ../openssl.cnf -gencrl -keyfile private/cakey.pem -cert cacert.pem -out testca.crl.pem
cd ..
mkdir ssl > /dev/null 2>&1
openssl req -x509 -newkey rsa:4096 -nodes -subj "/$SUBJECT_DETAIL/CN=$CN" -keyout ssl/key.pem -out ssl/cert.pem -days 10950
