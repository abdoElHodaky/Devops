# Comprehensive Deployment Guide

This guide provides step-by-step instructions for deploying the NestCMS application using the DevOps infrastructure in this repository.

## 🎯 Deployment Options Overview

| Option | Use Case | Complexity | Time to Deploy |
|--------|----------|------------|----------------|
| **Local Kind + FluxCD** | Development/Testing | Low | 10-15 minutes |
| **Existing EKS Cluster** | Quick deployment | Medium | 15-20 minutes |
| **Full AWS EKS Setup** | Production | High | 30-45 minutes |
| **CI/CD Pipeline** | Automated deployment | Medium | 20-30 minutes |

## 🚀 Option 1: Local Development with Kind + FluxCD

Perfect for development and testing without AWS costs.

### Prerequisites
- Docker installed
- kubectl installed
- FluxCD CLI installed
- GitHub token with repo access

### Step-by-Step Deployment

1. **Setup Kind Cluster**
   ```bash
   # Install Kind if not already installed
   curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-amd64
   chmod +x ./kind
   sudo mv ./kind /usr/local/bin/kind
   
   # Create cluster
   kind create cluster --name nestcms-dev
   kubectl config set-context kind-nestcms-dev
   ```

2. **Install FluxCD**
   ```bash
   # Install FluxCD components
   flux install
   
   # Verify installation
   flux check
   ```

3. **Configure FluxCD Source**
   ```bash
   # Create GitHub source
   flux create source git fluxcd-source \
     --url=https://github.com/abdoElHodaky/Fluxcd \
     --branch=main \
     --interval=1m
   
   # Create kustomization
   flux create kustomization nestcms \
     --target-namespace=default \
     --source=fluxcd-source \
     --path="./clusters/fluxcd" \
     --prune=true \
     --interval=5m
   ```

4. **Deploy Application**
   ```bash
   # Apply secrets (create these files first)
   kubectl apply -f - <<EOF
   apiVersion: v1
   kind: Secret
   metadata:
     name: nestcms-secrets
   type: Opaque
   stringData:
     MONGO_URI: "mongodb://localhost:27017/nestcms"
     JWT_SECRET: "your-jwt-secret-here"
   EOF
   
   # Trigger reconciliation
   flux reconcile kustomization nestcms
   
   # Check deployment status
   kubectl get pods -l app=nestcms
   ```

5. **Access Application**
   ```bash
   # Port forward to access locally
   kubectl port-forward svc/nestcms-service 3000:3000
   
   # Open browser to http://localhost:3000
   ```

### Validation Steps
```bash
# Check all resources
kubectl get all -l app=nestcms

# Check logs
kubectl logs -l app=nestcms --tail=50

# Check FluxCD status
flux get kustomizations
flux get sources git
```

## 🏗️ Option 2: Deploy to Existing EKS Cluster

Use this option if you already have an EKS cluster running.

### Prerequisites
- Existing EKS cluster
- kubectl configured for your cluster
- AWS CLI configured
- Docker registry access

### Step-by-Step Deployment

1. **Verify Cluster Access**
   ```bash
   # Check cluster connectivity
   kubectl get nodes
   kubectl get namespaces
   
   # Verify you have admin access
   kubectl auth can-i create deployments
   ```

2. **Create Namespace and Secrets**
   ```bash
   # Create namespace
   kubectl create namespace nestcms
   
   # Create Docker registry secret
   kubectl create secret docker-registry dockersecret \
     --docker-username=your-username \
     --docker-password=your-token \
     --docker-email=your-email \
     --namespace=nestcms
   
   # Create application secrets
   kubectl create secret generic nestcms-secrets \
     --from-literal=MONGO_URI="your-mongodb-connection-string" \
     --from-literal=JWT_SECRET="your-jwt-secret" \
     --namespace=nestcms
   ```

3. **Deploy Application**
   ```bash
   # Apply Kubernetes manifests
   kubectl apply -f - <<EOF
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: nestcms
     namespace: nestcms
     labels:
       app: nestcms
   spec:
     replicas: 2
     selector:
       matchLabels:
         app: nestcms
     template:
       metadata:
         labels:
           app: nestcms
       spec:
         imagePullSecrets:
         - name: dockersecret
         containers:
         - name: nestcms
           image: abdoelhodaky/nestcms:latest
           ports:
           - containerPort: 3000
           env:
           - name: MONGO_URI
             valueFrom:
               secretKeyRef:
                 name: nestcms-secrets
                 key: MONGO_URI
           - name: JWT_SECRET
             valueFrom:
               secretKeyRef:
                 name: nestcms-secrets
                 key: JWT_SECRET
           resources:
             requests:
               memory: "256Mi"
               cpu: "250m"
             limits:
               memory: "512Mi"
               cpu: "500m"
           livenessProbe:
             httpGet:
               path: /health
               port: 3000
             initialDelaySeconds: 30
             periodSeconds: 10
           readinessProbe:
             httpGet:
               path: /health
               port: 3000
             initialDelaySeconds: 5
             periodSeconds: 5
   ---
   apiVersion: v1
   kind: Service
   metadata:
     name: nestcms-service
     namespace: nestcms
   spec:
     selector:
       app: nestcms
     ports:
     - port: 80
       targetPort: 3000
     type: LoadBalancer
   EOF
   ```

