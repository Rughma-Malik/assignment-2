# Assignment 2 – Advanced Terraform & Nginx Multi-Tier Architecture

---
## 1. Project Overview
This project demonstrates the deployment of a **secure, highly available, multi-tier web infrastructure** on AWS using **Terraform**.  
The architecture includes an **Nginx reverse proxy/load balancer** and **three backend web servers**, where two servers handle primary traffic and one acts as a **backup server**.

The system supports:
- Load balancing
- HTTPS with self-signed SSL
- Caching
- High availability (failover)
- Infrastructure as Code (IaC)


### Architecture Diagram

```text
┌─────────────────────────────────────────────────┐
│                  Internet                       │
└─────────────────┬───────────────────────────────┘
                  │
                  │ HTTPS (443) / HTTP (80)
                  ▼
         ┌────────────────────┐
         │   Nginx Server     │
         │  (Load Balancer)   │
         │   - SSL/TLS        │
         │   - Caching        │
         │   - Reverse Proxy  │
         └────────┬───────────┘
                  │
      ┌───────────┼───────────┐
      │           │           │
      ▼           ▼           ▼
   ┌─────┐     ┌─────┐     ┌─────┐
   │Web-1│     │Web-2│     │Web-3│
   │     │     │     │     │(BKP)│
   └─────┘     └─────┘     └─────┘
   Primary     Primary     Backup
   (Active)    (Active)   (Passive)

```
### Components Description

#### - Networking
- Custom VPC
- Public Subnet
- Internet Gateway
- Route Table with internet access

#### - Nginx Server
- Acts as reverse proxy and load balancer
- Handles HTTPS termination
- Implements caching
- Forwards traffic to backend servers

#### - Backend Servers
- **web-1**: Primary backend
- **web-2**: Primary backend
- **web-3**: Backup backend (only used on failure)

---

## 2. Prerequisites

### Required Tools
- AWS Account
- Terraform (v1.0+)
- AWS CLI
- Git
- SSH Client (OpenSSH / Git Bash)

### AWS Credentials Setup
```bash
aws configure
```
Provide the following details when prompted:

- AWS Access Key

- AWS Secret Key

- Default region (e.g., us-east-1)

- Output format (e.g., json)

### SSH Key Setup

Generate an SSH key pair if it does not already exist:
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/terraform_key
```

---

## 3. Deployment Instructions
### Step-by-Step Guide
Clone the Repository
```bash
git clone <repository-url>
cd Assignment2
```
Initialize Terraform
```bash
terraform init
```
Validate Configuration
```bash
terraform validate
```
Review Execution Plan
```bash
terraform plan
```
Deploy Infrastructure
```bash
terraform apply -auto-approve
```
### Variable Configuration

Variables can be customized in variables.tf or terraform.tfvars, including:

- AWS region

- EC2 instance type

- SSH key pair name

- VPC and subnet CIDR blocks
---
## 4. Configuration Guide

### Updating Backend IPs in Nginx
```bash
SSH into the Nginx Server
ssh ec2-user@<nginx-public-ip>
```
Edit Nginx Configuration
```bash
sudo vim /etc/nginx/nginx.conf
```
Update the Upstream Block
```bash
upstream backend_servers {
    server <web-1-private-ip>:80;
    server <web-2-private-ip>:80;
    server <web-3-private-ip>:80 backup;
}
```
Test and Restart Nginx
```bash
sudo nginx -t
sudo systemctl restart nginx
```
### Testing Procedures

**Load Balancing Test**

- Open browser: `https://<nginx-public-ip>`

- Refresh the page multiple times

- Verify responses alternate between `web-1` and `web-2`

**Cache Test**

- Open Developer Tools (F12) → Network

- First request header:
```bash
X-Cache-Status: MISS
```

- Reload page and verify:
```bash
X-Cache-Status: HIT
```
**High Availability Test**

- Stop Apache on `web-1` and `web-2`

- Verify web-3 serves traffic (backup activated)

- Restart services on all servers
---
## 5. Architecture Details
### Network Topology

- Single VPC

- Public subnet hosting all EC2 instances

- Internet Gateway for external access

### Security Groups
#### Nginx Security Group

- Allow HTTP (80)

- Allow HTTPS (443)

- Allow SSH (22)

#### Backend Security Group

- Allow HTTP (80) from Nginx only

- Allow SSH (22)

### Load Balancing Strategy

- Round-robin load balancing between web-1 and web-2

- web-3 configured as a backup server

- Automatic failover handled by Nginx
---
## 6. Troubleshooting
### Common Issues & Solutions

**AWS Credentials Error**
```bash
aws configure
aws sts get-caller-identity
```

**Connection Refused (SSH)**
- specific key path: 
```bash
ssh -i <path> ec2-user@<ip>. 
```
- Check Security Group rules.

**Terraform Error (AZ)**
- Ensure `availability_zone` in `terraform.tfvars` matches the provider region `(e.g., me-central-1a)`.

**Nginx Not Forwarding Traffic**

- Verify backend private IPs

- Test configuration:
```bash
sudo nginx -t
```
**Log Locations**
- Nginx Logs
```bash
/var/log/nginx/access.log
/var/log/nginx/error.log
```
### Debug Commands
```bash
sudo nginx -t
sudo systemctl status nginx
sudo systemctl status httpd
sudo tail -f /var/log/nginx/error.log
ps aux | grep nginx
```