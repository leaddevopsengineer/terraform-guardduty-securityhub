# Testing the vscode container workflow

provider "aws" {
   region = var.region
}

locals {
  account_id              = data.aws_caller_identity.current.account_id
  account                 = "1234567890"
}


data "aws_region" "current" {}

data "aws_caller_identity" "current" {}