4. **Configure Ingress (Optional)**
   ```bash
   # Apply ingress configuration
   kubectl apply -f terraform/nestcms-ingress.yaml
   
   # Get ingress IP
   kubectl get ingress -n nestcms
   ```

### Validation Steps
```bash
# Check deployment status
kubectl get deployments -n nestcms
kubectl get pods -n nestcms
kubectl get services -n nestcms

# Check application logs
kubectl logs -l app=nestcms -n nestcms --tail=50

# Get external IP
kubectl get svc nestcms-service -n nestcms
```

## ☁️ Option 3: Full AWS EKS Infrastructure Deployment

Complete infrastructure setup from scratch.

### Prerequisites
- AWS CLI configured with admin permissions
- Terraform installed
- kubectl installed
- Domain name (optional, for custom ingress)

### Step-by-Step Deployment

1. **Prepare Infrastructure**
   ```bash
   # Clone and navigate to repository
   git clone https://github.com/abdoElHodaky/Devops.git
   cd Devops
   
   # Activate infrastructure components
   cd terraform
   sed -i 's|^/\*||g; s|\*/||g' cluster.tf
   sed -i 's|^/\*||g; s|\*/||g' kube_deployment.tf
   ```

2. **Configure Variables**
   ```bash
   # Set required environment variables
   export TF_VAR_EKS_CLUSTER_NAME="nestcms-production"
   export TF_VAR_DOCKER_PAT="your-docker-hub-token"
   export TF_VAR_GHCR_PAT="your-github-token"
   export AWS_REGION="eu-central-1"
   ```

3. **Update Network Configuration**
   ```bash
   # Update subnet IDs in cluster.tf for your VPC
   # Replace the hardcoded subnet IDs with your own:
   vim cluster.tf
   
   # Find and update these lines (around line 35-40):
   subnet_ids = [
     "subnet-your-subnet-1",
     "subnet-your-subnet-2", 
     "subnet-your-subnet-3"
   ]
   ```

4. **Deploy Infrastructure**
   ```bash
   # Initialize Terraform
   terraform init
   
   # Plan deployment
   terraform plan -out=nestcms.tfplan
   
   # Review the plan carefully, then apply
   terraform apply nestcms.tfplan
   ```

5. **Verify Deployment**
   ```bash
   # Check EKS cluster
   aws eks describe-cluster --name $TF_VAR_EKS_CLUSTER_NAME
   
   # Test kubectl connectivity
   kubectl get nodes --kubeconfig="./kubeconfig.yaml"
   
   # Check application deployment
   kubectl get pods -l app=nestcms --kubeconfig="./kubeconfig.yaml"
   ```

6. **Configure External Access**
   ```bash
   # Get load balancer URL
   kubectl get svc nestcms-loadbalancer --kubeconfig="./kubeconfig.yaml"
   
   # Apply ingress if using custom domain
   kubectl apply -f nestcms-ingress.yaml --kubeconfig="./kubeconfig.yaml"
   ```

### Post-Deployment Configuration

1. **Configure DNS (if using custom domain)**
   ```bash
   # Get ALB DNS name
   kubectl get ingress nestcms-ingress --kubeconfig="./kubeconfig.yaml"
   
   # Create CNAME record pointing your domain to ALB DNS name
   ```

2. **Configure SSL/TLS**
   ```bash
   # Install cert-manager
   kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml --kubeconfig="./kubeconfig.yaml"
   
   # Configure Let's Encrypt issuer
   kubectl apply -f - <<EOF
   apiVersion: cert-manager.io/v1
   kind: ClusterIssuer
   metadata:
     name: letsencrypt-prod
   spec:
     acme:
       server: https://acme-v02.api.letsencrypt.org/directory
       email: your-email@example.com
       privateKeySecretRef:
         name: letsencrypt-prod
       solvers:
       - http01:
           ingress:
             class: alb
   EOF
   ```

## 🔄 Option 4: CI/CD Pipeline Deployment

Automated deployment using GitHub Actions or CircleCI.

### GitHub Actions Deployment

1. **Configure Repository Secrets**
   Go to your GitHub repository → Settings → Secrets and add:
   ```
   TF_VAR_AWS_ACCESS_KEY: your-aws-access-key
   TF_VAR_AWS_ACCESS_SECRET: your-aws-secret-key
   TF_VAR_AWS_REGION: eu-central-1
   TF_VAR_EKS_CLUSTER_NAME: your-cluster-name
   TF_VAR_DOCKER_PAT: your-docker-token
   TF_VAR_GHCR_PAT: your-github-token
   ```

2. **Activate Infrastructure**
   ```bash
   # Uncomment Terraform resources
   sed -i 's|^/\*||g; s|\*/||g' terraform/cluster.tf
   sed -i 's|^/\*||g; s|\*/||g' terraform/kube_deployment.tf
   
   # Commit and push
   git add .
   git commit -m "Activate infrastructure for CI/CD deployment"
   git push
   ```

