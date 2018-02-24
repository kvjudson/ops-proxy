#!/bin/bash
# Setup SSL cert for the ops-proxy nginx server
# Example ./setupserver.sh ops-proxy.somecompany.com

# Server
echo "Using CN=$1"
mkdir server > /dev/null 2>&1
cd server
openssl genrsa -out key.pem 4096
openssl req -new -key key.pem -out req.pem -outform PEM -subj /CN=$1/O=server/ -nodes
cd ../ca
openssl ca -config ../openssl.cnf -in ../server/req.pem -out ../server/cert.pem -notext -batch -extensions server_ca_extensions
cd ../server
cat cert.pem > server.pem
cat key.pem >> server.pem
cd ..
