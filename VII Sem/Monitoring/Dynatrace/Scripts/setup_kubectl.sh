#!/bin/bash

# Update package list
sudo apt-get update -y
export DEBIAN_FRONTEND=noninteractive
# Install dependencies for Google Cloud SDK
sudo apt-get install -y apt-transport-https ca-certificates gnupg curl tar  -y
sudo apt-get update -y
# -------------------------------
# 🛠️ Install Helm (Latest Version)
# -------------------------------
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# 🔍 Verify Helm Installation
helm version

# Add the Google Cloud SDK distribution URI as a package source
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list

# Import the Google Cloud public key and save it securely
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

# Update package list to include Google Cloud SDK packages
sudo apt-get update -y

# Install Google Cloud CLI
sudo apt-get install -y google-cloud-cli

# Install kubectl
sudo apt-get install -y kubectl

# Verify kubectl installation
kubectl version --client

# Verify Google Cloud CLI installation
gcloud --version

# Install GKE gcloud auth plugin
sudo apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugin

# Verify GKE gcloud auth plugin installation
gke-gcloud-auth-plugin --version
ansible-galaxy collection install community.kubernetes
pip3 install kubernetes google-auth


