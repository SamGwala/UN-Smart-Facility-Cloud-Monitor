provider "aws" {
  region = "eu-north-1" #stockholm
}

# 1. EC2 Instance
resource "aws_instance" "smart_cloud_monitor" {
  ami           = "ubuntu ami " # Ubuntu ami removed 
  instance_type = "t3.micro"               
  key_name      = "un-smart-facility-key"   

  # Attached the IAM role so the "System" can talk to the instance
  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_profile.name

  tags = {
    Name        = "UN-Smart-Facility-EC2"
    Environment = "Dev"
    Owner       = "Samkelisiwe"
    Project     = "UNDP-Resilience" # project tag for better tracking
  }
}

# 2. SNS Topic
resource "aws_sns_topic" "alerts" {
  name = "cloudwatch-alerts"
}

# 3. SNS Subscription (email)
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "email_address" #email address removed
}

# 4. CloudWatch Alarm (The "System Down" Detector)
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "HighCPUAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60 # Made it a 60 to catch crashes faster (Natis booking system logic!)
  statistic           = "Average"
  threshold           = 70 # Standard threshold for a "heavy load"
  alarm_description   = "Alarm when CPU exceeds 70%"
  actions_enabled     = true

  # Reboot Automation
  alarm_actions       = [
    aws_sns_topic.alerts.arn,
    "arn:aws:automate:eu-north-1:ec2:reboot" 
  ]

  dimensions = {
    InstanceId = aws_instance.smart_cloud_monitor.id
  }
}

# 5. IAM Role 
resource "aws_iam_role" "ec2_ssm_role" {
  name = "EC2-Management-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# 6. resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# 7. resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "EC2-SSM-Profile"
  role = aws_iam_role.ec2_ssm_role.name
}

# 8. Budget 
resource "aws_budgets_budget" "cost_guard" {
  name              = "monthly-budget"
  budget_type       = "COST"
  limit_amount      = "5.0"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
}