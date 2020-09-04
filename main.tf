provider "aws" {
  region = "eu-west-1"
}

locals {
  org_name = "meowtron"
  iam_policy_arn = [
            "arn:aws:iam::aws:policy/AWSLambdaFullAccess", 
            "arn:aws:iam::aws:policy/IAMFullAccess",
            "arn:aws:iam::aws:policy/AmazonS3FullAccess",
            "arn:aws:iam::aws:policy/CloudWatchFullAccess",
            "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
            "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"
            ]
}

// Create User
resource "aws_iam_user" "GitHubUser" {
  name = "GitHubUser"
}

// Access Key
resource "aws_iam_access_key" "GitHubUser" {
  user = "${aws_iam_user.GitHubUser.name}"
}

resource "aws_iam_user_policy_attachment" "attach-policy" {
  user       = aws_iam_user.GitHubUser.name
  count      = "${length(local.iam_policy_arn)}"
  policy_arn = "${local.iam_policy_arn[count.index]}"
}

module "deployment-bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket        = "${local.org_name}-deployment"
  acl           = "private"
  force_destroy = false

  versioning = {
    enabled = true
  }

  object_lock_configuration = {
    object_lock_enabled = "Enabled"
    rule = {
      default_retention = {
        mode  = "COMPLIANCE"
        years = 5
      }
    }
  }
}

module "data_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  
  bucket        = "${local.org_name}-data"
  acl           = "private"
  force_destroy = false
  
  versioning = {
    enabled = true
  } 

  object_lock_configuration = {
    object_lock_enabled = "Enabled"
    rule = {
      default_retention = {
        mode  = "COMPLIANCE"
        years = 5
      }
    }
  }
}

module "output_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  
  bucket        = "${local.org_name}-output"
  acl           = "private"
  force_destroy = false
  
  versioning = {
    enabled = true
  } 

  object_lock_configuration = {
    object_lock_enabled = "Enabled"
    rule = {
      default_retention = {
        mode  = "COMPLIANCE"
        years = 5
      }
    }
  }
}















