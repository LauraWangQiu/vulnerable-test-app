# EC2 and Security Groups Configuration
# VULN: Open Security Groups for Checkov testing

# VULN: Security Group allows all incoming traffic (CKV_AWS_24, CKV_AWS_25)
resource "aws_security_group" "web" {
  name        = "taskmanager-web-sg"
  description = "Security group for web servers"
  vpc_id      = aws_vpc.main.id
  
  # VULN: SSH open to the world (CKV_AWS_24)
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # VULN: Should be a specific IP
  }
  
  # VULN: HTTP open (could be OK but without HTTPS)
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # VULN: Exposed DB port (CKV_AWS_23)
  ingress {
    description = "PostgreSQL"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # VULN: DB accessible from the internet
  }
  
  # VULN: Totally open egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "taskmanager-web-sg"
  }
}

# VULN: EC2 without proper IAM role
# VULN: No IMDSv2 (CKV_AWS_79)
resource "aws_instance" "web" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t3.medium"
  
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true
  
  # VULN: No metadata_options for IMDSv2 (CKV_AWS_79)
  # Should have:
  # metadata_options {
  #   http_tokens = "required"
  # }
  
  # VULN: No EBS encryption (CKV_AWS_3)
  root_block_device {
    volume_type = "gp2"
    volume_size = 20
    encrypted   = false  # VULN: Should be true
  }
  
  # VULN: User data with secrets (CKV_AWS_46)
  user_data = <<-EOF
    #!/bin/bash
    export DB_PASSWORD="SuperSecretPass123"
    export API_KEY="sk_live_xxxxx"
    docker run -e DB_PASSWORD=$DB_PASSWORD taskmanager:latest
  EOF
  
  tags = {
    Name = "taskmanager-web"
  }
}

# Basic VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "taskmanager-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "taskmanager-public"
  }
}
