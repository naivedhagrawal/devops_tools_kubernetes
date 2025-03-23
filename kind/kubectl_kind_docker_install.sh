#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Install dependencies
echo "Updating system and installing dependencies..."
sudo apt update -y && sudo apt install -y curl git bash-completion

# Check if kubectl is already installed
if command -v kubectl &> /dev/null; then
    echo "kubectl is already installed. Skipping installation."
else
    echo "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
fi

echo "Verifying kubectl installation..."
kubectl version --client

# Check if Kind is already installed
if command -v kind &> /dev/null; then
    echo "Kind is already installed. Skipping installation."
else
    echo "Installing Kind..."
    curl -Lo ./kind "https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64"
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
fi

echo "Verifying Kind installation..."
kind version

# Install Docker
echo "Installing Docker..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Manually add Docker repository
echo "Adding Docker repository..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \ 
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Start and enable Docker
echo "Starting and enabling Docker..."
sudo systemctl start docker
sudo systemctl enable docker

# Add user to Docker group
echo "Adding user to Docker group..."
sudo usermod -aG docker $USER

# Verify Docker installation
echo "Verifying Docker installation..."
docker --version

echo "Installation completed successfully!"

kubectl version
kind version

# Set Kind to use Docker explicitly
export KIND_EXPERIMENTAL_PROVIDER=docker

# Check if a Kind cluster already exists
if kind get clusters | grep -q "^kind$"; then
    if [ "$(kind get nodes 2>/dev/null | wc -l)" -eq 0 ]; then
        echo "Kind cluster 'kind' exists but has no nodes. Do you want to delete and recreate it? (y/n)"
        read -r answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            kind delete cluster --name kind
            echo "Creating Kind cluster..."
            kind create cluster --config kind-cluster-config.yaml --name kind
        else
            echo "Skipping cluster creation."
        fi
    else
        echo "Kind cluster 'kind' already exists. Skipping creation."
    fi
else
    echo "Creating Kind cluster..."
    kind create cluster --config kind-cluster-config.yaml --name kind
fi

kubectl apply -f namespace.yaml
kubectl config set-context --current --namespace=devops-tools

kind get nodes
kubectl get nodes
kubectl cluster-info --context kind-kind

kind create cluster --config kind-cluster-config.yaml --name kind
kubectl apply -f namespace.yaml
kubectl config set-context --current --namespace=devops-tools
