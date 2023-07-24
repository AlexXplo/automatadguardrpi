#!/bin/bash

# Automatic update and upgrade
sudo apt update
sudo apt upgrade -y

# Install Docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create a directory for AdGuard Home
mkdir adguard_home
cd adguard_home

# Configure docker-compose.yml for AdGuard Home
cat <<EOF > docker-compose.yml
version: "3"
services:
  adguard:
    image: adguard/adguardhome:latest
    restart: always
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "67:67/udp"
      - "68:68/tcp"
      - "68:68/udp"
      - "853:853/tcp"
      - "853:853/udp"
    volumes:
      - ./data:/opt/adguardhome/work
      - ./conf:/opt/adguardhome/conf
      - ./logs:/opt/adguardhome/logs
    dns:
      - 1.1.1.1
      - 1.0.0.1
EOF

# Start AdGuard Home
sudo docker-compose up -d

# Final information
echo "Installation and configuration of AdGuard Home have been completed successfully!"
