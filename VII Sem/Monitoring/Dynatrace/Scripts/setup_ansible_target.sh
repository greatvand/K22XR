#!/bin/bash

# Create Ansible user without password
echo "Creating 'ansible' user..."
sudo adduser --disabled-password --gecos "" ansible

# Add the 'ansible' user to the sudo group
echo "Adding 'ansible' user to sudo group..."
sudo usermod -aG sudo ansible

# Update the sudoers file to allow passwordless sudo for the 'ansible' user
echo "Configuring sudoers file for passwordless sudo..."
echo "ansible ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers > /dev/null

# Create SSH directory for 'ansible' user
echo "Setting up SSH directory for 'ansible' user..."
sudo -u ansible mkdir -p /home/ansible/.ssh
sudo -u ansible chmod 700 /home/ansible/.ssh
sudo -u ansible touch /home/ansible/.ssh/authorized_keys
sudo -u ansible chmod 600 /home/ansible/.ssh/authorized_keys
sudo chown -R ansible:ansible /home/ansible/.ssh

# Ask for the public key and paste it into the authorized_keys file
echo "Please paste the public key for the 'ansible' user:"
read -r public_key

echo "$public_key" | sudo tee /home/ansible/.ssh/authorized_keys > /dev/null

# Ensure SSH server is set to allow public key authentication
echo "Configuring SSH server to allow public key authentication..."
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/#AuthorizedKeysFile .ssh\/authorized_keys/AuthorizedKeysFile .ssh\/authorized_keys/' /etc/ssh/sshd_config

# Restart SSH service to apply changes
echo "Restarting SSH service..."
sudo systemctl restart ssh

# Show the directory and file permissions
echo "Displaying the permissions of the .ssh directory and authorized_keys file..."
ls -ld /home/ansible/.ssh
ls -l /home/ansible/.ssh/authorized_keys
cat /home/ansible/.ssh/authorized_keys

echo "Setup completed successfully!"
