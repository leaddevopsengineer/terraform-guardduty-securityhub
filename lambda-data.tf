
locals {
  build_dir = "${path.module}/build"
}

data "archive_file" "guardduty_invoke" {
  type        = "zip"
  output_file_mode = "0666"
  source_dir = "${path.module}/lambda/source/invoke/"
  output_path = "${local.build_dir}/guardduty-invoke.zip"
}

data "archive_file" "guardduty_unzip" {
  type        = "zip"
  output_file_mode = "0666"
  source_dir = "${path.module}/lambda/source/unzip/"
  output_path = "${local.build_dir}/guardduty-unzip.zip"
}

data "archive_file" "guardduty_record" {
  type        = "zip"
  output_file_mode = "0666"
  source_dir = "${path.module}/lambda/source/record/"
  output_path = "${local.build_dir}/guardduty-record.zip"
}

data "archive_file" "guardduty_fixhole" {
  type        = "zip"
  output_file_mode = "0666"
  source_dir = "${path.module}/lambda/source/fixhole/"
  output_path = "${local.build_dir}/guardduty-fixhole.zip"
}

data "archive_file" "guardduty_notify" {
  type        = "zip"
  output_file_mode = "0666"
  source_dir = "${path.module}/lambda/source/notify/"
  output_path = "${local.build_dir}/guardduty-notify.zip"
}

data "archive_file" "guardduty_sectest" {
  type        = "zip"
  output_file_mode = "0666"
  source_dir = "${path.module}/lambda/source/sectest/"
  output_path = "${local.build_dir}/guardduty-sectest.zip"
}