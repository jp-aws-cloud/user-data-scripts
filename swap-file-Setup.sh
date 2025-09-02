#!/bin/bash # Swap file setup script    
# For low-memory EC2 (t2.micro, t3.micro)
set -euo pipefail # safer bash scripting    

SWAP_SIZE=2G # Define swap size 

fallocate -l $SWAP_SIZE /swapfile # Create swap file    
chmod 600 /swapfile # Secure the swap file  
mkswap /swapfile # Set up swap area 
swapon /swapfile  # Activate swap   
echo "/swapfile none swap sw 0 0" >> /etc/fstab  # Ensure swap is enabled on boot   

swapon --show # Verify swap is active   
free -h   # Display memory and swap usage
echo "Swap file of size $SWAP_SIZE created and activated."  # Completion message