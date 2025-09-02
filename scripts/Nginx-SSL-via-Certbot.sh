#!/bin/bash
set -euo pipefail # safer bash scripting

DOMAIN="example.com" # Replace with your domain

apt update # Update package lists
apt install -y nginx certbot python3-certbot-nginx # Install Nginx and Certbot

# Configure firewall
ufw allow 'Nginx Full' # allow HTTP and HTTPS traffic

# Start nginx
systemctl enable nginx --now # enable and start nginx

# SSL Certificate
certbot --nginx -d $DOMAIN -d www.$DOMAIN # Obtain and install SSL certificate

echo "Nginx setup with SSL for $DOMAIN" # Completion message