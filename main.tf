data "archive_file" "authorizer" {
  type        = "zip"
  source_dir  = "fiap-pedidos-authorizer"
  output_path = "fiap-pedidos-authorizer.zip"

}

resource "aws_iam_policy" "authorizer" {
  name = "fiap-pedidos-authorizer"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "logs:CreateLogGroup",
          "Resource" : "arn:aws:logs:sa-east-1:${var.aws_account_id}:*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : [
            "arn:aws:logs:sa-east-1:${var.aws_account_id}:log-group:/aws/lambda/fiap-pedidos-auth:*"
          ]
        }
      ]
    }
  )

}

resource "aws_iam_role" "authorizer" {
  name = "fiap-pedidos-authorizer"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
    }
  )
  managed_policy_arns = [aws_iam_policy.authorizer.arn]
}

# create lambda authorizer
resource "aws_lambda_function" "authorizer" {
  filename         = "fiap-pedidos-authorizer.zip"
  description      = "Lambda authorizer"
  function_name    = "fiap-pedidos-authorizer"
  role             = aws_iam_role.authorizer.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.authorizer.output_base64sha256
  runtime          = "python3.11"
  timeout          = 60
  memory_size      = 128
  publish          = true
}

resource "aws_cloudwatch_log_group" "authorizer" {
  name              = "/aws/lambda/fiap-pedidos-authorizer"
  retention_in_days = 3
}

resource "aws_cloudwatch_log_stream" "name" {
    name           = "fiap-pedidos-authorizer"
    log_group_name = aws_cloudwatch_log_group.authorizer.name
}