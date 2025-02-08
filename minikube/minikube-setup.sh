#!/bin/bash

# Exit script on error
set -e

echo "🔥 Updating system packages..."
sudo dnf update -y

echo "📦 Installing required dependencies..."
sudo dnf install -y qemu-kvm libvirt virt-install bridge-utils curl wget

echo "🚀 Enabling and starting libvirtd..."
sudo systemctl enable --now libvirtd

echo "🔑 Adding current user to libvirt group..."
sudo usermod -aG libvirt $(whoami)

echo "📥 Downloading and installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

echo "📥 Installing kubectl..."
sudo dnf install -y kubectl

echo "🔍 Verifying installation..."
minikube version
kubectl version --client

echo "🚀 Starting Minikube with KVM2 driver..."
minikube start --driver=kvm2 \
    --cpus=$(nproc) \
    --memory=$(free -m | awk '/^Mem:/{print $2 - 1024}')M \
    --disk-size=50g

echo "✅ Minikube setup complete! Checking node status..."
kubectl get nodes

echo "💡 Run 'minikube dashboard' to open the Kubernetes Dashboard!"

echo "📌 You may need to log out and log back in for group changes to take effect."
