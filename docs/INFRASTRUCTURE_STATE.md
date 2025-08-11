# Infrastructure State Documentation

## Current Infrastructure Status

This document provides detailed information about the current state of the infrastructure components and what needs to be activated for different deployment scenarios.

## 📊 Detailed Component Analysis

### Terraform Resources Status

#### 🔴 Commented Out (Requires Activation)

**1. EKS Cluster (`terraform/cluster.tf`)**
```hcl
Status: COMMENTED OUT (Lines 1-127)
Purpose: AWS EKS cluster with auto-scaling node groups
Dependencies: IAM roles, VPC subnets
Activation: Remove /* and */ comment blocks
```

**2. Kubernetes Deployment (`terraform/kube_deployment.tf`)**
```hcl
Status: COMMENTED OUT (Lines 1-55)
Purpose: NestCMS application deployment
Dependencies: EKS cluster, Docker secrets
Activation: Remove /* and */ comment blocks
```

**3. S3 Resources (`terraform/main.tf`)**
```hcl
Status: COMMENTED OUT (Lines 1-22)
Purpose: S3 bucket for file storage
Dependencies: AWS credentials
Activation: Remove /* and */ comment blocks (optional)
```

#### 🟢 Active and Ready

**1. IAM Roles and Policies (`terraform/eks_policy_iam.tf`)**
- EKS cluster service role
- EKS node group policies
- Required IAM policy attachments

**2. Kubeconfig Generation (`terraform/kubeconfig.tf`)**
- Automatic kubeconfig file generation
- Cluster endpoint configuration
- Authentication setup

**3. Kubernetes Services (`terraform/kube_service.tf`)**
- LoadBalancer service configuration
- Port mapping and selectors

**4. Kubernetes Secrets (`terraform/kube_secrets.tf`)**
- Docker registry secrets
- Application secrets management

**5. Data Sources (`terraform/datasources.tf`)**
- AWS availability zones
- VPC and subnet information

## 🚀 Activation Scenarios

### Scenario 1: Minimal Development Setup

**Activate Only:**
- Kubernetes Deployment
- Keep EKS cluster commented (use existing cluster)

**Commands:**
```bash
cd terraform
sed -i 's|^/\*||g; s|\*/||g' kube_deployment.tf
terraform plan -target=kubernetes_deployment.nestcms
```

### Scenario 2: Full AWS EKS Deployment

**Activate:**
- EKS Cluster
- Kubernetes Deployment
- Optional: S3 resources

**Commands:**
```bash
cd terraform
sed -i 's|^/\*||g; s|\*/||g' cluster.tf
sed -i 's|^/\*||g; s|\*/||g' kube_deployment.tf
# Optional: sed -i 's|^/\*||g; s|\*/||g' main.tf
terraform plan
terraform apply
```

### Scenario 3: CI/CD Pipeline Only

**Activate:**
- Keep infrastructure commented
- Use GitHub Actions or CircleCI workflows
- Deploy to existing cluster

**Commands:**
```bash
# No Terraform activation needed
# Configure CI/CD secrets and trigger workflows
```

## 🔧 Infrastructure Dependencies

### Required Before Activation

1. **AWS Configuration**
   ```bash
   export AWS_ACCESS_KEY_ID="your-access-key"
   export AWS_SECRET_ACCESS_KEY="your-secret-key"
   export AWS_DEFAULT_REGION="eu-central-1"
   ```

2. **Terraform Variables**
   ```bash
   export TF_VAR_EKS_CLUSTER_NAME="your-cluster-name"
   export TF_VAR_DOCKER_PAT="your-docker-token"
   export TF_VAR_GHCR_PAT="your-github-token"
   ```

3. **VPC and Subnets**
   - Ensure the hardcoded subnet IDs in `cluster.tf` exist in your AWS account
   - Update subnet IDs if deploying to different region/VPC

### Post-Activation Validation

1. **Terraform Validation**
   ```bash
   cd terraform
   terraform validate
   terraform plan
   ```

2. **AWS Resource Verification**
   ```bash
   aws eks describe-cluster --name $TF_VAR_EKS_CLUSTER_NAME
   aws iam list-roles --path-prefix /eks-
   ```

