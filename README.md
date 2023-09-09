# Qapita Certificates Automation Scripts

## Introduction

The repository contains three scripts designed to automate the process of generating and managing SSL/TLS certificates. These scripts are especially useful for local development environments or testing.

- `vars.sh`: Defines all the necessary variables required by the other scripts.
- `cert-gen.sh`: Responsible for generating the root Certificate Authority (CA), server certificate, and its corresponding private key.
- `cert-update.sh`: Copies the generated certificates to appropriate directories and updates the CA certificates on your system.

---

## Pre-requisites

1. Ensure you have `openssl` installed.
2. Make sure you have `sudo` access, as some commands in `cert-update.sh` require it.

---

## Usage Guide

### Step 1: Clone the Repository

Clone the GitHub repository to your local machine.

```bash
git clone git@github.com:numan-qapita/docker-certs-qmap.git
cd docker-certs-qmap
```

### Step 2: Check Variables (Optional)

Open `vars.sh` to review or modify variables like the directory where certificates will be saved, names of certificate files, etc. By default, the script uses pre-defined values suitable for most cases.

### Step 3: Generate Certificates

Run the `cert-gen.sh` script to generate the Root CA, server certificate, and server key. Ensure that you change the `PASSWORD` variable in this script to a cryptographically strong value.

```bash
chmod +x cert-gen.sh
./cert-gen.sh
```

> **Note**: This script checks if the certificates already exist. If so, it won't overwrite them.

### Step 4: Update System Certificates

After successfully generating the certificates, run `cert-update.sh` to copy them to system directories and update the system's CA certificates. 

```bash
chmod +x cert-update.sh
./cert-update.sh
```

> **Warning**: This script requires `sudo` access to copy files to system directories and update CA certificates.

---

## Variable Descriptions (vars.sh)

- `CERTS_DIR`: Directory where all generated certificates will be stored.
- `ROOT_CA_FILE_NAME`, `ROOT_CA`, `ROOT_CA_KEY`: Variables related to the root Certificate Authority (CA).
- `SERVER_CERT_FILE_NAME`, `SERVER_CERT`, `SERVER_CERT_CRT`, `SERVER_KEY`: Variables related to the server certificate.
- `PFX_FILE`: The location where the server certificate will be exported as a PFX file.

---

## Important Information

- Password for the PFX file: The password is hardcoded as "PASSWORD" in `cert-gen.sh`. Make sure to change this in a production environment.
- Country (`C`), State (`ST`), Organization (`O`), Common Name (`CN`), and Unit (`OU`) are hardcoded in `cert-gen.sh`. You might want to adjust these according to your needs.

---

**For further questions or issues, please open a GitHub issue or contact the maintainers.**

Feel free to reach out if you need more advanced configurations or have any questions!