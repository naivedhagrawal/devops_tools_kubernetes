#!/bin/bash

# GitLab Configuration
GITLAB_URL="http://devops.local:8081"  # GitLab internal service URL
NAMESPACE="devops-tools"

# Prompt user to enter GitLab PAT securely
echo "🔹 Enter your GitLab Personal Access Token (PAT):"
read -s GITLAB_PAT  # Read token securely without displaying it

# Check if PAT is entered
if [[ -z "$GITLAB_PAT" ]]; then
    echo "❌ No GitLab PAT provided. Exiting."
    exit 1
fi

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

# Get Runner Registration Token dynamically using the stored secret
echo "🔹 Fetching dynamic GitLab Runner token..."
RUNNER_TOKEN=$(kubectl get secret gitlab-pat-secret -n $NAMESPACE -o jsonpath="{.data.GITLAB_PAT}" | base64 --decode | \
    xargs -I {} curl --silent --header "PRIVATE-TOKEN: {}" "$GITLAB_URL/api/v4/runners" | jq -r '.token')

echo "🔹 Debugging GitLab API response..."
API_RESPONSE=$(curl --silent --header "PRIVATE-TOKEN: $GITLAB_PAT" "$GITLAB_URL/api/v4/runners")
echo "API Response: $API_RESPONSE"

RUNNER_TOKEN=$(echo "$API_RESPONSE" | jq -r '.token')


# Check if token was retrieved
if [ -z "$RUNNER_TOKEN" ] || [ "$RUNNER_TOKEN" == "null" ]; then
    echo "❌ Failed to fetch GitLab Runner token. Check your Personal Access Token permissions."
    exit 1
fi

echo "✅ Successfully retrieved runner token."

# Deploy GitLab Runner using Helm (Token is never stored in plaintext)
echo "🚀 Deploying GitLab Runner in Kubernetes..."
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

# Check if the runner is registered in GitLab
echo "🔹 Checking GitLab Runner registration..."
RUNNER_STATUS=$(curl --silent --header "PRIVATE-TOKEN: $GITLAB_PAT" "$GITLAB_URL/api/v4/runners/all" | jq -r '.[] | select(.token=="'$RUNNER_TOKEN'") | .status')

if [ "$RUNNER_STATUS" == "active" ]; then
    echo "✅ GitLab Runner successfully registered and active!"
else
    echo "❌ GitLab Runner registration failed. Check the GitLab UI."
fi