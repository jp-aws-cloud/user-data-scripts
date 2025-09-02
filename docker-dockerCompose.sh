#!/bin/bash # Docker and Docker Compose installation script
set -euo pipefail # safer bash scripting

apt update # Update package lists
apt install -y ca-certificates curl gnupg lsb-release # Install prerequisites   

mkdir -p /etc/apt/keyrings # Create keyrings directory  
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg # Add Docker's official GPG key 
chmod a+r /etc/apt/keyrings/docker.gpg # Set permissions for the key    


echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update # Update package lists again 
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin # Install Docker and Docker Compose 

systemctl enable docker --now # Enable and start Docker service 

# Verify
docker --version # Check Docker version 
docker compose version # Check Docker Compose version   
echo "Docker and Docker Compose installed successfully." # Completion message   
# Add current user to docker group to run docker without sudo
usermod -aG docker $USER
echo "User $USER added to docker group. You may need to log out and back in for this to take effect."       