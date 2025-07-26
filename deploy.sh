#!/bin/bash

# Voting App ArgoCD Deployment Script
# This script deploys the voting app to both dev and prod clusters

set -e

echo "🚀 Deploying Voting App to ArgoCD clusters..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Helm is installed
if ! command -v helm &> /dev/null; then
    print_error "Helm is not installed. Please install Helm first."
    exit 1
fi

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    print_error "kubectl is not installed. Please install kubectl first."
    exit 1
fi

# Function to deploy to an environment
deploy_environment() {
    local env=$1
    local values_file=$2
    local release_name=$3
    
    print_status "Deploying to $env environment..."
    
    # Check if release already exists
    if helm list | grep -q "$release_name"; then
        print_warning "Release $release_name already exists. Upgrading..."
        helm upgrade "$release_name" . --values "$values_file"
        print_success "Upgraded $env environment"
    else
        print_status "Installing new release for $env environment..."
        helm install "$release_name" . --values "$values_file"
        print_success "Installed $env environment"
    fi
}

# Deploy to development environment (in-cluster)
print_status "Setting up development environment (in-cluster)..."
deploy_environment "development" "values-dev.yaml" "voting-app-dev"

# Deploy to production environment (cluster-prod)
print_status "Setting up production environment (cluster-prod)..."
deploy_environment "production" "values-prod.yaml" "voting-app-prod"

echo ""
print_success "🎉 Deployment completed successfully!"
echo ""
echo "📋 Summary:"
echo "  • Development (in-cluster): voting-app-dev"
echo "  • Production (cluster-prod): voting-app-prod"
echo ""
echo "🔍 Next steps:"
echo "  1. Check ArgoCD UI to monitor application sync status"
echo "  2. Verify applications are syncing to the correct clusters"
echo "  3. Check that all services are running in their respective namespaces"
echo ""
echo "📊 Useful commands:"
echo "  • List Helm releases: helm list"
echo "  • Check ArgoCD apps: argocd app list"
echo "  • Get app status: argocd app get voting-app-root-dev"
echo "  • Sync manually: argocd app sync voting-app-root-dev" 