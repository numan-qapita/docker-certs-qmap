#!/bin/bash

source vars.sh
PASSWORD="PASSWORD"

# Check and create the certs directory if not exists
mkdir -p "$CERTS_DIR"

# Generate Root CA and its key if they are not available
if [ ! -f "$ROOT_CA" ] || [ ! -f "$ROOT_CA_KEY" ]; then
  # Generate the root CA key
  openssl genpkey -algorithm RSA -out "$ROOT_CA_KEY"

  # Create a configuration file for the Root CA
  cat > "${CERTS_DIR}/qapita-CA.cnf" <<- EOM
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
  openssl req -x509 -new -key "$ROOT_CA_KEY" -sha256 -days 3650 -out "$ROOT_CA" -subj "/C=IN/ST=Telangana/L=Hyderabad/O=Qapita FinTech Pte. Ltd./CN=Qapita Dev Root CA/OU=Development" -config "${CERTS_DIR}/qapita-CA.cnf"

  # Clean up the configuration file
  rm "${CERTS_DIR}/qapita-CA.cnf"
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
  openssl req -new -key "$SERVER_KEY" -out "${CERTS_DIR}/server.csr" -subj "/C=IN/ST=Telangana/L=Hyderabad/O=Qapita FinTech Pte. Ltd./CN=*.qapitacorp.local/OU=Development"

  # Sign the CSR with the Root CA
  openssl x509 -req -in "${CERTS_DIR}/server.csr" -CA "$ROOT_CA" -CAkey "$ROOT_CA_KEY" -CAcreateserial -out "$SERVER_CERT" -days 365 -sha256 -extfile "${CERTS_DIR}/server.ext"

  # Clean up the CSR and configuration file
  #rm "${CERTS_DIR}/server.csr" "${CERTS_DIR}/server.ext"
fi

# Export the server certificate as a PFX file
openssl pkcs12 -export -out "$PFX_FILE" -inkey "$SERVER_KEY" -in "$SERVER_CERT" -password pass:$PASSWORD

# Generate server certificate and its key for eventstore.qapitacorp.local if they are not available
if [ ! -f "$EVENTSTORE_CERT" ] || [ ! -f "$EVENTSTORE_KEY" ]; then
  # Create a configuration file for the subjectAltName extension
  cat > "${CERTS_DIR}/eventstore.ext" <<- EOM
subjectAltName = DNS:eventstore.qapitacorp.local
extendedKeyUsage = serverAuth
EOM

  # Generate the server key (specifying RSA algorithm)
  openssl genpkey -algorithm RSA -out "$EVENTSTORE_KEY"

  # Create a certificate signing request (CSR)
  openssl req -new -key "$EVENTSTORE_KEY" -out "${CERTS_DIR}/eventstore.csr" -subj "/C=IN/ST=Telangana/L=Hyderabad/O=Qapita FinTech Pte. Ltd./CN=eventstore.qapitacorp.local/OU=Development"

  # Sign the CSR with the Root CA to generate the certificate
  openssl x509 -req -in "${CERTS_DIR}/eventstore.csr" -CA "$ROOT_CA" -CAkey "$ROOT_CA_KEY" -CAcreateserial -out "$EVENTSTORE_CERT" -days 365 -sha256 -extfile "${CERTS_DIR}/eventstore.ext"
fi

# Export the server certificate for eventstore.qapitacorp.local as a PFX file
openssl pkcs12 -export -out "$EVENTSTORE_PFX" -inkey "$EVENTSTORE_KEY" -in "$EVENTSTORE_CERT" -password pass:$PASSWORD
