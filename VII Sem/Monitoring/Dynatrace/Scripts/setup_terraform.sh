#!/bin/bash

# Function to display messages
echo_info() {
    echo -e "\e[34m[INFO] $1\e[0m"
}

echo_error() {
    echo -e "\e[31m[ERROR] $1\e[0m"
}

# Exit immediately if a command exits with a non-zero status
set -e

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo_error "This script must be run as root. Use sudo to execute."
    exit 1
fi

# Update and upgrade system packages
echo_info "Updating and upgrading system packages..."
sudo apt update && sudo apt upgrade -y

# Set the desired Terraform version
TERRAFORM_VERSION="1.6.0"  # Replace with the desired version
echo_info "Setting Terraform version to $TERRAFORM_VERSION."

# Download Terraform
echo_info "Downloading Terraform..."
curl -fsSL -o terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Extract and install Terraform
echo_info "Installing Terraform..."
unzip terraform.zip
sudo mv terraform /usr/local/bin/
chmod +x /usr/local/bin/terraform

# Cleanup
echo_info "Cleaning up..."
rm terraform.zip

# Verify installation
echo_info "Verifying Terraform installation..."
terraform_version=$(terraform version | head -n 1)
if [[ $? -eq 0 ]]; then
    echo_info "$terraform_version successfully installed."
else
    echo_error "Terraform installation failed."
    exit 1
fi
