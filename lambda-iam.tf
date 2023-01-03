

############################################################
# lambda role to invoke guardduty workflow step functions
############################################################

resource "aws_iam_role" "guardduty_invoke" {
  name = "guardduty-invoke-lambda-role"
  path = "/guardduty/"

  assume_role_policy = file("${path.module}/policy-templates/trust/lambda-trust.json")
}


resource "aws_iam_role_policy_attachment" "guardduty_invoke_AWSLambdaBasicExecutionRole" {
  role = aws_iam_role.guardduty_invoke.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "guardduty_invoke" {
  name    = "guardduty-invoke-policy"
  
  path = "/guardduty/"
  description = "Provides permissions for lambda to invoke the main workflow"

  policy  = templatefile("${path.module}/policy-templates/guardduty-invoke-stepfunctions-policy.tpl.json",
    {
      state_machine_arns = jsonencode([aws_sfn_state_machine.main.arn])
      account_id = local.account_id
      region = var.region


    })
}

resource "aws_iam_role_policy_attachment" "guardduty_invoke" {
  role       = aws_iam_role.guardduty_invoke.name
  policy_arn = aws_iam_policy.guardduty_invoke.arn
}


############################################################
# Base lambda role for guardduty workflow lambda functions
############################################################
resource "aws_iam_role" "lambda_guardduty" {
  name = "guardduty-lambda-execution-role"
  #path = "/guardduty/"

  assume_role_policy = file("${path.module}/policy-templates/trust/lambda-trust.json")
}

# resource "aws_iam_role_policy_attachment" "lambda_guardduty_AWSLambdaBasicExecutionRole" {
#   role = aws_iam_role.lambda_guardduty.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }

resource "aws_iam_policy" "lambda_guardduty_client_assume" {
  name    = "guardduty-lambda-client-assume-policy"
  
  path = "/guardduty/"
  description = "Provides permissions for lambda to assume client roles"

  policy  = templatefile("${path.module}/policy-templates/guardduty-lambda-client-assume-policy.tpl.json",
    {
      account_id = local.account_id

    })
}



resource "aws_iam_role_policy_attachment" "lambda_guardduty_client_assume" {
  role       = aws_iam_role.lambda_guardduty.name
  policy_arn = aws_iam_policy.lambda_guardduty_client_assume.arn
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
    role       = aws_iam_role.lambda_guardduty.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "AmazonDynamoDBFullAccess" {
    role       = aws_iam_role.lambda_guardduty.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "AWSSQSAccess" {
    role       = aws_iam_role.lambda_guardduty.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}


resource "aws_iam_role_policy_attachment" "AWSSQSAccessInvoke" {
    role       = aws_iam_role.guardduty_invoke.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2FullAccess" {
    role       = aws_iam_role.lambda_guardduty.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

