# Client
mkdir $1 > /dev/null 2>&1
cd $1
openssl genrsa -out key.pem 4096
openssl req -new -key key.pem -out req.pem -outform PEM -subj /CN=$1/O=client/ -nodes
cd ../ca
openssl ca -config ../openssl.cnf -in ../$1/req.pem -out ../$1/cert.pem -notext -batch -extensions client_ca_extensions
cd ..
openssl pkcs12 -nodes -export -out $1/client.p12 -inkey $1/key.pem -in $1/cert.pem -passout pass:ops
