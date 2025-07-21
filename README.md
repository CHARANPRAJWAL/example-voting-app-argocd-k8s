# Voting App - ArgoCD App of Apps Pattern with Helm

This directory contains a Helm chart that implements the App of Apps pattern for the voting application using ArgoCD. The Helm chart creates ArgoCD `Application` resources, which in turn deploy the actual Kubernetes manifests for each service.

## Architecture

The Helm-based App of Apps pattern consists of:

1.  **Helm Chart**: A parent chart that contains templates for ArgoCD `Application` resources.
2.  **Root Application**: An ArgoCD `Application` that manages all other applications in the stack.
3.  **Individual Applications**: Each component of the voting app has its own ArgoCD Application:
    - `database-app` - PostgreSQL database
    - `redis-app` - Redis cache
    - `vote-app` - Vote frontend service
    - `result-app` - Result display service
    - `worker-app` - Background worker
4.  **Kubernetes Manifests**: Standard Kubernetes manifests (`Deployment`, `Service`, etc.) for each application component, stored in a separate directory.

## Directory Structure

```
.
├── Chart.yaml                    # Helm chart metadata
├── values.yaml                   # Default values for the Helm chart
├── values-dev.yaml               # Development environment values
├── values-prod.yaml              # Production environment values
├── templates/                    # Helm templates for ArgoCD Applications
│   ├── _helpers.tpl
│   ├── root-application.yaml
│   ├── database-application.yaml
│   ├── redis-application.yaml
│   ├── vote-application.yaml
│   ├── result-application.yaml
│   └── worker-application.yaml
├── k8s-manifests/                # Kubernetes manifests for each service
│   ├── database/
│   ├── redis/
│   ├── vote/
│   ├── result/
│   └── worker/
└── README.md                     # This file
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
3. Access to the Git repository where this code is hosted.

### Steps

1.  **Commit and Push Your Changes**:
    ArgoCD uses Git as the source of truth. Before deploying or upgrading, ensure all your changes (e.g., modifications to the `k8s-manifests`) are committed and pushed to your repository.
    ```bash
    git add .
    git commit -m "Your descriptive commit message"
    git push
    ```

2.  **Deploy a New Environment**:
    To deploy a new instance of the application stack (e.g., for production), run `helm install`. This command creates the ArgoCD `Application` resources in the cluster. ArgoCD will then detect these resources and deploy the manifests from the specified path in your Git repository.
    ```bash
    # For Production
    helm install voting-app-prod . --values ./values-prod.yaml

    # For Development
    helm install voting-app-dev . --values ./values-dev.yaml
    ```

3.  **Upgrade an Existing Deployment**:
    If you've made changes to the Helm chart itself or need to point to a new Git revision, use `helm upgrade`.
    ```bash
    helm upgrade voting-app-prod . --values ./values-prod.yaml
    ```

## Configuration

### Values Structure

The `values.yaml` file configures the ArgoCD `Application` resources. The `path` field is crucial as it tells ArgoCD where to find the Kubernetes manifests for each component.

```yaml
global:
  namespace: voting-app          # Target namespace for the deployed services
  repoURL: https://github.com/CHARANPRAJWAL/example-voting-app-argocd-k8s.git
  targetRevision: HEAD           # Git branch/tag to sync from
  project: default               # ArgoCD project

argocd:
  namespace: argocd              # Namespace where ArgoCD is running

applications:
  root:
    enabled: true
    name: voting-app-root
    path: .                      # The root app points to the Helm chart itself

  database:
    enabled: true
    name: database-app
    path: k8s-manifests/database # Path to the database manifests

  redis:
    enabled: true
    name: redis-app
    path: k8s-manifests/redis    # Path to the redis manifests

  # ... and so on for vote, result, and worker
```

### Environment-Specific Values

#### Development (`values-dev.yaml`)
- Uses `develop` branch (or a feature branch)
- May have sync policies with manual triggers for safety
- Deploys to a `voting-app-dev` namespace
- Application names are suffixed with `-dev`

#### Production (`values-prod.yaml`)
- Uses `main` branch
- Enables fully automated sync policies
- Deploys to a `voting-app-prod` namespace
- Application names are suffixed with `-prod`

## Benefits of Helm-based App of Apps

- **Templating**: Dynamically generate ArgoCD applications for different environments.
- **Environment Management**: Easily manage configuration drift between environments.
- **Version Control**: Use Helm release tracking and rollback for the ArgoCD Application setup.
- **Reusability**: Use the same chart to stamp out multiple, isolated environments.
- **Packaging**: Standard Helm packaging and distribution for your entire application stack definition.

## Monitoring

### Helm Commands
Use Helm to manage the lifecycle of the ArgoCD `Application` resources.
```bash
# List Helm releases (shows your dev and prod setups)
helm list

# Get status of a release
helm status voting-app-dev
```

### ArgoCD Commands
Use the ArgoCD CLI to check the status of the applications and their resources.
```bash
# List all applications managed by ArgoCD
argocd app list

# Get the status of the root application
argocd app get voting-app-root-dev

# Sync an application manually (if not automated)
argocd app sync voting-app-root-dev
```

## Troubleshooting

### Common Issues

1.  **ArgoCD shows `Missing` or `OutOfSync` status**:
    - This is often a caching issue after a `git push`. Wait a few moments and click the `Refresh` button in the ArgoCD UI for the root application.
    - Verify the `repoURL` and `targetRevision` in your values file are correct.

2.  **Application sync failed**:
    - Check the ArgoCD application logs for detailed error messages: `argocd app logs voting-app-root-dev`
    - Ensure the manifests in the `k8s-manifests` directory are valid Kubernetes YAML.

3.  **Helm installation failed**:
    - Run `helm lint .` to check for chart syntax issues.
    - Verify all required values are set in your `values-*.yaml` file.

### Debug Commands

```bash
# Lint the chart for syntax errors
helm lint .

# Perform a dry run of an installation to see the generated ArgoCD manifests
helm install --dry-run --debug voting-app-dev . --values ./values-dev.yaml

# Render templates locally to inspect the output
helm template voting-app-dev . --values ./values-dev.yaml
``` 