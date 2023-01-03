provider "aws" {
   region = var.region
}

locals {
  account_id              = data.aws_caller_identity.current.account_id
}


data "aws_region" "current" {}

data "aws_caller_identity" "current" {}