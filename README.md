## UN Smart Facility Cloud Monitor

## Introduction
When South Africa’s NaTIS license booking system failed, thousands of citizens were stranded without access to essential services. This project demonstrates how resilient cloud monitoring and automation could prevent such failures. It aligns with the UNDP’s Smart Facilities initiative and supports the Sustainable Development Goals (SDGs).

## Project Overview
This project provisions cloud infrastructure with Terraform, monitors it with CloudWatch, automates alerts via SNS and Lambda, and documents recovery workflows. It evolves step by step from a simple EC2 instance into a production ready setup with centralized state management.

## Repository Structure
•	terraform/ → Infrastructure as Code (EC2, CloudWatch, SNS, backend config)
•	scripts/ → Automation scripts (backup, recovery, stress testing)
•	docs/ → Diagrams, screenshots, and supporting visuals
•	README.md → Case study documentation

## Architecture
Terraform → EC2 Instance → CloudWatch Metrics → CloudWatch Dashboard → CloudWatch Alarm → SNS Email → Lambda Automation → Recovery Script
[Looks like the result wasn't safe to show. Let's switch things up and try something else!]

## Project Timeline
Day 1 – Setup
•	Created AWS Free Tier account.
•	Installed AWS CLI, Terraform, and VS Code.
•	Configured AWS credentials.
•	Set up AWS Budget alert ($5 cap).
Day 2 – First Infrastructure
•	Wrote a simple Terraform file to provision one EC2 instance.
•	Ran terraform init and terraform apply.
•	Confirmed the instance was live, then destroyed it to avoid costs.
Day 3 – Monitoring
•	Enabled CloudWatch metrics for the EC2 instance (CPU, memory, network).
•	Created a CloudWatch dashboard to visualize usage.
Day 4 – Alerts
•	Added a CloudWatch alarm (CPU > 70%).
•	Configured it to send an email via SNS topic.
•	Tested by stressing the instance to trigger the alarm.
Day 5 – Automation (Workflow)
Instead of scripting, a workflow diagram was created to illustrate the automation logic:
•	CloudWatch Alarm → triggers when CPU usage is high
•	SNS Topic → receives alarm notification
•	Lambda Function → executes automation logic (stop/restart)
•	EC2 Instance → action performed (stop or restart)
[Looks like the result wasn't safe to show. Let's switch things up and try something else!]
This visual workflow demonstrates how AWS services integrate to automate responses, even without custom scripting.
Day 6 – Production Practice

## To make the project team ready, Terraform state was migrated from local storage into AWS:
•	S3 bucket → centralized storage of the terraform.tfstate file
•	Versioning enabled → rollback capability if state is corrupted
•	DynamoDB table → lock management to prevent concurrent applies
Backend Configuration
hcl
terraform {
  backend "s3" {
    bucket         = "smart-facility-terraform-state"
    key            = "global/smart-facility/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

## Why This Matters
•	Durability: State survives laptop crashes
•	Collaboration: Shared source of truth for teams
•	Safety: DynamoDB locks prevent corruption
•	Auditability: S3 versioning allows recovery
This demonstrates production ready infrastructure management, not just solo tinkering.
Day 7 – Documentation
•	Consolidated all steps into a professional README.md.
•	Added architecture diagram, workflow visuals, and backend configuration.
•	Linked project outcomes to UNDP Smart Facilities and SDGs.

## Demo Workflow
•	Backup script → S3 storage → Recovery script
•	Screenshots of CloudWatch dashboard and alarm email
•	Evidence of S3 state migration and DynamoDB lock table

## Impact
•	Supports SDG 9 (Infrastructure) and SDG 17 (Partnerships)
•	Demonstrates resilience for public services
•	Provides a repeatable learning path for cloud engineers moving from beginner to production ready practice

## Conclusion
This project demonstrates how resilient cloud infrastructure can safeguard communities against system failures. By progressing from a single EC2 instance to production ready state management, it shows the evolution from solo tinkering to team ready infrastructure management.
