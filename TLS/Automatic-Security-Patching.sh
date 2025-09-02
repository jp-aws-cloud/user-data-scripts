#!/bin/bash  # Automatic security patching script
set -euo pipefail # safer bash scripting    

apt update && apt upgrade -y  # Update and upgrade packages
apt install -y unattended-upgrades # Install unattended-upgrades package

dpkg-reconfigure -plow unattended-upgrades   # Enable automatic updates
echo "Automatic security patching enabled." # Completion message
# For more customization, edit /etc/apt/apt.conf.d/50unattended-upgrades
# and /etc/apt/apt.conf.d/20auto-upgrades as needed.
# Logs are in /var/log/unattended-upgrades/
echo "Check /var/log/unattended-upgrades/ for details." # Inform user
# You can also run `unattended-upgrade --dry-run -d` to test the setup.
echo "To test, run: unattended-upgrade --dry-run -d" # Inform user  
echo "Security patching script completed." # Completion message
# Note: This script is intended for Ubuntu/Debian systems. Adjust accordingly for other distributions.
# Caution: Automatic updates may occasionally require a reboot. Monitor your system accordingly.
# Consider setting up automatic reboots if necessary by configuring /etc/apt/apt.conf.d/50unattended-upgrades
# Add the following line to enable automatic reboots:
# Unattended-Upgrade::Automatic-Reboot "true";
# You can also specify a time for the reboot:
# Unattended-Upgrade::Automatic-Reboot-Time "02:00";
# Ensure to test this in a non-production environment first.    
