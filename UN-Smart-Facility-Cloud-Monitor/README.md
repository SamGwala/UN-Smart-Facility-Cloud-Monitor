
## UN Smart Facility Cloud Monitor

## Introduction
When South Africa’s NaTIS license booking system failed, thousands of citizens were stranded without access to essential services. This project demonstrates how resilient cloud monitoring and automation could prevent such failures. It aligns with the UNDP’s Smart Facilities initiative and supports the Sustainable Development Goals (SDGs).

## Project Overview
This project provisions cloud infrastructure with Terraform, monitors it with CloudWatch, automates alerts via SNS and native AWS actions, and documents recovery workflows. It evolves step by step from a simple EC2 instance into a production-ready setup with centralized state management.

## Repository Structure
• terraform/ → Infrastructure as Code (EC2, CloudWatch, SNS, backend config)
• docs/ → Diagrams, screenshots, and supporting visuals
• README.md → Case study documentation

## Architecture
Terraform → EC2 Instance → CloudWatch Metrics → CloudWatch Dashboard → CloudWatch Alarm → SNS Email → EC2 Auto-Reboot Action

## Project Timeline

Day 1 – Setup
• Created AWS Free Tier account.
• Installed AWS CLI, Terraform, and VS Code.
• Configured AWS Budget alert ($5 cap) to ensure fiscal responsibility with donor funds.

Day 2 – First Infrastructure
• Provisioned one EC2 instance using Terraform.
• Attached an IAM Instance Profile to allow secure, scriptless management via AWS Systems Manager (SSM).

Day 3 – Monitoring
• Enabled CloudWatch metrics and created a dashboard to visualize CPU and Network usage.

Day 4 – Alerts (Passive Monitoring)
• Added a CloudWatch alarm (CPU > 70%).
• Configured it to send an email via SNS topic.
• The Limitation ??  At this stage, the system can detect a crash, but a developer would still have to wake up at 1 AM to fix it manually.

Day 5 – Automation (Active Self-Healing)
In Day 5, we move from just "talking" to SNS to "talking" to the AWS EC2 Reboot API.
• How? By linking the CloudWatch alarm to a native AWS action.
• How does this help us? If the threshold exceeds 70%, the system self-heals by triggering an automatic reboot. 

## Technical Justification: Why Reboot? 
While other options exist horizontal scaling (Auto Scaling) being a common solution, I chose Automated Rebooting as the primary self-healing mechanism for this UNDP project. This solution was chosen as the most "Sustainable" choice for a UNDP projec because of the following reasons: 
Cost Sustainability:  Unlike Auto Scaling (which doubles costs by launching new servers), rebooting fixes the existing server for free, staying under our $5 budget. A reboot addresses software-level crashes—the primary cause of NaTIS-style failures.

## What happens if rebooting doesn't fix it? 
The reboot is the first line of defense to clear stuck processes. If it fails again, the alarm will stay 'In Alarm' state, and the developer will see the email to perform a deeper investigation. However it is important to bare in mind that if the high CPU usage is caused by a permanent bug (like a corrupted database) the server will reboot, start at that bad script again and hit 70% CPU immediately. This is called a crash loop. 

## Self-Healing Logic
A reboot clears stale process it flushes the network stack (TCP connections), and releases file locks that cause system deadlocks.

## Day 6 – Production Practice
To make the project team-ready, Terraform state was migrated from local storage into AWS:
• S3 bucket → Centralized storage of the state file.
• Versioning → Rollback capability for safety.
• DynamoDB table → Lock management to prevent concurrent applies (essential for international teams).

Backend Configuration:
```hcl
terraform {
  backend "s3" {
    bucket         = "smart-facility-terraform-state"
    key            = "global/smart-facility/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

## Day 7 – Documentation
• Consolidated all steps into this README.md.
• Linked project outcomes to UNDP Smart Facilities and SDGs.

## Impact
• Supports SDG 9 (Infrastructure) and SDG 17 (Partnerships).
• Demonstrates that "The System is Down" is a solvable engineering problem.
• Bridges the gap between basic IT Support and professional Cloud Engineering.

## Conclusion
Beyond "The System is Down"
This project is more than a technical exercise it is a blueprint for Operational Resilience in public service delivery. By analyzing the systemic failures of high-volume platforms like NaTIS, I have demonstrated that many service outages are not inevitable they are engineering challenges that can be solved through Automation and Governance.

Through this 7-day evolution, I have implemented a system that:
A system that SELF HEALS using native AWS actions to clear defunct or stale processes and restore service in minutes, not hours. At a cost effective mannerby utilizing AWS Budgets to ensure that high tech resilience does not come at an unsustainable cost to donor-funded projects.It also implements a secure S3/DynamoDB backend that allows international teams to collaborate without the risk of infrastructure conflict.

By moving from "solo tinkering" to a Production-Ready environment, this project proves that even with a limited budget, we can build cloud infrastructure that is robust enough to safeguard community access to essential services. In the modern era, a resilient cloud is not a luxury—it is a pillar of stable governance.