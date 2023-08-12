#!/bin/bash

CERTS_DIR="certs"
ROOT_CA="${CERTS_DIR}/qapita-CA.pem"
ROOT_CA_KEY="${CERTS_DIR}/qapita-CA.pem.key"
SERVER_CERT="${CERTS_DIR}/qapita-wildcard.pem"
SERVER_KEY="${CERTS_DIR}/qapita-wildcard.pem.key"
PFX_FILE="${CERTS_DIR}/qapita-wildcard.pfx"
PASSWORD="PASSWORD"

# Check and create the certs directory if not exists
mkdir -p "$CERTS_DIR"

# Generate Root CA and its key if they are not available
if [ ! -f "$ROOT_CA" ] || [ ! -f "$ROOT_CA_KEY" ]; then
  # Generate the root CA key
  openssl genpkey -algorithm RSA -out "$ROOT_CA_KEY"

  # Create a configuration file for the Root CA
  cat > "${CERTS_DIR}/rootCA.cnf" <<- EOM
[ req ]
distinguished_name = req_distinguished_name
x509_extensions = v3_ca

[ req_distinguished_name ]
commonName = Common Name
commonName_max = 64

[ v3_ca ]
basicConstraints = critical, CA:TRUE, pathlen:0
EOM

  # Generate the root CA certificate
  openssl req -x509 -new -key "$ROOT_CA_KEY" -sha256 -days 1024 -out "$ROOT_CA" -subj "/C=IN/ST=Telangana/L=Hyderabad/O=Qapita FinTech Pte. Ltd./CN=Qapita Dev Root CA" -config "${CERTS_DIR}/rootCA.cnf"

  # Clean up the configuration file
  #rm "${CERTS_DIR}/rootCA.cnf"
fi

# Generate server certificate and its key if they are not available
if [ ! -f "$SERVER_CERT" ] || [ ! -f "$SERVER_KEY" ]; then
  # Create a configuration file for the subjectAltName extension
  cat > "${CERTS_DIR}/server.ext" <<- EOM
subjectAltName = DNS:*.qapitacorp.local, DNS:*.qapita.local, DNS:*.qapita.app.local, DNS:localhost
extendedKeyUsage = serverAuth
EOM

  # Generate the server key (specifying RSA algorithm)
  openssl genpkey -algorithm RSA -out "$SERVER_KEY"

  # Create a certificate signing request
  openssl req -new -key "$SERVER_KEY" -out "${CERTS_DIR}/server.csr" -subj "/C=IN/ST=Telangana/L=Hyderabad/O=Qapita FinTech Pte. Ltd./CN=*.qapitacorp.local"

  # Sign the CSR with the Root CA
  openssl x509 -req -in "${CERTS_DIR}/server.csr" -CA "$ROOT_CA" -CAkey "$ROOT_CA_KEY" -CAcreateserial -out "$SERVER_CERT" -days 365 -sha256 -extfile "${CERTS_DIR}/server.ext"

  # Clean up the CSR and configuration file
  #rm "${CERTS_DIR}/server.csr" "${CERTS_DIR}/server.ext"
fi

# Export the server certificate as a PFX file
openssl pkcs12 -export -out "$PFX_FILE" -inkey "$SERVER_KEY" -in "$SERVER_CERT" -password pass:$PASSWORD