3. **Trigger Deployment**
   - Go to GitHub Actions tab
   - Run "Terraform-Plan" workflow manually
   - Monitor the workflow execution
   - The "kube" workflow will trigger automatically after success

4. **Monitor Deployment**
   ```bash
   # Check workflow status in GitHub Actions
   # Once complete, verify deployment
   aws eks update-kubeconfig --name $TF_VAR_EKS_CLUSTER_NAME
   kubectl get pods -l app=nestcms
   ```

### CircleCI + FluxCD Deployment

1. **Configure CircleCI Environment**
   In CircleCI project settings, add environment variables:
   ```
   GITHUB_TOKEN: your-github-token-with-repo-access
   ```

2. **Trigger Pipeline**
   ```bash
   # Push changes to trigger CircleCI
   git add .
   git commit -m "Trigger CircleCI deployment"
   git push
   ```

3. **Monitor FluxCD Deployment**
   ```bash
   # The pipeline will create a Kind cluster and deploy via FluxCD
   # Monitor in CircleCI dashboard
   # Check FluxCD repository for sync status
   ```

## 🔍 Troubleshooting Common Issues

### Issue: EKS Cluster Creation Fails

**Symptoms:**
- Terraform apply fails with IAM permission errors
- Cluster creation times out

**Solutions:**
```bash
# Check AWS credentials
aws sts get-caller-identity

# Verify IAM permissions
aws iam simulate-principal-policy \
  --policy-source-arn $(aws sts get-caller-identity --query Arn --output text) \
  --action-names eks:CreateCluster eks:DescribeCluster

# Check VPC and subnet configuration
aws ec2 describe-subnets --subnet-ids subnet-069d27f47d7e62de8
```

### Issue: Application Pods Not Starting

**Symptoms:**
- Pods stuck in Pending or ImagePullBackOff state
- Container cannot be pulled

**Solutions:**
```bash
# Check pod status
kubectl describe pod -l app=nestcms --kubeconfig="./kubeconfig.yaml"

# Verify Docker registry secret
kubectl get secrets --kubeconfig="./kubeconfig.yaml"

# Check image availability
docker pull abdoelhodaky/nestcms:latest

# Recreate Docker secret if needed
kubectl delete secret dockersecret --kubeconfig="./kubeconfig.yaml"
kubectl create secret docker-registry dockersecret \
  --docker-username=abdoelhodaky \
  --docker-password=$TF_VAR_DOCKER_PAT \
  --kubeconfig="./kubeconfig.yaml"
```

### Issue: Load Balancer Not Accessible

**Symptoms:**
- Service has no external IP
- Cannot access application from internet

**Solutions:**
```bash
# Check service status
kubectl get svc nestcms-loadbalancer --kubeconfig="./kubeconfig.yaml"

# Check AWS load balancer
aws elbv2 describe-load-balancers

# Check security groups
aws ec2 describe-security-groups --group-names default

# Verify ingress controller
kubectl get pods -n kube-system --kubeconfig="./kubeconfig.yaml"
```

### Issue: FluxCD Sync Failures

**Symptoms:**
- FluxCD cannot sync with repository
- Kustomization fails to apply

**Solutions:**
```bash
# Check FluxCD status
flux get sources git
flux get kustomizations

# Check GitHub token permissions
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user

# Manually trigger sync
flux reconcile source git fluxcd-source
flux reconcile kustomization nestcms

# Check FluxCD logs
kubectl logs -n flux-system -l app=source-controller
```

## 📊 Deployment Validation Checklist

### Infrastructure Validation
- [ ] EKS cluster is running and accessible
- [ ] Node groups are healthy and ready
- [ ] VPC and networking configured correctly
- [ ] IAM roles and policies applied
- [ ] Load balancer provisioned successfully

### Application Validation
- [ ] Pods are running and ready
- [ ] Services are accessible internally
- [ ] External load balancer has public IP
- [ ] Application responds to health checks
- [ ] Database connectivity working

### Security Validation
- [ ] Secrets are properly configured
- [ ] RBAC permissions are minimal
- [ ] Network policies applied (if configured)
- [ ] SSL/TLS certificates valid (if configured)
- [ ] Container images scanned for vulnerabilities

### Performance Validation
- [ ] Resource limits and requests configured
- [ ] Horizontal Pod Autoscaler working
- [ ] Load balancer health checks passing
- [ ] Application performance acceptable
- [ ] Monitoring and logging configured

## 🚀 Next Steps After Deployment

1. **Configure Monitoring**
   - Set up CloudWatch logging
   - Configure application metrics
   - Set up alerting rules

2. **Implement Backup Strategy**
   - Database backups
   - Configuration backups
   - Disaster recovery procedures

3. **Security Hardening**
   - Network policies
   - Pod security policies
   - Regular security scans

4. **Performance Optimization**
   - Resource tuning
   - Caching strategies
   - CDN configuration

5. **Documentation**
   - Update runbooks
   - Document custom configurations
   - Create troubleshooting guides

This deployment guide should be updated as new features are added or deployment procedures change.

