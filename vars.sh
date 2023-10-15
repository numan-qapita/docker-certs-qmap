CERTS_DIR="certs"

ROOT_CA_FILE_NAME="Qapita_DEV_ROOT_CA"
ROOT_CA="${CERTS_DIR}/${ROOT_CA_FILE_NAME}.pem"

ROOT_CA_CRT="${ROOT_CA_FILE_NAME}.crt"
ROOT_CA_KEY="${CERTS_DIR}/Qapita_DEV_ROOT_CA.pem.key"

SERVER_CERT_FILE_NAME="qapitacorp.local-bundle"
SERVER_CERT="${CERTS_DIR}/${SERVER_CERT_FILE_NAME}.pem"
SERVER_CERT_CRT="${SERVER_CERT_FILE_NAME}.crt"

SERVER_KEY="${CERTS_DIR}/qapitacorp.local.key"

PFX_FILE="${CERTS_DIR}/qapitacorp.local.pfx"

EVENTSTORE_CERT="${CERTS_DIR}/eventstore.qapitacorp.local.pem"
EVENTSTORE_KEY="${CERTS_DIR}/eventstore.qapitacorp.local.pem.key"
EVENTSTORE_PFX="${CERTS_DIR}/eventstore.qapitacorp.local.pfx"