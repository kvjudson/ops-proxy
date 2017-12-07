# Revoke client
openssl ca -config openssl.cnf -revoke $1/cert.pem -keyfile ca/private/cakey.pem -cert ca/cacert.pem
cd ca
openssl ca -config ../openssl.cnf -gencrl -keyfile private/cakey.pem -cert opsca-cert.pem -out opsca.crl
cd ..
