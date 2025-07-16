# Voting App - ArgoCD App of Apps Pattern with Helm

This directory contains a Helm chart that implements the App of Apps pattern for the voting application using ArgoCD.

## Architecture

The Helm-based App of Apps pattern consists of:

1. **Helm Chart Structure** - Standard Helm chart with templates and values
2. **Root Application** - Manages all other applications
3. **Individual Applications** - Each component has its own ArgoCD Application:
   - `database-app` - PostgreSQL database
   - `redis-app` - Redis cache
   - `vote-app` - Vote frontend service
   - `result-app` - Result display service
   - `worker-app` - Background worker

## Directory Structure

```
argocd-apps/
├── Chart.yaml                    # Helm chart metadata
├── values.yaml                   # Default values
├── values-dev.yaml              # Development environment values
├── values-prod.yaml             # Production environment values
├── templates/
│   ├── _helpers.tpl             # Helm helper functions
│   ├── root-application.yaml    # Root application template
│   ├── database-application.yaml # Database application template
│   ├── redis-application.yaml   # Redis application template
│   ├── vote-application.yaml    # Vote service template
│   ├── result-application.yaml  # Result service template
│   └── worker-application.yaml  # Worker application template
└── README.md                    # This file
```

## Features

### 🔧 Configurable Values
- **Global settings**: Repository URL, target revision, namespace, project
- **Per-environment**: Different values for dev, staging, prod
- **Component toggles**: Enable/disable individual applications
- **Sync policies**: Configurable sync behavior per environment

### 🏷️ Helm Labels
- Standard Helm labels for all resources
- Component-specific labels for easy filtering
- Release tracking and version management

### 🌍 Multi-Environment Support
- Development environment with safety features
- Production environment with full automation
- Easy to add staging or other environments

## Deployment

### Prerequisites

1. ArgoCD installed in your cluster
2. Helm 3.x installed
3. Access to the Git repository containing the Kubernetes manifests

### Steps

1. **Update the repository URL** in the values files:
   ```yaml
   global:
     repoURL: https://github.com/CHARANPRAJWAL/example-voting-app-argocd-k8s.git
   ```

2. **Deploy to development**:
   ```bash
   helm install voting-app-dev ./argocd-apps \
     --values ./argocd-apps/values-dev.yaml
   ```

3. **Deploy to production**:
   ```bash
   helm install voting-app-prod ./argocd-apps \
     --values ./argocd-apps/values-prod.yaml
   ```

4. **Upgrade existing deployment**:
   ```bash
   helm upgrade voting-app-dev ./argocd-apps \
     --values ./argocd-apps/values-dev.yaml
   ```

## Configuration

### Values Structure

```yaml
global:
  namespace: voting-app          # Target namespace
  repoURL: https://github.com/CHARANPRAJWAL/example-voting-app-argocd-k8s.git
  targetRevision: HEAD          # Git branch/tag
  project: default              # ArgoCD project

argocd:
  namespace: argocd             # ArgoCD namespace
  finalizers: [...]             # ArgoCD finalizers

syncPolicy:
  automated:
    prune: true                 # Enable pruning
    selfHeal: true             # Enable self-healing
  syncOptions: [...]           # Sync options

applications:
  root:
    enabled: true              # Enable root application
    name: voting-app-root      # Application name
    path: argocd-apps
  # ... other applications
```

### Environment-Specific Values

#### Development (`values-dev.yaml`)
- Uses `develop` branch
- Disables pruning for safety
- Uses `voting-app-dev` namespace
- Different application names with `-dev` suffix

#### Production (`values-prod.yaml`)
- Uses `main` branch
- Enables full automation
- Uses `voting-app-prod` namespace
- Different application names with `-prod` suffix

## Benefits of Helm-based App of Apps

- **Templating**: Dynamic generation of ArgoCD applications
- **Environment Management**: Easy configuration per environment
- **Version Control**: Helm release tracking and rollback capabilities
- **Reusability**: Same chart for multiple environments
- **Validation**: Helm's built-in validation and linting
- **Packaging**: Standard Helm packaging and distribution

## Monitoring

### Helm Commands
```bash
# List releases
helm list

# Get release status
helm status voting-app-dev

# View release history
helm history voting-app-dev

# Rollback to previous version
helm rollback voting-app-dev 1
```

### ArgoCD Commands
```bash
# List applications
argocd app list

# Get application status
argocd app get voting-app-root-dev

# Sync application
argocd app sync voting-app-root-dev
```

## Troubleshooting

### Common Issues

1. **Repository URL not found**:
   - Verify the Git repository URL in values files
   - Ensure ArgoCD has access to the repository

2. **Application sync failed**:
   - Check ArgoCD application logs: `argocd app logs voting-app-root-dev`
   - Verify target namespace exists or can be created

3. **Helm installation failed**:
   - Run `helm lint ./argocd-apps` to check for issues
   - Verify all required values are set

### Debug Commands

```bash
# Lint the chart
helm lint ./argocd-apps

# Dry run installation
helm install --dry-run --debug voting-app-dev ./argocd-apps \
  --values ./argocd-apps/values-dev.yaml

# Template rendering
helm template voting-app-dev ./argocd-apps \
  --values ./argocd-apps/values-dev.yaml
``` 