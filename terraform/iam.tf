# IAM Configuration
# WARNING: Test file with IaC misconfigurations

# VULN: Overly permissive IAM policy - allows all actions
resource "aws_iam_policy" "admin_policy" {
  name        = "admin-full-access"
  description = "Full admin access - INSECURE"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # VULN: Wildcard permissions
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })
}

# VULN: IAM role with assume role from any AWS account
resource "aws_iam_role" "vulnerable_role" {
  name = "vulnerable-cross-account-role"

  # VULN: Trust policy allows any AWS account
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# VULN: IAM user with inline policy (should use managed policies)
resource "aws_iam_user" "admin_user" {
  name = "admin-user"
  
  # VULN: No MFA enforcement
  force_destroy = true
}

# VULN: Inline policy attached directly to user
resource "aws_iam_user_policy" "admin_inline" {
  name = "admin-inline-policy"
  user = aws_iam_user.admin_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "ec2:*",
          "iam:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# VULN: Access key stored insecurely
resource "aws_iam_access_key" "admin_key" {
  user = aws_iam_user.admin_user.name
  # VULN: No PGP key for encryption
}

# VULN: Group with excessive permissions
resource "aws_iam_group" "developers" {
  name = "developers"
}

resource "aws_iam_group_policy" "developer_policy" {
  name  = "developer-policy"
  group = aws_iam_group.developers.name

  # VULN: Developers shouldn't have IAM permissions
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:CreateUser",
          "iam:DeleteUser",
          "iam:CreateAccessKey"
        ]
        Resource = "*"
      }
    ]
  })
}
