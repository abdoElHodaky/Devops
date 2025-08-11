# DevOps Infrastructure & Deployment Pipeline

A comprehensive DevOps repository implementing Infrastructure as Code (IaC) and GitOps practices for deploying a NestCMS application on AWS EKS using Terraform, Kubernetes, and FluxCD.

## 🚨 Current Infrastructure State

> **Important**: This repository contains a **development/template** infrastructure setup. Many core components are currently commented out and require activation for production use.

### 📊 Infrastructure Status

| Component | Status | Action Required |
|-----------|--------|-----------------|
| AWS EKS Cluster | ❌ Commented Out | Uncomment in `terraform/cluster.tf` |
| Kubernetes Deployment | ❌ Commented Out | Uncomment in `terraform/kube_deployment.tf` |
| S3 Bucket Resources | ❌ Commented Out | Uncomment in `terraform/main.tf` |
| IAM Roles & Policies | ✅ Ready | No action needed |
| CI/CD Workflows | ✅ Active | Ready to use |
| FluxCD Integration | ✅ Active | Ready to use |

### 🎯 Deployment Readiness Checklist

- [ ] **Infrastructure Activation**: Uncomment Terraform resources
- [ ] **AWS Credentials**: Configure AWS access keys and region
- [ ] **Container Registry**: Set up Docker Hub or GHCR access
- [ ] **Environment Variables**: Configure all required secrets
- [ ] **Terraform State**: Initialize and plan infrastructure
- [ ] **Kubernetes Access**: Verify cluster connectivity
- [ ] **Application Secrets**: Configure MongoDB and application secrets

## 🏗️ Architecture Overview

This repository provides a complete cloud-native deployment pipeline featuring:

- **Infrastructure**: AWS EKS cluster provisioned with Terraform
- **CI/CD**: Dual pipeline approach using GitHub Actions and CircleCI
- **GitOps**: FluxCD for continuous deployment and synchronization
- **Application**: NestCMS containerized application
- **Orchestration**: Kubernetes for container orchestration

## 📋 Prerequisites

