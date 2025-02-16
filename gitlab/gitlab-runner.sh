#!/bin/bash

# GitLab Configuration
GITLAB_URL="http://devops.local:8081"  # Updated GitLab URL
NAMESPACE="devops-tools"
GITLAB_PAT="your_hardcoded_token_here"  # Hardcoded GitLab Personal Access Token

# Install required dependencies
if ! command -v helm &> /dev/null; then
    echo "🔹 Helm not found, installing..."
    sudo dnf install helm -y
else
    echo "✅ Helm is already installed."
fi

if ! command -v jq &> /dev/null; then
    echo "🔹 jq not found, installing..."
    sudo dnf install jq -y
else
    echo "✅ jq is already installed."
fi

# Add GitLab Helm repo
helm repo add gitlab https://charts.gitlab.io
helm repo update

# Create Kubernetes Namespace (if not exists)
kubectl get namespace $NAMESPACE &>/dev/null || kubectl create namespace $NAMESPACE

# Apply RBAC configurations
echo "🔹 Applying RBAC configurations..."
kubectl apply -f rbac.yaml

# Store the PAT in a Kubernetes Secret (so it's not exposed)
kubectl create secret generic gitlab-pat-secret -n $NAMESPACE --from-literal=GITLAB_PAT="$GITLAB_PAT" --dry-run=client -o yaml | kubectl apply -f -

# Get Shared Runner Registration Token dynamically using the correct API endpoint
echo "🔹 Fetching dynamic GitLab Shared Runner token..."
RUNNER_TOKEN=$(curl --silent --header "PRIVATE-TOKEN: $GITLAB_PAT" "$GITLAB_URL/api/v4/application/settings" | jq -r '.runner_registration_token')

# Check if token was retrieved
if [ -z "$RUNNER_TOKEN" ] || [ "$RUNNER_TOKEN" == "null" ]; then
    echo "❌ Failed to fetch GitLab Shared Runner token. Check your Personal Access Token permissions."
    exit 1
fi

echo "✅ Successfully retrieved shared runner token."

# Deploy GitLab Runner using Helm (Token is never stored in plaintext)
echo "🚀 Deploying GitLab Shared Runner in Kubernetes..."
helm install gitlab-runner gitlab/gitlab-runner --namespace $NAMESPACE \
  --set gitlabUrl="$GITLAB_URL" \
  --set runnerRegistrationToken="$RUNNER_TOKEN" \
  --set runners.executor="kubernetes" \
  --set runners.kubernetes.namespace="$NAMESPACE" \
  --set runners.kubernetes.serviceAccountName="gitlab-runner" \
  --set runners.privileged=true

# Apply Autoscaling Configurations
echo "🔹 Applying autoscaling configurations..."
kubectl apply -f autoscaling.yaml

# Verify Deployment
echo "🔹 Checking deployment status..."
kubectl get pods -n $NAMESPACE

# Check if the shared runner is registered in GitLab
echo "🔹 Checking GitLab Shared Runner registration..."
RUNNER_STATUS=$(curl --silent --header "PRIVATE-TOKEN: $GITLAB_PAT" "$GITLAB_URL/api/v4/runners/all" | jq -r '.[0].status')

if [ "$RUNNER_STATUS" == "active" ]; then
    echo "✅ GitLab Shared Runner successfully registered and active!"
else
    echo "❌ GitLab Shared Runner registration failed. Check the GitLab UI."
fi
