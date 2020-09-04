provider "aws" {
  region = "eu-west-1"
}

locals {
  org_name     =  "meowtron"
}

resource "aws_iam_user" "GitHubUser" {
  name = "GitHubUser"
}

resource "aws_iam_access_key" "GitHubUser" {
  user = "${aws_iam_user.GitHubUser.name}"
}

data "template_file" "policy" {
  template = "${file("${path.module}/policy.json")}"

  vars = {
    org_name = "${local.org_name}"
  }
}

resource "aws_iam_user_policy" "GitHubUser_assume_role" {
  name = "InstanceManagePolicy"
  user = "${aws_iam_user.GitHubUser.name}"

  policy = "${data.template_file.policy.rendered}"
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