### Required Tools
- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [kubectl](https://kubernetes.io/docs/tasks/tools/) >= 1.32
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- [Docker](https://docs.docker.com/get-docker/) for local development
- [FluxCD CLI](https://fluxcd.io/flux/installation/) >= 2.6.4

### Required Accounts & Access
- AWS Account with EKS permissions
- GitHub account with repository access
- Docker Hub account for container registry
- CircleCI account (if using CircleCI pipeline)

### Environment Variables
Configure the following secrets in your CI/CD platform:

```bash
# AWS Configuration
TF_VAR_AWS_ACCESS_KEY      # AWS Access Key ID
TF_VAR_AWS_ACCESS_SECRET   # AWS Secret Access Key
TF_VAR_AWS_REGION          # AWS Region (default: eu-central-1)

# Cluster Configuration
TF_VAR_EKS_CLUSTER_NAME    # EKS Cluster Name

# Container Registry Access
TF_VAR_DOCKER_PAT          # Docker Hub Personal Access Token
TF_VAR_GHCR_PAT           # GitHub Container Registry PAT

# Terraform Cloud (if using)
TF_API_TOKEN              # Terraform Cloud API Token
```

## 🚀 Quick Start

### Option 1: Infrastructure Activation (Recommended for Production)

1. **Activate Infrastructure Components**:
   ```bash
   # Navigate to terraform directory
   cd terraform
   
   # Uncomment the EKS cluster resources in cluster.tf
   sed -i 's|^/\*||g; s|\*/||g' cluster.tf
   
   # Uncomment the Kubernetes deployment in kube_deployment.tf
   sed -i 's|^/\*||g; s|\*/||g' kube_deployment.tf
   
   # Uncomment S3 resources if needed in main.tf
   sed -i 's|^/\*||g; s|\*/||g' main.tf
   ```

2. **Deploy Infrastructure**:
   ```bash
   # Initialize Terraform
   terraform init
   
   # Plan the deployment
   terraform plan
   
   # Apply the configuration
   terraform apply --auto-approve
   ```

3. **Verify Deployment**:
   ```bash
   # Check cluster status
   kubectl get nodes --kubeconfig="./kubeconfig.yaml"
   
   # Check application status
   kubectl get pods -l app=nestcms --kubeconfig="./kubeconfig.yaml"
   ```

### Option 2: CI/CD Pipeline Deployment

#### GitHub Actions Pipeline

1. **Configure Repository Secrets**:
   - Add all required environment variables to GitHub Secrets
   - Ensure AWS credentials have EKS permissions

2. **Activate Infrastructure** (if not done manually):
   - Uncomment Terraform resources as shown in Option 1
   - Commit and push changes

3. **Trigger Deployment**:
   - Go to Actions tab in GitHub
   - Run "Terraform-Plan" workflow manually
   - The "kube" workflow will trigger automatically after success

#### CircleCI + FluxCD Pipeline

1. **FluxCD Repository Setup**:
   - Ensure access to the [FluxCD repository](https://github.com/abdoElHodaky/Fluxcd)
   - Configure GITHUB_TOKEN in CircleCI environment

2. **Trigger Pipeline**:
   - Push changes to trigger CircleCI workflow
   - Pipeline creates Kind cluster and deploys via FluxCD

## 📁 Repository Structure

```
.
├── .circleci/
│   └── config.yml              # CircleCI pipeline configuration
├── .github/
│   └── workflows/
│       ├── kube.yaml          # Kubernetes deployment workflow
│       ├── terraform-pa.yml   # Terraform plan & apply
│       └── terraform-pd.yml   # Terraform destroy
├── terraform/
│   ├── cluster.tf             # EKS cluster configuration (COMMENTED)
│   ├── kube_deployment.tf     # Kubernetes deployment (COMMENTED)
│   ├── kube_service.tf        # Kubernetes service configuration
│   ├── kube_secrets.tf        # Kubernetes secrets management
│   ├── main.tf                # S3 and other resources (COMMENTED)
│   ├── variables.tf           # Terraform variables
│   ├── outputs.tf             # Terraform outputs
│   ├── eks_policy_iam.tf      # IAM roles and policies
│   ├── kubeconfig.tf          # Kubeconfig generation
│   └── *.yaml                 # Kubernetes manifests
├── docs/                      # Additional documentation
└── README.md                  # This file
```

## 🔧 Infrastructure Components

### AWS Resources (Currently Commented Out)
- **EKS Cluster**: Managed Kubernetes cluster with auto-scaling
- **IAM Roles**: Cluster and node group service roles
- **VPC Integration**: Uses existing VPC subnets
- **Load Balancer**: Application Load Balancer for ingress

### Kubernetes Resources
- **Deployment**: NestCMS application deployment (commented)
- **Service**: LoadBalancer service for external access
- **Ingress**: Ingress controller for routing
- **Secrets**: Docker registry and application secrets

### Active Components
- **IAM Policies**: EKS cluster and node policies
- **Kubeconfig**: Cluster access configuration
- **CI/CD Workflows**: GitHub Actions and CircleCI pipelines

## 🔄 CI/CD Workflows

### GitHub Actions Workflows

1. **Terraform-Plan** (`terraform-pa.yml`):
   - Triggered manually via `workflow_dispatch`
   - Provisions AWS infrastructure
   - Commits state changes back to repository

2. **Kubernetes Deployment** (`kube.yaml`):
   - Triggered after successful Terraform workflow
   - Deploys application to EKS cluster
   - Updates ingress and service configurations

3. **Terraform-Destroy** (`terraform-pd.yml`):
   - Manual cleanup workflow
   - Destroys AWS infrastructure

### CircleCI Workflow

1. **FluxCD Integration** (`.circleci/config.yml`):
   - Creates Kind cluster for testing
   - Installs FluxCD components
   - Syncs with GitOps repository
   - Deploys NestCMS application

## 🐳 Application Details

### NestCMS Application
- **Image**: `abdoelhodaky/nestcms:latest`
- **Port**: 3000
- **Resources**: 
  - Requests: 256Mi memory, 250m CPU
  - Limits: 512Mi memory, 500m CPU

### Service Configuration
- **Type**: LoadBalancer
- **External Access**: Via AWS Application Load Balancer
- **Ingress**: Configured for HTTP/HTTPS traffic

## 🔐 Security Considerations

- IAM roles follow least privilege principle
- Kubernetes secrets for sensitive data
- Docker registry authentication
- VPC security groups for network isolation

## 🛠️ Development Workflow

### 1. Infrastructure Activation
```bash
# Activate EKS cluster
cd terraform
sed -i 's|^/\*||g; s|\*/||g' cluster.tf

# Activate Kubernetes deployment
sed -i 's|^/\*||g; s|\*/||g' kube_deployment.tf

# Plan and apply
terraform plan
terraform apply
```

### 2. Application Updates
```bash
# Update container image in kube_deployment.tf
# Commit changes to trigger CI/CD pipeline
git add .
git commit -m "Update application image"
git push
```

### 3. Configuration Changes
```bash
# Update Kubernetes manifests in terraform directory
# Changes are applied through CI/CD workflows
kubectl apply -f terraform/nestcms-ingress.yaml --kubeconfig="./terraform/kubeconfig.yaml"
```

## 📊 Monitoring & Troubleshooting

### Infrastructure Validation

```bash
# Check if infrastructure is activated
grep -c "^/\*" terraform/cluster.tf  # Should return 0 if activated

# Verify Terraform state
cd terraform
terraform validate
terraform plan

# Check AWS resources
aws eks describe-cluster --name $TF_VAR_EKS_CLUSTER_NAME --region $TF_VAR_AWS_REGION
```

### Application Monitoring

```bash
# Check cluster status
kubectl get nodes --kubeconfig="./terraform/kubeconfig.yaml"

# Check application status
kubectl get pods -l app=nestcms --kubeconfig="./terraform/kubeconfig.yaml"

# Check service endpoints
kubectl get svc nestcms-loadbalancer --kubeconfig="./terraform/kubeconfig.yaml"

# View application logs
kubectl logs -l app=nestcms --kubeconfig="./terraform/kubeconfig.yaml"
```

### Common Issues & Solutions

1. **Infrastructure Not Deployed**:
   - **Issue**: Resources are commented out
   - **Solution**: Uncomment Terraform resources as shown in Quick Start

2. **EKS Cluster Access Denied**:
   - **Issue**: AWS credentials lack EKS permissions
   - **Solution**: Ensure IAM user has EKS full access policy

3. **Docker Registry Authentication**:
   - **Issue**: Cannot pull container images
   - **Solution**: Verify Docker Hub credentials and secrets

4. **FluxCD Sync Issues**:
   - **Issue**: FluxCD cannot sync with repository
   - **Solution**: Check GitHub token permissions and repository access

5. **Load Balancer Provisioning**:
   - **Issue**: External IP not assigned
   - **Solution**: Allow 5-10 minutes for AWS ALB provisioning

6. **File Extension Issues**:
   - **Issue**: Terraform doesn't recognize .ts files
   - **Solution**: Files have been renamed to .tf extensions

## 🚀 Production Deployment Guide

### Pre-Production Checklist

1. **Infrastructure Readiness**:
   - [ ] All Terraform resources uncommented
   - [ ] AWS credentials configured with proper permissions
   - [ ] VPC and subnets configured for your region
   - [ ] Domain and SSL certificates ready (if using custom domain)

2. **Security Configuration**:
   - [ ] IAM roles reviewed and minimized
   - [ ] Kubernetes secrets properly configured
   - [ ] Network security groups configured
   - [ ] Container image scanning enabled

3. **Monitoring Setup**:
   - [ ] CloudWatch logging enabled
   - [ ] Application monitoring configured
   - [ ] Alerting rules defined
   - [ ] Backup strategies implemented

### Production Deployment Steps

1. **Environment Preparation**:
   ```bash
   # Set production environment variables
   export TF_VAR_AWS_REGION="your-production-region"
   export TF_VAR_EKS_CLUSTER_NAME="production-nestcms-cluster"
   ```

2. **Infrastructure Deployment**:
   ```bash
   cd terraform
   terraform workspace new production
   terraform init
   terraform plan -out=production.tfplan
   terraform apply production.tfplan
   ```

3. **Application Deployment**:
   ```bash
   # Deploy via CI/CD or manually
   kubectl apply -f nestcms-ingress.yaml --kubeconfig="./kubeconfig.yaml"
   kubectl apply -f nestcms-lb.yaml --kubeconfig="./kubeconfig.yaml"
   ```

4. **Post-Deployment Validation**:
   ```bash
   # Verify all components
   kubectl get all --kubeconfig="./kubeconfig.yaml"
   kubectl get ingress --kubeconfig="./kubeconfig.yaml"
   
   # Test application endpoint
   curl -I http://your-load-balancer-url
   ```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `terraform plan`
5. Submit a pull request

## 📚 Additional Resources

- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [FluxCD Documentation](https://fluxcd.io/flux/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [NestCMS Application Repository](https://github.com/abdoElHodaky/Nestcms)

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**⚠️ Important Notes**:
- This repository demonstrates a production-ready DevOps pipeline template
- **Infrastructure activation is required** before deployment
- Ensure you understand AWS costs associated with running EKS clusters
- Test in development environment before production deployment
- Review and customize security settings for your specific requirements

