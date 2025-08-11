# Terraform Infrastructure Configuration

This directory contains the Terraform configuration files for deploying the NestCMS application infrastructure on AWS EKS.

## 📁 File Structure

```
terraform/
├── README.md                    # This file
├── main.tf                     # S3 bucket resources (COMMENTED)
├── cluster.tf                  # EKS cluster configuration (COMMENTED)
├── kube_deployment.tf          # Kubernetes deployment (COMMENTED)
├── kube_service.tf            # Kubernetes service configuration
├── kube_secrets.tf            # Kubernetes secrets management
├── eks_policy_iam.tf          # IAM roles and policies
├── kubeconfig.tf              # Kubeconfig generation
├── variables.tf               # Input variables
├── outputs.tf                 # Output values
├── datasources.tf             # Data sources
├── terraform.tf               # Terraform configuration
├── key_pair.tf                # SSH key pair (if needed)
├── dynamo.tf                  # DynamoDB configuration
├── eip.tf                     # Elastic IP configuration
├── instance.tf                # EC2 instance configuration
├── .terraform.lock.hcl        # Terraform lock file
├── terraform.tfstate          # Terraform state file
├── terraform.tfstate.backup   # Terraform state backup
├── kubeconfig.yaml            # Generated kubeconfig
├── kubeconf.yaml              # Alternative kubeconfig
├── kubeconfig.tpl             # Kubeconfig template
├── nestcms-ingress.yaml       # Ingress configuration
├── nestcms-lb.yaml            # Load balancer configuration
├── role-secret.yaml           # RBAC role configuration
├── role-secret-bind.yaml      # RBAC role binding
└── ssh-key.pub                # SSH public key
```

## 🚨 Current State

**Important**: Most infrastructure resources are currently **COMMENTED OUT** and require activation before use.

### Resource Status

| File | Status | Description |
|------|--------|-------------|
| `cluster.tf` | ❌ COMMENTED | EKS cluster and node groups |
| `kube_deployment.tf` | ❌ COMMENTED | NestCMS application deployment |
| `main.tf` | ❌ COMMENTED | S3 bucket resources |
| `kube_service.tf` | ✅ ACTIVE | LoadBalancer service |
| `kube_secrets.tf` | ✅ ACTIVE | Docker and app secrets |
| `eks_policy_iam.tf` | ✅ ACTIVE | IAM roles and policies |
| `kubeconfig.tf` | ✅ ACTIVE | Kubeconfig generation |

## 🚀 Quick Start

### 1. Prerequisites

```bash
# Install required tools
terraform --version  # >= 1.0
kubectl version      # >= 1.32
aws --version        # >= 2.0

# Configure AWS credentials
aws configure
# or
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="eu-central-1"
```

### 2. Set Variables

```bash
# Required variables
export TF_VAR_EKS_CLUSTER_NAME="your-cluster-name"
export TF_VAR_DOCKER_PAT="your-docker-hub-token"
export TF_VAR_GHCR_PAT="your-github-token"
```

### 3. Activate Infrastructure (Choose One)

#### Option A: Full EKS Deployment
```bash
# Activate EKS cluster
sed -i 's|^/\*||g; s|\*/||g' cluster.tf

# Activate Kubernetes deployment
sed -i 's|^/\*||g; s|\*/||g' kube_deployment.tf

# Optional: Activate S3 resources
sed -i 's|^/\*||g; s|\*/||g' main.tf
```

#### Option B: Application Only (Existing Cluster)
```bash
# Only activate Kubernetes deployment
sed -i 's|^/\*||g; s|\*/||g' kube_deployment.tf

# Update kubeconfig.tf to point to existing cluster
```

### 4. Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Plan deployment
terraform plan -out=deployment.tfplan

# Apply configuration
terraform apply deployment.tfplan
```

### 5. Verify Deployment

```bash
# Check cluster status
kubectl get nodes --kubeconfig="./kubeconfig.yaml"

# Check application
kubectl get pods -l app=nestcms --kubeconfig="./kubeconfig.yaml"

# Get service endpoint
kubectl get svc nestcms-loadbalancer --kubeconfig="./kubeconfig.yaml"
```

## 📋 Configuration Details

### EKS Cluster Configuration (`cluster.tf`)

```hcl
# Key configuration parameters:
- Cluster Name: ${var.EKS_CLUSTER_NAME}
- Kubernetes Version: 1.33
- Authentication Mode: API
- Node Pools: general-purpose
- VPC Subnets: Hardcoded (needs customization)
```

**Important**: Update the subnet IDs in `cluster.tf` for your VPC:
```hcl
subnet_ids = [
  "subnet-069d27f47d7e62de8",  # Replace with your subnet
  "subnet-0b2694ce6b30df1d9",  # Replace with your subnet
  "subnet-0c061308d068204dd"   # Replace with your subnet
]
```

### Application Deployment (`kube_deployment.tf`)

```hcl
# Application configuration:
- Image: abdoelhodaky/nestcms:latest
- Replicas: 1
- Port: 3000
- Resources:
  - Requests: 256Mi memory, 250m CPU
  - Limits: 512Mi memory, 500m CPU
