# RDS Database Configuration
# VULN: Misconfigured database for Checkov testing

# VULN: RDS without encryption (CKV_AWS_16)
# VULN: RDS publicly accessible (CKV_AWS_17)
# VULN: No backup enabled (CKV_AWS_133)
resource "aws_db_instance" "postgres" {
  identifier        = "taskmanager-db"
  engine            = "postgres"
  engine_version    = "13.4"
  instance_class    = "db.t3.medium"
  allocated_storage = 20
  
  db_name  = "taskmanager"
  username = "admin"
  password = var.db_password  # VULN: Password in variable with default
  
  # VULN: SG allows access from any IP
  vpc_security_group_ids = [aws_security_group.web.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  
  # VULN: Publicly accessible (CKV_AWS_17)
  publicly_accessible = true  # VULN: Should be false
  
  # VULN: No encryption (CKV_AWS_16)
  storage_encrypted = false  # VULN: Should be true
  
  # VULN: No backup (CKV_AWS_133)
  backup_retention_period = 0  # VULN: Should be >= 7
  
  # VULN: No deletion protection (CKV_AWS_162)
  deletion_protection = false  # VULN: Should be true in prod
  
  # VULN: No logging enabled (CKV_AWS_129)
  # enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  
  # VULN: No auto minor version upgrade
  auto_minor_version_upgrade = false
  
  skip_final_snapshot = true
  
  tags = {
    Name = "taskmanager-database"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "taskmanager-db-subnet"
  subnet_ids = [aws_subnet.public.id, aws_subnet.private.id]
  
  tags = {
    Name = "TaskManager DB Subnet Group"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"
  
  tags = {
    Name = "taskmanager-private"
  }
}
