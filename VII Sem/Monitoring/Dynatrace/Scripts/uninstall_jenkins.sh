#!/bin/bash

# Stop Jenkins service
echo "Stopping Jenkins service..."
sudo systemctl stop jenkins

# Uninstall Jenkins
echo "Uninstalling Jenkins..."
sudo apt-get remove --purge jenkins -y

# Remove unused dependencies
echo "Removing unused dependencies..."
sudo apt-get autoremove --purge -y

# Clean up remaining Jenkins files
echo "Removing remaining Jenkins files..."
sudo rm -rf /var/lib/jenkins
sudo rm -rf /var/log/jenkins
sudo rm -rf /etc/jenkins

# Remove Jenkins repository and GPG key
echo "Removing Jenkins repository and GPG key..."
sudo rm /etc/apt/sources.list.d/jenkins.list
sudo rm /usr/share/keyrings/jenkins-keyring.asc

# Clean apt cache
echo "Cleaning apt cache..."
sudo apt-get clean