```

### IAM Configuration (`eks_policy_iam.tf`)

Configures the following IAM resources:
- EKS cluster service role
- EKS node group role
- Required policy attachments:
  - AmazonEKSClusterPolicy
  - AmazonEKSComputePolicy
  - AmazonEKSBlockStoragePolicy
  - AmazonEKSLoadBalancingPolicy
  - AmazonEKSNetworkingPolicy
  - AmazonEKSWorkerNodeMinimalPolicy
  - AmazonEC2ContainerRegistryPullOnly

## 🔧 Customization Guide

### 1. Update Network Configuration

```bash
# Get your VPC subnets
aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-your-vpc-id"

# Update cluster.tf with your subnet IDs
vim cluster.tf
```

### 2. Customize Application Configuration

```bash
# Edit deployment configuration
vim kube_deployment.tf

# Update:
# - Container image
# - Resource limits
# - Environment variables
# - Replica count
```

### 3. Configure Custom Domain

```bash
# Update ingress configuration
vim nestcms-ingress.yaml

# Add your domain and SSL configuration
```

### 4. Add Environment-Specific Variables

```bash
# Create environment-specific variable files
cat > prod.tfvars <<EOF
EKS_CLUSTER_NAME = "nestcms-production"
eks_region = "us-west-2"
times = 1
EOF

# Use with terraform plan
terraform plan -var-file="prod.tfvars"
```

## 🔍 Troubleshooting

### Common Issues

1. **Subnet Not Found Error**
   ```bash
   # Check if subnets exist in your account
   aws ec2 describe-subnets --subnet-ids subnet-069d27f47d7e62de8
   
   # Update cluster.tf with correct subnet IDs
   ```

2. **IAM Permission Denied**
   ```bash
   # Check current user permissions
   aws sts get-caller-identity
   
   # Verify EKS permissions
   aws iam simulate-principal-policy \
     --policy-source-arn $(aws sts get-caller-identity --query Arn --output text) \
     --action-names eks:CreateCluster
   ```

3. **Terraform State Issues**
   ```bash
   # Refresh state
   terraform refresh
   
   # Import existing resources if needed
   terraform import aws_eks_cluster.eks_cluster your-cluster-name
   ```

4. **Kubeconfig Issues**
   ```bash
   # Regenerate kubeconfig
   aws eks update-kubeconfig --name $TF_VAR_EKS_CLUSTER_NAME
   
   # Or use generated kubeconfig
   export KUBECONFIG=./kubeconfig.yaml
   ```

### Validation Commands

```bash
# Terraform validation
terraform validate
terraform fmt -check
terraform plan -detailed-exitcode

# AWS resource validation
aws eks describe-cluster --name $TF_VAR_EKS_CLUSTER_NAME
aws iam list-roles --path-prefix /eks-

# Kubernetes validation
kubectl get nodes --kubeconfig="./kubeconfig.yaml"
kubectl get pods --all-namespaces --kubeconfig="./kubeconfig.yaml"
```

## 🔄 State Management

### Local State (Current Setup)
- State files: `terraform.tfstate`, `terraform.tfstate.backup`
- **Warning**: Not suitable for team collaboration

### Recommended: Remote State Backend

```hcl
# Add to terraform.tf
terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "nestcms/terraform.tfstate"
    region = "eu-central-1"
    
    # Optional: DynamoDB for state locking
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```

## 📊 Resource Costs

### Estimated AWS Costs (Monthly)

| Resource | Type | Estimated Cost |
|----------|------|----------------|
| EKS Cluster | Control Plane | $73 |
| EC2 Instances | t3.medium (2 nodes) | $60 |
| Load Balancer | ALB | $20 |
| EBS Volumes | gp3 (20GB each) | $4 |
| **Total** | | **~$157/month** |

**Note**: Costs vary by region and usage. Use AWS Cost Calculator for accurate estimates.

## 🔐 Security Considerations

### Current Security Features
- IAM roles with least privilege principle
- Kubernetes secrets for sensitive data
- VPC isolation
- Security groups (default)

### Recommended Enhancements
```bash
# Enable EKS logging
aws eks update-cluster-config \
  --name $TF_VAR_EKS_CLUSTER_NAME \
  --logging '{"enable":["api","audit","authenticator","controllerManager","scheduler"]}'

# Configure network policies
kubectl apply -f network-policies.yaml

# Enable Pod Security Standards
kubectl label namespace default pod-security.kubernetes.io/enforce=restricted
```

## 📚 Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS EKS User Guide](https://docs.aws.amazon.com/eks/latest/userguide/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/)

## 🤝 Contributing

1. **Before Making Changes**:
   ```bash
   # Always plan first
   terraform plan
   
   # Validate configuration
   terraform validate
   terraform fmt
   ```

2. **Testing Changes**:
   ```bash
   # Use workspaces for testing
   terraform workspace new testing
   terraform plan -var-file="testing.tfvars"
   ```

3. **Submitting Changes**:
   - Include terraform plan output in PR
   - Document any breaking changes
   - Update this README if needed

---

**⚠️ Important**: Always review terraform plan output before applying changes in production environments.

