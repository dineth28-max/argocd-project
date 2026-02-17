# GitOps ArgoCD Kubernetes Project
<img width="4393" height="2161" alt="Untitled Diagram drawio (15)" src="https://github.com/user-attachments/assets/868bc218-21f7-44cd-b80f-79c0df9d8162" />


## Project Overview

This is a **GitOps-based deployment project** using **ArgoCD** to manage Kubernetes applications. The project demonstrates continuous synchronization of Git repository state with Kubernetes cluster state, enabling declarative infrastructure as code practices.

**Repository**: [dineth28-max/argocd-project](https://github.com/dineth28-max/argocd-project)



## Project Structure

```
argocd-app-config/
├── application.yaml          # ArgoCD Application manifest
├── README.md                 # Project documentation
└── dev/                      # Development environment configurations
    ├── deployment.yaml       # Kubernetes Deployment
    └── service.yaml          # Kubernetes Service
```



## Core Components

### 1. ArgoCD Application (`application.yaml`)

| Property | Details |
|----------|---------|
| **Application Name** | `myapp-argo-application` |
| **Namespace** | `argocd` |
| **Project** | `default` |
| **Git Repository** | `https://github.com/dineth28-max/argocd-project.git` |
| **Target Branch** | `HEAD` (main branch) |
| **Deployment Path** | `dev/` |
| **Destination Cluster** | `https://kubernetes.default.svc` (in-cluster) |
| **Target Namespace** | `myapp` |

**Sync Policies**:
- **Auto-sync enabled** - Continuous synchronization
- **Self-healing** - Automatically reconciles drift
- **Auto-prune** - Removes resources deleted from Git
- **Create namespace** - Auto-creates `myapp` namespace

### 2. Kubernetes Deployment (`dev/deployment.yaml`)

| Configuration | Value |
|---------------|-------|
| **Kind** | Deployment |
| **Name** | `myapp` |
| **Replicas** | 2 (High Availability) |
| **Container Image** | `dineth123412/web:tag1` |
| **Container Port** | 8080 |
| **Selector Label** | `app: myapp` |

**Features**:
- Maintains 2 pod replicas for redundancy
- Container selector: `app: myapp`
- Exposes port 8080 for service communication

### 3. Kubernetes Service (`dev/service.yaml`)

| Configuration | Value |
|---------------|-------|
| **Kind** | Service |
| **Name** | `myapp-service` |
| **Service Port** | 8080 |
| **Target Port** | 8080 |
| **Protocol** | TCP |
| **Selector** | `app: myapp` |

**Purpose**: Internal service discovery and load balancing for the deployment



## GitOps Workflow

```
Git Repository (GitHub)
    ↓
Developer commits changes
    ↓
ArgoCD monitors Git repository
    ↓
Compare: Desired State (Git) vs Current State (Cluster)
    ↓
Auto-sync: Apply changes to Kubernetes
    ├─ Self-heal: Correct manual drifts
    ├─ Auto-prune: Remove deleted resources
    └─ Create namespaces if needed
    ↓
Application updates in Kubernetes cluster
(2 replicas in myapp namespace)
```


## Technology Stack & Languages

| Technology | Purpose | Version |
|------------|---------|---------|
| **Kubernetes (K8s)** | Container orchestration platform | 1.20+ |
| **ArgoCD** | GitOps continuous delivery tool | Latest stable |
| **Git** | Version control & source of truth | GitHub |
| **Docker** | Container runtime & image packaging | Latest |
| **YAML** | Infrastructure as Code configuration format | - |
| **Go** | ArgoCD programming language | 1.16+ |
| **Shell/Bash** | Command-line scripting | - |

### Language Breakdown:

#### **YAML** (Configuration Language)
- Used for all Kubernetes manifests
- Files: `application.yaml`, `dev/deployment.yaml`, `dev/service.yaml`
- Declarative syntax for infrastructure definition
- Human-readable and version-control friendly

#### **Kubernetes API** (K8s Manifest Language)
- Uses `apiVersion: apps/v1` for Deployment
- Uses `apiVersion: v1` for Service
- Uses `apiVersion: argoproj.io/v1alpha1` for ArgoCD Application
- Standard CustomResourceDefinition (CRD) for ArgoCD

#### **Bash/Shell Scripts**
- Used for installation commands
- kubectl CLI interactions
- ArgoCD CLI operations
- Deployment automation

#### **Go** (Backend)
- ArgoCD is written in Go
- Handles Git synchronization
- Manages cluster state reconciliation
- API server implementation

#### **Docker** (Container Format)
- Container image: `dineth123412/web:tag1`
- Base image format specification
- Port exposure: 8080



##  Deployment Architecture

```
┌────────────────────────────────────────────┐
│     Kubernetes Cluster                     │
├────────────────────────────────────────────┤
│                                            │
│  ┌──────────────────────────────────────┐  │
│  │   ArgoCD Namespace (argocd)          │  │
│  │  ┌────────────────────────────────┐  │  │
│  │  │ ArgoCD Controller (Go)         │  │  │
│  │  │ (Monitors Git & Syncs)         │  │  │
│  │  │ myapp-argo-application         │  │  │
│  │  └────────────────────────────────┘  │  │
│  └──────────────────────────────────────┘  │
│                                            │
│  ┌──────────────────────────────────────┐  │
│  │   myapp Namespace (auto-created)     │  │
│  │  ┌────────────────────────────────┐  │  │
│  │  │ Deployment: myapp              │  │  │
│  │  │ ├─ Pod 1 (Docker Container)    │  │  │
│  │  │ └─ Pod 2 (Docker Container)    │  │  │
│  │  │ Image: dineth123412/web:tag1   │  │  │
│  │  │ Language: Application Specific │  │  │
│  │  │ Port: 8080                     │  │  │
│  │  └────────────────────────────────┘  │  │
│  │  ┌────────────────────────────────┐  │  │
│  │  │ Service: myapp-service         │  │  │
│  │  │ Port: 8080 → TargetPort: 60665 │  │  │
│  │  └────────────────────────────────┘  │  │
│  └──────────────────────────────────────┘  │
│                                            │
└────────────────────────────────────────────┘
        ↕
    GitHub Repository
    (Source of Truth)
    (Git: Version Control)
```

---

## 🔐 Security & Access Configuration

| Component | Configuration | Details |
|-----------|---------------|---------|
| **Namespace Isolation** | Yes | `argocd` & `myapp` separated |
| **RBAC** | Enabled | Default service accounts |
| **API Server** | In-cluster | `https://kubernetes.default.svc` |
| **Authentication** | Secret-based | `argocd-initial-admin-secret` |
| **Port Security** | Port-forward | No direct cluster exposure |



## Installation & Setup

### Prerequisites
```bash
# Ensure kubectl and helm are installed
kubectl version
helm version

# Git configured for repository access
git --version
```

### Step 1: Install ArgoCD

```bash
# Create ArgoCD namespace
kubectl create namespace argocd

# Install ArgoCD using official manifest
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
kubectl get pods -n argocd
```

### Step 2: Access ArgoCD UI

```bash
# View ArgoCD services
kubectl get svc -n argocd

# Port-forward to access web UI
kubectl port-forward svc/argocd-server 8080:443 -n argocd

# UI will be available at: https://localhost:8080
```

### Step 3: Get Admin Credentials

```bash
# Retrieve auto-generated admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo

# Username: admin
# Password: [output from above command]
```

### Step 4: Change Initial Password (Recommended)

```bash
# Update the admin password
argocd account update-password --account admin --new-password <new-password>

# Or delete the initial secret
kubectl delete secret argocd-initial-admin-secret -n argocd
```

### Step 5: Deploy the Application

The ArgoCD Application will automatically:
1. Create the `myapp` namespace
2. Deploy 2 replicas of the application
3. Create internal service discovery
4. Enable auto-sync and self-healing

---

## Key Features

| Feature | Status | Benefit |
|---------|--------|---------|
| **Automated Synchronization** | ✅ Enabled | No manual deployments needed |
| **Self-Healing** | ✅ Enabled | Automatically fixes configuration drift |
| **Auto-Prune** | ✅ Enabled | Removes orphaned resources |
| **Namespace Management** | ✅ Enabled | Auto-creates deployment namespace |
| **High Availability** | ✅ 2 Replicas | Service continuity |
| **Container Registry** | ✅ Docker Hub | Easy image management |
| **Git-based Deployment** | ✅ GitHub | Version controlled infrastructure |

---

## Current Status Verification

```bash
# Check ArgoCD Application status
kubectl get application -n argocd
kubectl describe application myapp-argo-application -n argocd

# Check deployment status
kubectl get pods -n myapp
kubectl get svc -n myapp
kubectl get deployment -n myapp

# View detailed pod information
kubectl describe pod -n myapp

# Check logs from pods
kubectl logs -n myapp -l app=myapp
```

---

## Update Workflow

To update the application:

1. **Modify** the deployment configuration in `dev/deployment.yaml`
2. **Commit** changes to GitHub
3. **Push** to the main branch
4. **ArgoCD** automatically detects the change
5. **Syncs** the new configuration to Kubernetes
6. **Pods** are updated with new image/configuration

Example:
```bash
# Edit the image version
git add dev/deployment.yaml
git commit -m "Update image to tag2"
git push origin main

# ArgoCD will automatically sync within polling interval (default 3 minutes)
```

---

## Documentation & References

- **Official ArgoCD Documentation**: https://argo-cd.readthedocs.io/
- **Kubernetes Documentation**: https://kubernetes.io/docs/
- **GitOps Principles**: https://www.gitops.tech/
- **Docker Hub Repository**: https://hub.docker.com/

## Project Goals & Best Practices

 **Declarative Infrastructure**: All infrastructure defined in Git  
 **Version Control**: Track all changes through Git history  
 **Immutable Deployments**: Using container images for consistency  
 **Automated Deployment**: Git push triggers automatic updates  
 **Self-Healing**: Automatic drift correction  
 **High Availability**: Multiple replicas for resilience  
 **Single Source of Truth**: GitHub as the authoritative source  



##  Monitoring & Troubleshooting

### Check Application Status
```bash
kubectl get application -A
argocd app list
argocd app describe myapp-argo-application
```

### View Sync Status
```bash
argocd app sync myapp-argo-application
argocd app wait myapp-argo-application
```

### Debug Issues
```bash
# Check ArgoCD operator logs
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-application-controller

# Check application events
kubectl describe application myapp-argo-application -n argocd

# Check deployment events
kubectl describe deployment myapp -n myapp
```

---

##  Project Owner

**Repository**: dineth28-max/argocd-project  
**Container Registry**: dineth123412/web  
**Branch**: main  



## 📄 License & Contribution

Please follow the GitOps practices and ensure all changes are committed to Git before deployment.

Last Updated: February 18, 2026
