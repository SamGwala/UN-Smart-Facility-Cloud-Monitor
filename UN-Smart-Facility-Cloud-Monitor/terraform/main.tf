provider "aws" {
  region = "us-east-1"
}

# Iam role for ssm
resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-management_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

#AWS Iam role policy 
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#AWS instance profile
resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "ec2_ssm_profile"
  role = aws_iam_role.ec2_ssm_role.name
}

# Ec2 instance (no key pair- using ssm)
resource "aws_instance" "server" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_profile.name

  tags = {
    Name        = "un-smart-ec2"
    Environment = "Dev"
    Owner       = "Samkelisiwe"
    Project     = "UNDP-Resilience" #project tag for better tracking
  }
}

# SNS TOPIC
resource "aws_sns_topic" "alerts" {
  name = "alerts-topic"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "gwalajackie@gmail.com"
}

# Cloudwatch alarm
resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name          = "high-cpu-alert"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70 #threshold for heavy load
  alarm_description   = "Alarm when CPU exceeds 70%"
  actions_enabled     = true

  dimensions = {
    InstanceId = aws_instance.server.id
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}

# Budget
resource "aws_budgets_budget" "cost_budget" {
  name         = "monthly_budget"
  budget_type  = "COST"
  limit_amount = "5"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 80
    threshold_type      = "PERCENTAGE"
    notification_type   = "ACTUAL"

    subscriber_email_addresses = [
      "gwalajackie@gmail.com"
    ]
  }
}