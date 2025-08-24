#!/bin/bash

# Update and install prerequisites
sudo apt update -y

echo "Starting system update..."
sudo apt update && echo "System update completed."

echo "Installing Git..."
sudo apt install git -y && echo "Git installation completed."

echo "Installing Maven..."
sudo apt install maven -y && echo "Maven installation completed."
mvn -version

echo "Installing OpenJDK 17..."
sudo apt install openjdk-17-jdk -y && echo "OpenJDK 17 installation completed."
java -version

echo "Installing additional updates..."
sudo apt install update && echo "Additional updates completed."

echo "Installing Curl..."
sudo apt install curl -y && echo "Curl installation completed."

echo "Installing Ping..."
sudo apt install iputils-ping -y && echo "Ping installation completed."

echo "Installing Python 3..."
sudo apt-get install python3 -y && echo "Python 3 installation completed."

echo "Installing Pip for Python 3..."
sudo apt-get install python3-pip -y && echo "Python 3 Pip installation completed."

sudo apt install openssh-client -y
sudo apt install software-properties-common -y
sudo apt update -y

# Verify installations
mvn -version
java -version

# Add Ansible PPA and install Ansible
sudo add-apt-repository ppa:ansible/ansible --yes --update
sudo apt install -y ansible
sudo apt install -y ansible-core

# Verify Ansible installation
ansible --version
pip install docker
pip install docker-compose
ansible-galaxy collection install community.docker
# Create Ansible user and configure permissions
sudo useradd -m -s /bin/bash ansible
sudo usermod -aG sudo ansible

# Add no-password sudo privileges for Ansible user
echo "ansible ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

# Disable password for the Ansible user
sudo passwd -d ansible

# Ensure necessary directories exist
sudo mkdir -p /etc/ansible
sudo touch /etc/ansible/ansible.cfg
sudo touch /etc/ansible/hosts

# Switch to Ansible user and generate SSH keys
sudo -u ansible ssh-keygen -t rsa -b 4096 -f /home/ansible/.ssh/id_rsa -q -N ''

# Configure Ansible settings
sudo bash -c 'cat << EOF > /etc/ansible/ansible.cfg
[defaults]
remote_user = ansible
become = True
become_method = sudo
EOF'

# Add local host to Ansible hosts
sudo bash -c 'cat << EOF > /etc/ansible/hosts
[mytargets]
localhost ansible_connection=local
EOF'

# Test Ansible setup
ansible -i /etc/ansible/hosts mytargets -m ping

# Create and run a sample playbook
sudo bash -c 'cat << EOF > /home/ansible/sample_playbook.yml
---
- name: Test Playbook
  hosts: mytargets
  tasks:
    - name: Ping localhost
      ping:
EOF'

ansible-playbook -i /etc/ansible/hosts /home/ansible/sample_playbook.yml
echo "Ansible setup completed successfully."
echo "Copy the Public Key"
sudo -u ansible cat /home/ansible/.ssh/id_rsa.pub
