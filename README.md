# Example Voting App - Kubernetes Specifications

This repository contains the Kubernetes manifests and ArgoCD Helm chart specifications for deploying the [Example Voting App](https://github.com/CHARANPRAJWAL/example-voting-app-argocd-k8s.git) using GitOps best practices.

## Repository Structure

```
k8s-specifications/
├── argocd-apps/                # Helm chart for ArgoCD App of Apps pattern
│   ├── Chart.yaml              # Helm chart metadata
│   ├── values.yaml             # Default values
│   ├── values-dev.yaml         # Development environment values
│   ├── values-prod.yaml        # Production environment values
│   ├── templates/              # Helm templates for ArgoCD Applications
│   │   ├── root-application.yaml
│   │   ├── database-application.yaml
│   │   ├── redis-application.yaml
│   │   ├── vote-application.yaml
│   │   ├── result-application.yaml
│   │   └── worker-application.yaml
│   ├── voting-app-root.yaml    # Standalone ArgoCD Application manifest
│   ├── database-app.yaml       # Standalone ArgoCD Application manifest
│   ├── redis-app.yaml          # Standalone ArgoCD Application manifest
│   ├── vote-app.yaml           # Standalone ArgoCD Application manifest
│   ├── result-app.yaml         # Standalone ArgoCD Application manifest
│   ├── worker-app.yaml         # Standalone ArgoCD Application manifest
│   └── README.md               # Helm chart documentation
├── db.yaml                     # PostgreSQL Deployment & Service
├── redis.yaml                  # Redis Deployment & Service
├── vote.yaml                   # Voting frontend Deployment & Service
├── result.yaml                 # Result frontend Deployment & Service
└── worker.yaml                 # Worker Deployment & Service
```

## What is Included?
- **Kubernetes manifests** for each microservice (db, redis, vote, result, worker)
- **ArgoCD App of Apps Helm chart** for managing all components via GitOps
- **Environment-specific values** for dev and prod
- **Standalone ArgoCD Application YAMLs** for direct use if not using Helm

## Getting Started

### Prerequisites
- Kubernetes cluster
- [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) installed
- [Helm 3.x](https://helm.sh/) installed

### 1. Clone the Repository
```bash
git clone https://github.com/CHARANPRAJWAL/example-voting-app-argocd-k8s.git
cd k8s-specifications
```

### 2. Deploy with Helm (Recommended)

#### Development Environment
```bash
helm install voting-app-dev ./argocd-apps \
  --values ./argocd-apps/values-dev.yaml
```

#### Production Environment
```bash
helm install voting-app-prod ./argocd-apps \
  --values ./argocd-apps/values-prod.yaml
```

#### Upgrade Existing Deployment
```bash
helm upgrade voting-app-dev ./argocd-apps \
  --values ./argocd-apps/values-dev.yaml
```

### 3. Deploy Standalone ArgoCD Applications (Optional)
You can apply the YAMLs in `argocd-apps/` directly if not using Helm:
```bash
kubectl apply -f argocd-apps/voting-app-root.yaml
```

## Customization
- Edit `argocd-apps/values.yaml`, `values-dev.yaml`, or `values-prod.yaml` to change repo URLs, namespaces, or enable/disable components.
- Update the Kubernetes manifests (`db.yaml`, `redis.yaml`, etc.) as needed for your environment.

## Repository URL
All ArgoCD applications and Helm values reference:
```
https://github.com/CHARANPRAJWAL/example-voting-app-argocd-k8s.git
```

## References
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/en/stable/)
- [Helm Documentation](https://helm.sh/docs/)
- [Example Voting App](https://github.com/dockersamples/example-voting-app)

---

> Maintained by [CHARANPRAJWAL](https://github.com/CHARANPRAJWAL) 