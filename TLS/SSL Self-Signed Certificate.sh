#!/bin/bash
set -euo pipefail # safer bash scripting

DOMAIN="test.local" # Replace with your domain
CERT_DIR="/etc/ssl/$DOMAIN" # Directory to store the certificate

mkdir -p $CERT_DIR # Create certificate directory
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \  #    Generate self-signed certificate 
  -keyout $CERT_DIR/$DOMAIN.key \  # Private key file   
  -out $CERT_DIR/$DOMAIN.crt \  # Certificate file
  -subj "/CN=$DOMAIN"  # Subject with Common Name
