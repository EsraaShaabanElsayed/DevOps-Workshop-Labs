# AWS VPC and EC2 Instance Setup with Apache Web Server

![AWS](https://img.shields.io/badge/AWS-Cloud-orange?style=flat-square&logo=amazon-aws)
![EC2](https://img.shields.io/badge/EC2-Instance-green?style=flat-square)
![Apache](https://img.shields.io/badge/Apache-Web%20Server-red?style=flat-square&logo=apache)
![Status](https://img.shields.io/badge/Status-Completed-success?style=flat-square)

## 📋 Overview

This lab demonstrates the creation of a complete AWS networking infrastructure from scratch, including VPC configuration, subnet setup, routing, and deployment of a web server on an EC2 instance.

## 🎯 Lab Objectives

- ✅ Create a Virtual Private Cloud (VPC) with custom CIDR block
- ✅ Configure public subnet with proper routing
- ✅ Set up Internet Gateway for external connectivity
- ✅ Launch and configure EC2 instance in the VPC
- ✅ Implement security groups with proper access controls
- ✅ Install and configure Apache Web Server
- ✅ Deploy a custom web page accessible via HTTP

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    AWS Region: us-east-1                 │
│                                                          │
│  ┌────────────────────────────────────────────────────┐ │
│  │  VPC: lab1-vpc (10.0.0.0/16)                       │ │
│  │                                                     │ │
│  │  ┌──────────────────────────────────────────────┐  │ │
│  │  │  Public Subnet: lab1-public-subnet           │  │ │
│  │  │  CIDR: 10.0.1.0/24                           │  │ │
│  │  │                                               │  │ │
│  │  │  ┌────────────────────────────────────┐      │  │ │
│  │  │  │  EC2 Instance: lab1-instance       │      │  │ │
│  │  │  │  - Type: t3.micro                  │      │  │ │
│  │  │  │  - OS: Amazon Linux 2023           │      │  │ │
│  │  │  │  - Public IP: 3.83.167.160         │      │  │ │
│  │  │  │  - Apache HTTP Server              │      │  │ │
│  │  │  └────────────────────────────────────┘      │  │ │
│  │  │                                               │  │ │
│  │  │  Security Group: web-sg                      │  │ │
│  │  │  - SSH (22): My IP only                      │  │ │
│  │  │  - HTTP (80): 0.0.0.0/0                      │  │ │
│  │  └──────────────────────────────────────────────┘  │ │
│  │                        │                            │ │
│  │                        │                            │ │
│  │  ┌─────────────────────▼──────────────────────┐   │ │
│  │  │  Route Table: lab1-route-table              │   │ │
│  │  │  - 10.0.0.0/16 → local                      │   │ │
│  │  │  - 0.0.0.0/0 → Internet Gateway             │   │ │
│  │  └─────────────────────┬──────────────────────┘   │ │
│  │                        │                            │ │
│  └────────────────────────┼────────────────────────────┘ │
│                           │                              │
│  ┌────────────────────────▼───────────────────────┐     │
│  │  Internet Gateway: lab1-gateway                │     │
│  └────────────────────────┬───────────────────────┘     │
└───────────────────────────┼──────────────────────────────┘
                            │
                    ────────▼────────
                      Internet
```

## 🔧 Infrastructure Components

### Network Configuration

| Component | Name | Details |
|-----------|------|---------|
| **VPC** | lab1-vpc | IPv4 CIDR: 10.0.0.0/16 |
| **Subnet** | lab1-public-subnet | IPv4 CIDR: 10.0.1.0/24, AZ: us-east-1a |
| **Internet Gateway** | lab1-gateway | Attached to lab1-vpc |
| **Route Table** | lab1-route-table | Associated with public subnet |

### Compute Resources

| Component | Details |
|-----------|---------|
| **Instance Name** | lab1-instance |
| **Instance ID** | i-027934fb5f59e29a9 |
| **Instance Type** | t3.micro |
| **AMI** | Amazon Linux 2023 |
| **Public IPv4** | 3.83.167.160 |
| **Availability Zone** | us-east-1a |

### Security Configuration

**Security Group: web-sg**

| Type | Protocol | Port | Source | Description |
|------|----------|------|--------|-------------|
| SSH | TCP | 22 | My IP | Remote administration |
| HTTP | TCP | 80 | 0.0.0.0/0 | Web server access |

## 📸 Lab Screenshots

The repository includes visual documentation of each step:

1. **Subnet Configuration** - Public subnet with 10.0.1.0/24 CIDR
2. **VPC Overview** - Complete VPC setup with 10.0.0.0/16 range
3. **Internet Gateway** - IGW attached to VPC
4. **Route Table** - Routes configured for internet access
5. **Subnet Association** - Public subnet associated with route table
6. **EC2 Instance** - Running instance in the VPC
7. **SSH Connection** - Successful connection to Amazon Linux 2023
8. **Apache Installation** - HTTP server installation process
9. **Web Server** - Custom web page successfully served

## 🚀 Step-by-Step Implementation

### Step 1: VPC Creation

```bash
# VPC Details
VPC Name: lab1-vpc
IPv4 CIDR: 10.0.0.0/16

DNS Resolution: Enabled
DNS Hostnames: Enabled
```
![alt text](<Screenshot from 2025-10-23 20-48-26.png>)
### Step 2: Subnet Configuration

```bash
# Public Subnet
Subnet Name: lab1-public-subnet
VPC: lab1-vpc
Availability Zone: us-east-1a
IPv4 CIDR: 10.0.1.0/24
Auto-assign Public IP: Enabled
```
![alt text](<Screenshot from 2025-10-23 20-48-13.png>)

### Step 3: Internet Gateway Setup

```bash
# Internet Gateway
IGW Name: lab1-gateway
State: Attached
VPC: lab1-vpc
```
![alt text](<Screenshot from 2025-10-23 20-53-42.png>)
### Step 4: Route Table Configuration

```bash
# Route Table: lab1-route-table
Destination         Target              Status
10.0.0.0/16        local               Active
0.0.0.0/0          igw-0ff6d82376fb901b6  Active

# Associated Subnet: lab1-public-subnet
```
![alt text](<Screenshot from 2025-10-23 20-56-51.png>)

### Step 5: EC2 Instance Launch

```bash
# Launch Configuration
Instance Name: lab1-instance
AMI: Amazon Linux 2023
Instance Type: t3.micro
Key Pair: lab1-key.pem
Network: lab1-vpc
Subnet: lab1-public-subnet
Security Group: web-sg
```
![alt text](<Screenshot from 2025-10-23 21-03-52.png>)
### Step 6: Security Group Rules

```bash
# Security Group: web-sg
Inbound Rules:
- Type: SSH, Port: 22, Source: My IP
- Type: HTTP, Port: 80, Source: 0.0.0.0/0

Outbound Rules:
- All traffic allowed (default)
```

### Step 7: Connect via SSH

```bash
# Change key permissions
chmod 400 lab1-key.pem

# SSH Connection
ssh -i lab1-key.pem ec2-user@3.83.167.160
```
![alt text](<Screenshot from 2025-10-23 21-07-59.png>)
### Step 8: Install Apache Web Server

```bash
# Update system packages
sudo yum update -y

# Install Apache HTTP Server
sudo yum install httpd -y

# Start Apache service
sudo systemctl start httpd

# Enable Apache to start on boot
sudo systemctl enable httpd

# Verify Apache is running
sudo systemctl status httpd
```


### Step 9: Access the Website

```
URL: http://3.83.167.160
Status: ✅ Successfully accessible
```

![alt text](<Screenshot from 2025-10-23 21-16-24.png>)



## 📊 Resource Summary

| Resource Type | Count | Details |
|---------------|-------|---------|
| VPC | 1 | 10.0.0.0/16 |
| Subnets | 1 | Public subnet |
| Internet Gateways | 1 | Attached |
| Route Tables | 1 | Custom routes |
| EC2 Instances | 1 | t3.micro |
| Security Groups | 1 | web-sg |
| Elastic IPs | 0 | Using auto-assigned public IP |

