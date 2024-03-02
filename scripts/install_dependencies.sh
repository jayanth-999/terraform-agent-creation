#!/bin/bash

# Install Ansible
sudo apt-get update
sudo apt-get install -y ansible

# Install Docker
sudo apt-get update
sudo apt-get install -y docker.io

# Install Docker Compose
sudo apt-get update
sudo apt-get install -y docker-compose

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash