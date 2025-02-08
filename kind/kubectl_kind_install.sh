#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Install dependencies
echo "Updating system and installing dependencies..."
sudo dnf install -y curl git bash-completion

# Install kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

echo "Verifying kubectl installation..."
kubectl version --client

# Install Kind
echo "Installing Kind..."
curl -Lo ./kind "https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64"
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

echo "Verifying Kind installation..."
kind version

echo "Installation completed successfully!"
