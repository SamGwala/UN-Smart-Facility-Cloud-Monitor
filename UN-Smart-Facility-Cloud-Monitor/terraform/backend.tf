terraform {
  backend "s3" {
    bucket         = "smart-cloud-monitor-terraform-state"
    key            = "global/smart-facility/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
