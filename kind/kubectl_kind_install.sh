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

# Install Docker
echo "Installing Docker..."
sudo dnf install -y dnf-plugins-core

# Manually add Docker repository
echo "Adding Docker repository..."
sudo tee /etc/yum.repos.d/docker-ce.repo <<EOF
[docker-ce-stable]
name=Docker CE Stable
baseurl=https://download.docker.com/linux/fedora/\$releasever/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/fedora/gpg
EOF

sudo dnf install -y docker-ce docker-ce-cli containerd.io

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
