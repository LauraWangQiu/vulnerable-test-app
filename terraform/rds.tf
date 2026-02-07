# RDS Database Configuration
# VULN: Base de datos mal configurada para testing de Checkov

# VULN: RDS sin cifrado (CKV_AWS_16)
# VULN: RDS públicamente accesible (CKV_AWS_17)
# VULN: Sin backup habilitado (CKV_AWS_133)
resource "aws_db_instance" "postgres" {
  identifier        = "taskmanager-db"
  engine            = "postgres"
  engine_version    = "13.4"
  instance_class    = "db.t3.medium"
  allocated_storage = 20
  
  db_name  = "taskmanager"
  username = "admin"
  password = var.db_password  # VULN: Password en variable con default
  
  # VULN: SG permite acceso desde cualquier IP
  vpc_security_group_ids = [aws_security_group.web.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  
  # VULN: Públicamente accesible (CKV_AWS_17)
  publicly_accessible = true  # VULN: Debería ser false
  
  # VULN: Sin cifrado (CKV_AWS_16)
  storage_encrypted = false  # VULN: Debería ser true
  
  # VULN: Sin backup (CKV_AWS_133)
  backup_retention_period = 0  # VULN: Debería ser >= 7
  
  # VULN: Sin deletion protection (CKV_AWS_162)
  deletion_protection = false  # VULN: Debería ser true en prod
  
  # VULN: Sin logging habilitado (CKV_AWS_129)
  # enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  
  # VULN: Sin auto minor version upgrade
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
