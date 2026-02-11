"""
TaskManager Configuration
Configuración de la aplicación
"""
import os

# VULN: Hardcoded AWS credentials (Gitleaks will detect this)
AWS_ACCESS_KEY_ID = "AKIA5BASP7JHE3IHXA7R"
AWS_SECRET_ACCESS_KEY = "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"
AWS_REGION = "eu-west-1"

# VULN: Database password in source code (Gitleaks)
DATABASE_CONFIG = {
    "host": "taskmanager-db.cluster-abc123.eu-west-1.rds.amazonaws.com",
    "port": 5432,
    "database": "taskmanager",
    "user": "admin",
    "password": "SuperSecretP@ssw0rd123!"  # VULN: Hardcoded password
}

# VULN: Hardcoded API Keys
STRIPE_API_KEY = "sk_live_4eC39HqLyjWDarjtT1zdp7dcTaskMgr"
SENDGRID_API_KEY = "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"

# S3 Configuration
S3_BUCKET_NAME = "taskmanager-uploads-prod"
S3_BUCKET_REGION = "eu-west-1"

# Redis configuration
REDIS_URL = "redis://:RedisP@ss123@redis.taskmanager.internal:6379/0"

# Application settings
DEBUG = True  # VULN: Debug mode in production
SECRET_KEY = os.environ.get("SECRET_KEY", "dev-secret-key-change-in-prod")

# Logging
LOG_LEVEL = "DEBUG"
