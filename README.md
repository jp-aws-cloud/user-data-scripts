Got it 👍 You’re asking for **all generic scripts for EC2** (Ubuntu-based) — basically a **toolbox of reusable scripts** that handle the most common EC2 tasks. I’ll organize them by category so you can copy, tweak, and run them as needed.

---

# 🔧 **Generic EC2 Scripts Collection (Ubuntu/Debian)**

---

## 1️⃣ **System Bootstrap (Update & Essentials Install)**

```bash
#!/bin/bash
set -euo pipefail

LOG_FILE="/var/log/bootstrap.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "===== Starting EC2 Bootstrap at $(date) ====="

# Ensure root
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root (sudo)"
  exit 1
fi

# Update & Upgrade
apt update && apt upgrade -y

# Install common tools
apt install -y git curl wget unzip htop tree net-tools build-essential

echo "===== Bootstrap Completed at $(date) ====="
```

---

## 2️⃣ **User & SSH Setup**

```bash
#!/bin/bash
set -euo pipefail

USERNAME="developer"
SSH_KEY="ssh-rsa AAAAB3Nza...yourkey..."

# Create user
id -u "$USERNAME" &>/dev/null || adduser --disabled-password --gecos "" "$USERNAME"

# Add sudo
usermod -aG sudo "$USERNAME"

# Setup SSH
mkdir -p /home/$USERNAME/.ssh
echo "$SSH_KEY" >> /home/$USERNAME/.ssh/authorized_keys
chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

echo "User $USERNAME created and SSH configured."
```

---

## 3️⃣ **Web Server Setup (Nginx + SSL via Certbot)**

```bash
#!/bin/bash
set -euo pipefail

DOMAIN="example.com"

apt update
apt install -y nginx certbot python3-certbot-nginx

# Configure firewall
ufw allow 'Nginx Full'

# Start nginx
systemctl enable nginx --now

# SSL Certificate
certbot --nginx -d $DOMAIN -d www.$DOMAIN

echo "Nginx setup with SSL for $DOMAIN"
```

---

## 4️⃣ **Node.js + NVM Setup**

```bash
#!/bin/bash
set -euo pipefail

# Install NVM
if ! command -v nvm &> /dev/null; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Install Node.js LTS
nvm install --lts
nvm use --lts
node -v
npm -v
```

---

## 5️⃣ **Project Deployment (Git + Node app)**

```bash
#!/bin/bash
set -euo pipefail

APP_DIR="/var/www/myapp"
REPO="https://github.com/username/repo.git"

# Install deps
apt update && apt install -y git curl

# Install Node via NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || {
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
  source ~/.bashrc
}

nvm install --lts
nvm use --lts

# Clone repo
rm -rf $APP_DIR
git clone $REPO $APP_DIR

cd $APP_DIR
npm install
npm run build || echo "No build step"
npm start &
```

---

## 6️⃣ **Database Setup**

### MySQL

```bash
#!/bin/bash
set -euo pipefail

apt update
apt install -y mysql-server

systemctl enable mysql --now
mysql_secure_installation

echo "MySQL installed & secured."
```

### MongoDB

```bash
#!/bin/bash
set -euo pipefail

curl -fsSL https://pgp.mongodb.com/server-7.0.asc | sudo tee /etc/apt/trusted.gpg.d/mongodb.asc
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org.list

apt update
apt install -y mongodb-org

systemctl enable mongod --now
```

---

## 7️⃣ **Backup Script**

```bash
#!/bin/bash
set -euo pipefail

BACKUP_DIR="/var/backups"
TIMESTAMP=$(date +%F-%H-%M-%S)
PROJECT_DIR="/var/www/myapp"

mkdir -p $BACKUP_DIR

tar -czf $BACKUP_DIR/myapp-$TIMESTAMP.tar.gz -C $PROJECT_DIR .

echo "Backup saved at $BACKUP_DIR/myapp-$TIMESTAMP.tar.gz"
```

---

## 8️⃣ **Monitoring Script**

```bash
#!/bin/bash
set -euo pipefail

echo "===== System Status $(date) ====="
echo "Uptime:" && uptime
echo "Memory:" && free -h
echo "Disk Usage:" && df -h
echo "Top Processes:" && ps aux --sort=-%mem | head -n 10
```

---

## 9️⃣ **Firewall & Security**

```bash
#!/bin/bash
set -euo pipefail

# Install ufw
apt install -y ufw

# Allow SSH, HTTP, HTTPS
ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable

# Fail2ban
apt install -y fail2ban
systemctl enable fail2ban --now
```

---

## 🔟 **Auto Startup on Reboot**

Add this to `crontab -e`:

```
@reboot /var/www/myapp/start.sh
```

---

⚡ Now you have a **ready-to-use EC2 script pack** for:

* Bootstrap
* User/SSH
* Nginx + SSL
* Node.js setup
* Project deployment
* Databases (MySQL/MongoDB)
* Backups
* Monitoring
* Firewall/Security
* Auto-start

---

👉 Do you want me to **combine these into one master “menu-driven script”** (where it asks what you want to do and runs only that part), so you don’t have to manage them separately?
