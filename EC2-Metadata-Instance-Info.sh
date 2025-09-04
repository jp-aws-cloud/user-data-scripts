#!/bin/bash
set -euo pipefail

# Metadata base URL
META_URL="http://169.254.169.254/latest/meta-data"
TOKEN_URL="http://169.254.169.254/latest/api/token"
DOC_URL="http://169.254.169.254/latest/dynamic/instance-identity/document"

# Get IMDSv2 token
TOKEN=$(curl -s -X PUT "$TOKEN_URL" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Function to fetch metadata safely (IMDSv2)
fetch_metadata() {
    local path=$1
    curl -s --fail -H "X-aws-ec2-metadata-token: $TOKEN" "$META_URL/$path" || echo "Not available"
}

# Function for aligned printing
print_metadata() {
    printf "%-25s : %s\n" "$1" "$2"
}

echo "================ EC2 Instance Metadata ================"

# Identity Document
IDENTITY_DOC=$(curl -s --fail -H "X-aws-ec2-metadata-token: $TOKEN" "$DOC_URL" || echo "{}")

print_metadata "Instance ID" "$(fetch_metadata instance-id)"
print_metadata "Instance Type" "$(fetch_metadata instance-type)"
print_metadata "AMI ID" "$(fetch_metadata ami-id)"
print_metadata "Hostname" "$(fetch_metadata hostname)"
print_metadata "Local Hostname" "$(fetch_metadata local-hostname)"
print_metadata "Public Hostname" "$(fetch_metadata public-hostname)"
print_metadata "Public IPv4" "$(fetch_metadata public-ipv4)"
print_metadata "Private IPv4" "$(fetch_metadata local-ipv4)"

MAC=$(fetch_metadata mac)
print_metadata "MAC Address" "$MAC"
print_metadata "VPC ID" "$(fetch_metadata network/interfaces/macs/$MAC/vpc-id)"
print_metadata "Subnet ID" "$(fetch_metadata network/interfaces/macs/$MAC/subnet-id)"
print_metadata "Security Groups" "$(fetch_metadata security-groups)"

AZ=$(fetch_metadata placement/availability-zone)
print_metadata "Availability Zone" "$AZ"
REGION=$(echo "$AZ" | sed 's/[a-z]$//')
print_metadata "Region" "$REGION"

print_metadata "IAM Role" "$(fetch_metadata iam/security-credentials/)"
print_metadata "Block Devices" "$(fetch_metadata block-device-mapping/)"

echo "========================================================"
echo "🔹 Instance Identity Document (JSON):"
echo "$IDENTITY_DOC"
echo "========================================================"
