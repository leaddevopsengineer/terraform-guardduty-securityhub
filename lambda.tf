



resource "aws_lambda_function" "guardduty_invoke" {
  filename         = data.archive_file.guardduty_invoke.output_path
  function_name    = "guardduty-SecurityResponse"
  role             = aws_iam_role.guardduty_invoke.arn
  handler          = "invoke.lambda_handler"
  source_code_hash = data.archive_file.guardduty_invoke.output_base64sha256
  runtime          = "python3.9"
  timeout          = 900
  memory_size      = 512

  environment {
    variables = {
      STATE_MACHINE = "arn:aws:states:${var.region}:${data.aws_caller_identity.current.account_id}:stateMachine:SecurityResponse"
    }
  }

}


resource "aws_lambda_function" "guardduty_unzip" {
  filename         = data.archive_file.guardduty_unzip.output_path
  function_name    = "guardduty-CreateDB"
  #role             = aws_iam_role.iam_for_lambda_guardduty.arn
  role              = aws_iam_role.lambda_guardduty.arn
  handler          = "createdb.lambda_handler"
  source_code_hash = data.archive_file.guardduty_unzip.output_base64sha256
  runtime          = "python3.9"
  timeout          = 900
  memory_size      = 512

  environment {
    variables = {
      STATE_MACHINE = "arn:aws:states:${var.region}:${data.aws_caller_identity.current.account_id}:stateMachine:SecurityResponse",
    }
  }


}

resource "aws_lambda_function" "guardduty_import" {
  filename         = data.archive_file.guardduty_record.output_path
  function_name    = "guardduty-record-ip-in-ddb"
  #role             = aws_iam_role.iam_for_lambda_guardduty.arn
  role              = aws_iam_role.lambda_guardduty.arn
  handler          = "record.lambda_handler"
  source_code_hash = data.archive_file.guardduty_record.output_base64sha256
  runtime          = "python3.9"
  timeout          = 900
  memory_size      = 512

  environment {
    variables = {
      STATE_MACHINE = "arn:aws:states:${var.region}:${data.aws_caller_identity.current.account_id}:stateMachine:SecurityResponse",
      ACLMETATABLE = "SecurityResponse"
    }
  }


}

resource "aws_lambda_function" "guardduty_fixhole" {
  filename         = data.archive_file.guardduty_fixhole.output_path
  function_name    = "guardduty-fixhole"
  #role             = aws_iam_role.iam_for_lambda_guardduty.arn
  role              = aws_iam_role.lambda_guardduty.arn
  handler          = "fixhole.lambda_handler"
  source_code_hash = data.archive_file.guardduty_fixhole.output_base64sha256
  runtime          = "python3.9"
  timeout          = 900
  memory_size      = 512

  environment {
    variables = {
      STATE_MACHINE = "arn:aws:states:${var.region}:${data.aws_caller_identity.current.account_id}:stateMachine:SecurityResponse",
      ACLMETATABLE = "SecurityResponse"
    }
  }


}

resource "aws_lambda_function" "guardduty_sectest" {
  filename         = data.archive_file.guardduty_sectest.output_path
  function_name    = "guardduty-sectest"
  #role             = aws_iam_role.iam_for_lambda_guardduty.arn
  role              = aws_iam_role.lambda_guardduty.arn
  handler          = "sectest.lambda_handler"
  source_code_hash = data.archive_file.guardduty_sectest.output_base64sha256
  runtime          = "python3.9"
  timeout          = 900
  memory_size      = 512

  environment {
    variables = {
      STATE_MACHINE = "arn:aws:states:${var.region}:${data.aws_caller_identity.current.account_id}:stateMachine:SecurityResponse",
      ACLMETATABLE = "SecurityResponse"
    }
  }


}


resource "aws_lambda_function" "guardduty_notify" {
  filename         = data.archive_file.guardduty_notify.output_path
  function_name    = "guardduty-notify"
  #role             = aws_iam_role.iam_for_lambda_guardduty.arn
  role              = aws_iam_role.lambda_guardduty.arn
  handler          = "notify.lambda_handler"
  source_code_hash = data.archive_file.guardduty_notify.output_base64sha256
  runtime          = "python3.9"
  timeout          = 900
  memory_size      = 512
  layers           = [ "arn:aws:lambda:us-west-2:${local.account}:layer:requests:1",]

  environment {
    variables = {
      STATE_MACHINE = "arn:aws:states:${var.region}:${data.aws_caller_identity.current.account_id}:stateMachine:SecurityResponse",
      ACLMETATABLE = "SecurityResponse"
    }
  }


}

resource "aws_cloudwatch_event_rule" "lambda" {
  name          = "GuardDuty"
  description   = "AWS GuardDuty Finding Events"

  event_pattern = "${file("${path.module}/event-pattern.json")}"

  tags = {
    Name        = "GuardDuty2Slack"
    Environment = "Prod"
    Department  = "Engineering"
    Team        = "Cloud"
    Product     = "Cloud"
    Service     = "Guard Duty"
    Owner       = "cloud@my.domain"
  }
}

resource "aws_cloudwatch_event_target" "lambda" {
  target_id = "GuardDuty"
  rule      = "${aws_cloudwatch_event_rule.lambda.name}"
  arn       = "${aws_lambda_function.guardduty_invoke.arn}"
}


resource "aws_lambda_permission" "lambda" {
  statement_id  = "GuardDuty"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.guardduty_invoke.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.lambda.arn}"
}
