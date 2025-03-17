#!/bin/bash
# Update package list and install nginx
apt-get update
apt-get install -y nginx

# Start and enable nginx
systemctl start nginx
systemctl enable nginx

# Install UFW (Uncomplicated Firewall)
apt-get install -y ufw

# Allow SSH and HTTP traffic
ufw allow ssh
ufw allow http

# Enable UFW
ufw --force enable