3. **Kubernetes Connectivity**
   ```bash
   kubectl get nodes --kubeconfig="./kubeconfig.yaml"
   kubectl get pods --all-namespaces --kubeconfig="./kubeconfig.yaml"
   ```

## 🚨 Known Issues and Limitations

### Current Infrastructure Limitations

1. **Hardcoded Subnet IDs**
   - Location: `terraform/cluster.tf` lines 35-40
   - Issue: Specific to one AWS account/region
   - Solution: Replace with data sources or variables

2. **Missing Node Group Configuration**
   - Issue: EKS cluster uses compute_config instead of managed node groups
   - Impact: May not work with all EKS versions
   - Solution: Consider updating to managed node groups

3. **No Auto Scaling Configuration**
   - Issue: Fixed node pool configuration
   - Impact: Cannot scale based on demand
   - Solution: Add cluster autoscaler configuration

4. **Limited Monitoring**
   - Issue: No CloudWatch or monitoring setup
   - Impact: Limited observability
   - Solution: Add monitoring resources

### File Naming Issues (Fixed)

1. **Incorrect Extensions**
   - ✅ Fixed: `key_pair.ts` → `key_pair.tf`
   - ✅ Fixed: `terraform.ts` → `terraform.tf`
   - ✅ Fixed: `kube_deoloyment.tf` → `kube_deployment.tf`

## 🔄 Migration Paths

### From Current State to Production

1. **Phase 1: Infrastructure Activation**
   - Uncomment EKS cluster resources
   - Update subnet IDs for your environment
   - Configure proper IAM permissions

2. **Phase 2: Security Hardening**
   - Review IAM policies for least privilege
   - Configure network security groups
   - Enable encryption at rest and in transit

3. **Phase 3: Monitoring and Logging**
   - Add CloudWatch logging
   - Configure application monitoring
   - Set up alerting rules

4. **Phase 4: High Availability**
   - Configure multi-AZ deployment
   - Add backup and disaster recovery
   - Implement auto-scaling policies

### From Template to Custom Implementation

1. **Customize Variables**
   - Update `terraform/variables.tf` with your defaults
   - Add environment-specific variable files
   - Configure backend state storage

2. **Update Network Configuration**
   - Replace hardcoded subnet IDs with data sources
   - Configure VPC if needed
   - Update security group rules

3. **Application Customization**
   - Update container image references
   - Configure application-specific secrets
   - Modify resource limits and requests

## 📋 Activation Checklist

### Pre-Activation
- [ ] AWS credentials configured
- [ ] Terraform installed and initialized
- [ ] Required environment variables set
- [ ] VPC and subnets verified
- [ ] Docker registry access configured

### During Activation
- [ ] Uncomment required Terraform resources
- [ ] Update hardcoded values for your environment
- [ ] Run `terraform validate`
- [ ] Run `terraform plan` and review changes
- [ ] Apply changes with `terraform apply`

### Post-Activation
- [ ] Verify EKS cluster is running
- [ ] Test kubectl connectivity
- [ ] Verify application deployment
- [ ] Test external access via load balancer
- [ ] Configure monitoring and alerting

## 🔍 Troubleshooting Common Activation Issues

### Issue: Terraform Plan Fails
```bash
# Check syntax
terraform validate

# Check AWS credentials
aws sts get-caller-identity

# Check variable values
terraform console
```

### Issue: EKS Cluster Creation Fails
```bash
# Check IAM permissions
aws iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::ACCOUNT:user/USERNAME \
  --action-names eks:CreateCluster

# Check subnet availability
aws ec2 describe-subnets --subnet-ids subnet-069d27f47d7e62de8
```

### Issue: Kubernetes Deployment Fails
```bash
# Check cluster status
kubectl get nodes --kubeconfig="./kubeconfig.yaml"

# Check pod status
kubectl describe pod -l app=nestcms --kubeconfig="./kubeconfig.yaml"

# Check secrets
kubectl get secrets --kubeconfig="./kubeconfig.yaml"
```

This documentation should be updated as the infrastructure evolves and new components are added or modified.

