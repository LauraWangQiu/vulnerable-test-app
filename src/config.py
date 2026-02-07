"""
TaskManager Configuration
Configuración de la aplicación
"""
import os

# VULN: AWS credentials hardcodeadas (Gitleaks detectará esto)
AWS_ACCESS_KEY_ID = "AKIAIOSFODNN7EXAMPLE"
AWS_SECRET_ACCESS_KEY = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
AWS_REGION = "eu-west-1"

# VULN: Database password en código fuente (Gitleaks)
DATABASE_CONFIG = {
    "host": "taskmanager-db.cluster-abc123.eu-west-1.rds.amazonaws.com",
    "port": 5432,
    "database": "taskmanager",
    "user": "admin",
    "password": "SuperSecretP@ssw0rd123!"  # VULN: Hardcoded password
}

# VULN: API Keys hardcodeadas
STRIPE_API_KEY = "sk_live_51H7xxxxxxxxxxxxxxxxxxxxxxxxxxx"
SENDGRID_API_KEY = "SG.xxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# S3 Configuration
S3_BUCKET_NAME = "taskmanager-uploads-prod"
S3_BUCKET_REGION = "eu-west-1"

# Redis configuration
REDIS_URL = "redis://:RedisP@ss123@redis.taskmanager.internal:6379/0"

# Application settings
DEBUG = True  # VULN: Debug mode en producción
SECRET_KEY = os.environ.get("SECRET_KEY", "dev-secret-key-change-in-prod")

# Logging
LOG_LEVEL = "DEBUG"
