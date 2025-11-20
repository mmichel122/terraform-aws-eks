# Terraform AWS EKS

Scaffolds a demo EKS cluster with a VPC, IAM roles, the control plane, and a managed node group. Default values live in `terraform.tfvars` so you can apply the stack with minimal flags.

## Files
- `main.tf` wires the VPC, IAM, EKS, and node group modules.
- `variables.tf` declares configurable inputs, including `allow_external_ips` for EKS API access and `private_subnet_cidrs` for isolated nodes.
- `terraform.tfvars` holds concrete values used by `terraform plan/apply`.
- `modules/*` contains the VPC, IAM, EKS, and node group submodules.

## Key variables
- `region`: AWS region to deploy into.
- `cluster_name`: EKS cluster name.
- `vpc_cidr` / `public_subnet_cidrs` / `private_subnet_cidrs`: CIDRs for networking (nodes live in private subnets).
- `eks_version`: Kubernetes control plane version.
- `node_instance_type`, `node_desired_size`, `node_min_size`, `node_max_size`: Node group settings.
- `tags`: Common tags map.
- `allow_external_ips`: CIDR list allowed to reach the public EKS API endpoint and the cluster API security group. Default is open, `terraform.tfvars` locks it to `2.15.193.179/32`.

## Usage
1. Update `terraform.tfvars` if you need different CIDRs, sizes, or allowed source IPs.
2. Initialize providers and modules:
   ```sh
   terraform init
   ```
3. Review the plan:
   ```sh
   terraform plan
   ```
4. Apply when ready:
   ```sh
   terraform apply
   ```
5. To change API access, edit `allow_external_ips` in `terraform.tfvars` with your CIDR list and re-apply.
6. The cluster provisions the AWS Gateway API Controller and AWS Load Balancer Controller add-ons at creation; the latter uses IRSA with the included IAM role.
