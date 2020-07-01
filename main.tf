# Require TF version to be same as or greater than 0.12.13
terraform {
  required_version = ">=0.12.13"
  backend "s3" {
    bucket         = "ankisatte"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    #dynamodb_table = "aws-locks"
    encrypt        = true
  }
}

# Download any stable version in AWS provider of 2.36.0 or higher in 2.36 train
provider "aws" {
  region  = "us-west-2"
  version = "~> 2.36.0"
}


# Commented out until after bootstrap

# Call the seed_module to build our ADO seed info
module "bootstrap" {
  source                      = "./modules/bootstrap"
  name_of_s3_bucket           = "ankisatte"
  dynamo_db_table_name        = "aws-locks"
  iam_user_name               = "GitHubActionsIamUser"
  ado_iam_role_name           = "GitHubActionsIamRole"
  aws_iam_policy_permits_name = "GitHubActionsIamPolicyPermits"
  aws_iam_policy_assume_name  = "GitHubActionsIamPolicyAssume"
}

# Build the VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.1.0.0/16"
  instance_tenancy     = "default"

  tags = {
    Name      = "anki2"
    Terraform = "true"
  }
}



