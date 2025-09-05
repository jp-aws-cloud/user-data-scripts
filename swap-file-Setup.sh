#!/bin/bash
# Swap file setup script    
# For low-memory EC2 (t2.micro, t3.micro)

set -euo pipefail

SWAP_SIZE=2G

fallocate -l $SWAP_SIZE /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile none swap sw 0 0" >> /etc/fstab

swapon --show
free -h
echo "Swap file of size $SWAP_SIZE created and activated."
