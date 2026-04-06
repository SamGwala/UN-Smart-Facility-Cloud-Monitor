# UN Smart Facility Cloud Monitor

## 📖 Introduction
When South Africa’s NaTIS license booking system failed, thousands were stranded. This project simulates how resilient cloud monitoring could prevent such failures. It aligns with UNDP’s Smart Facilities initiative and SDGs.

## 🚀 Project Overview
This demo provisions cloud infrastructure with Terraform, monitors it with CloudWatch, automates alerts via SNS, and documents recovery workflows.

## 🗂 Repository Structure
- `terraform/` → Infrastructure as Code (EC2, CloudWatch, SNS)
- `scripts/` → Automation scripts (backup, recovery)
- `docs/` → Diagrams and screenshots
- `README.md` → Case study documentation

## 🏗 Architecture
Terraform → EC2 Instance → CloudWatch Metrics → CloudWatch Alarm → SNS Email → Automation Script

![Architecture Diagram](docs/architecture.png)

## ⚙️ Setup Instructions
1. Clone repo
2. Configure AWS CLI
3. Run `terraform init` → `terraform apply`
4. View CloudWatch dashboard
5. Trigger alarm and receive email

## 📊 Demo Workflow
- Backup script → S3 storage → Recovery script
- Screenshots of dashboard and alarm email

## 🌍 Impact
- Supports **SDG 9 (Infrastructure)** and **SDG 17 (Partnerships)**
- Demonstrates resilience for public services

## ✅ Conclusion
This project demonstrates how cloud resilience can safeguard communities and aligns with UNDP’s mission.
