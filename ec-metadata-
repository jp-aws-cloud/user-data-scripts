#!/bin/bash
set -euo pipefail # safer bash scripting    

echo "===== EC2 Metadata =====" # Header
curl -s http://169.254.169.254/latest/meta-data/     # List all metadata categories
echo "===== Instance ID ====="                            # Instance ID
curl -s http://169.254.169.254/latest/meta-data/instance-id #  Instance ID
echo "===== Instance Type =====" # Instance Type
echo "===== Public IP =====" # Public IP
curl -s http://169.254.169.254/latest/meta-data/public-ipv4  # Public IP
echo "===== Private IP ====="
curl -s http://169.254.169.254/latest/meta-data/local-ipv4 # Private IP
echo "===== Availability Zone =====" # Availability Zone    
