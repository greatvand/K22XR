#!/bin/bash

set -e

CLUSTER_NAME="myeks"
REGION="us-east-1"
NODEGROUP_NAME="ng-1"
NODE_TYPE="t3.medium"
NODES=2

echo "===== Updating system and installing prerequisites ====="
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y unzip curl apt-transport-https gnupg lsb-release jq

echo "===== Installing AWS CLI v2 ====="
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

echo "===== Installing kubectl (EKS 1.33) ====="
curl -LO "https://dl.k8s.io/release/v1.33.0/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client

echo "===== Installing eksctl ====="
curl --silent --location "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" | tar xz
sudo mv eksctl /usr/local/bin
eksctl version

echo "===== Installing Helm ====="
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version

echo "===== Creating EKS cluster: $CLUSTER_NAME ====="
eksctl create cluster \
  --name "$CLUSTER_NAME" \
  --region "$REGION" \
  --version 1.33 \
  --nodegroup-name "$NODEGROUP_NAME" \
  --node-type "$NODE_TYPE" \
  --nodes "$NODES" \
  --managed \
  --vpc-public-access-cidrs 0.0.0.0/0

echo "===== Verifying cluster access ====="
aws eks update-kubeconfig --region "$REGION" --name "$CLUSTER_NAME"
kubectl get nodes
kubectl auth can-i create clusterrole

echo "===== EKS cluster $CLUSTER_NAME setup complete ====="
