#!/bin/bash

# Exit on error
set -e

# Check and Install Dependencies
for pkg in podman curl; do
    if ! command -v $pkg &>/dev/null; then
        echo "$pkg is not installed. Installing..."
        sudo dnf install -y $pkg
    else
        echo "$pkg is already installed."
    fi
done

# Download and Install/Upgrade Kind
if command -v kind &>/dev/null; then
    echo "Upgrading Kind..."
else
    echo "Installing Kind..."
fi
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/

# Install/Upgrade kubectl
if command -v kubectl &>/dev/null; then
    echo "Upgrading kubectl..."
else
    echo "Installing kubectl..."
fi
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Enable Podman Rootless Mode
if ! grep -q "KIND_EXPERIMENTAL_PROVIDER=podman" ~/.bashrc; then
    echo 'export KIND_EXPERIMENTAL_PROVIDER=podman' >> ~/.bashrc
    export KIND_EXPERIMENTAL_PROVIDER=podman
    source ~/.bashrc
fi

# Create Kubernetes Cluster with Kind
kind create cluster --name podman-cluster

# Verify Kubernetes Cluster
kubectl get nodes
