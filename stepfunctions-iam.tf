resource "aws_iam_role" "step_function_role" {
  name               = "${var.step_function_name}-role"
  assume_role_policy = file("${path.module}/policy-templates/trust/stepfunctions-trust.json")
}


resource "aws_iam_role_policy" "step_function_policy" {
  name    = "${var.step_function_name}-policy"
  role    = aws_iam_role.step_function_role.id

  policy  = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "lambda:InvokeFunction"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:lambda:us-west-2:1234567890:function:guardduty-*"
                    
      },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogDelivery",
                "logs:GetLogDelivery",
                "logs:UpdateLogDelivery",
                "logs:DeleteLogDelivery",
                "logs:ListLogDeliveries",
                "logs:PutResourcePolicy",
                "logs:DescribeResourcePolicies",
                "logs:DescribeLogGroups"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "xray:PutTraceSegments",
                "xray:PutTelemetryRecords",
                "xray:GetSamplingRules",
                "xray:GetSamplingTargets"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
  }
  EOF
}

resource "aws_iam_policy" "step_function_invoke" {
  name    = "${var.step_function_name}-invoke-policy"
  
  path = "/guardduty/"
  description = "Provides permissions for stepfunctions to invoke other workflows"

  policy  = templatefile("${path.module}/policy-templates/guardduty-invoke-stepfunctions-policy.tpl.json",
    {
      state_machine_arns = jsonencode([aws_sfn_state_machine.metadata_update.arn])
      account_id = local.account_id
      region = var.region


    })
}

resource "aws_iam_role_policy_attachment" "step_function_invoke" {
  role       = aws_iam_role.step_function_role.name
  policy_arn = aws_iam_policy.step_function_invoke.arn
}