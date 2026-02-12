# Lambda Configuration
# WARNING: Test file with IaC misconfigurations

# VULN: Lambda with overly permissive execution role
resource "aws_lambda_function" "vulnerable_lambda" {
  filename         = "lambda.zip"
  function_name    = "vulnerable-processor"
  role            = aws_iam_role.lambda_exec.arn
  handler         = "index.handler"
  runtime         = "nodejs14.x"  # VULN: Outdated runtime
  
  # VULN: No VPC configuration (runs in public AWS network)
  
  # VULN: Environment variables with secrets
  environment {
    variables = {
      DB_PASSWORD     = "lambda_db_pass_123"
      API_SECRET      = "sk_live_secretkey123"
      ENCRYPTION_KEY  = "aes-256-key-here"
    }
  }
  
  # VULN: No dead letter queue configured
  # VULN: No X-Ray tracing
  # VULN: No reserved concurrency limits
  
  timeout     = 900  # VULN: Very long timeout
  memory_size = 3008 # VULN: Maximum memory (cost issue)
}

# VULN: Lambda execution role with excessive permissions
resource "aws_iam_role" "lambda_exec" {
  name = "lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# VULN: Attaching admin policy to lambda
resource "aws_iam_role_policy_attachment" "lambda_admin" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"  # VULN!
}

# VULN: Lambda function URL without auth
resource "aws_lambda_function_url" "public_url" {
  function_name      = aws_lambda_function.vulnerable_lambda.function_name
  authorization_type = "NONE"  # VULN: No authentication required
  
  # VULN: Permissive CORS
  cors {
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["*"]
  }
}

# VULN: CloudWatch logs without encryption
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/vulnerable-processor"
  retention_in_days = 0  # VULN: Infinite retention (cost & compliance)
  # VULN: No KMS encryption for logs
}

# VULN: Lambda permission allowing invocation from any source
resource "aws_lambda_permission" "public_invoke" {
  statement_id  = "AllowPublicInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.vulnerable_lambda.function_name
  principal     = "*"  # VULN: Any principal can invoke
}
