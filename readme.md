# SonarQube Deployment via Terraform on AWS Spot Instance

This repository contains Terraform configurations to automate the deployment of an instance running **SonarQube** on AWS using cost-effective **Spot Instances**.

---

## 📋 Features

* **Cloud Provider:** Amazon Web Services (AWS)
* **Instance Type:** `t3.medium` (Spot Instance for up to 80–90% cost savings)
* **OS:** Ubuntu Server 26.04 LTS (x86_64)
* **Security Group:** Configured for inbound traffic on Port 22 (SSH) and Port 9000 (SonarQube Web UI)
* **Storage:** 20 GB `gp3` root EBS volume
* **Automated Setup:** Initialized via `sonar.sh` user-data script

---

## 🛠️ Prerequisites

Before starting, ensure you have:

1. **Terraform CLI** installed (`>= 1.0`).
2. **AWS CLI** installed and configured (`aws configure`).
3. An existing **SSH Key Pair** (`myRSAkey` or your preferred key) imported into your target AWS region.

---

## 📁 Repository Structure

```text
SonarQube-terraform/
├── ec2.tf          # Core EC2 Spot instance and Security Group definitions
├── provider.tf     # AWS provider settings
├── sonar.sh        # Bootstrapping script for SonarQube & dependencies
└── README.md       # Project documentation
```

---

## 🚀 Deployment Steps

### 1. Initialize Working Directory
Initialize provider plugins and modules:
```bash
terraform init
```

### 2. Review Execution Plan
Verify the resources that will be created:
```bash
terraform plan
```

### 3. Deploy Infrastructure
Apply the configuration to launch the AWS resources:
```bash
terraform apply -auto-approve
```

---

## 🔑 Accessing the Server

### 1. SSH into the Instance
Once deployed, grab the instance public IP from the output and run:
```bash
ssh -i /path/to/your/myRSAkey ubuntu@<YOUR_INSTANCE_PUBLIC_IP>
```

---

## 🔐 Accessing SonarQube Web Dashboard

Open your browser and navigate to:
```text
http://<YOUR_INSTANCE_PUBLIC_IP>:9000
```

### ⚠️ Initial Login Credentials

| Setting | Default Value |
| :--- | :--- |
| **Username** | `admin` |
| **Password** | `admin` |

> 📌 **Important Note:** Upon logging in for the first time with `admin` / `admin`, SonarQube will **force you to change the password** immediately before granting access to the main dashboard.

---

## 🧹 Cleanup / Teardown

To destroy all provisioned infrastructure and avoid ongoing charges:
```bash
terraform destroy -auto-approve
```
