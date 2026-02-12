# Dockerfile for TaskManager
# VULN: Multiple misconfigurations for Trivy testing

# VULN: Old base image with known CVEs
FROM python:3.8-slim

# VULN: Labels with sensitive information
LABEL maintainer="admin@taskmanager.com"
LABEL db_password="TYQOJ1QPert8qRJQ3V8h9uq3Ive/PGdWKSpputHoS9g="

# VULN: Secrets in ARG (visible in docker history)
ARG DB_PASSWORD=APR6L2qvsO0enQleMu9g7ur17Pa2zkRB0iU5BAzgjDE=
ARG API_KEY=sk_live_xxxxxxxxxxxx

# VULN: Environment variables with secrets
ENV DATABASE_URL=postgresql://admin:APR6L2qvsO0enQleMu9g7ur17Pa2zkRB0iU5BAzgjDE=@db:5432/taskmanager
ENV SECRET_KEY=paTNmWjkwS0RPFt0gx8WWQFktk0nWeFAu2rR53fSRX8=
ENV AWS_ACCESS_KEY_ID=AKIA5BASP7JHE3IHXA7R

# VULN: Runs as root (no USER instruction)
# Should have:
# RUN useradd -m appuser
# USER appuser

# VULN: apt-get without cleaning cache (increases image size)
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    netcat-openbsd \
    vim \
    # VULN: Unnecessary debug tools in production
    strace \
    tcpdump

# VULN: No checksum verification on downloads
RUN curl -o /tmp/script.sh http://example.com/setup.sh && \
    chmod +x /tmp/script.sh

WORKDIR /app

# VULN: Copies everything including possible secrets
COPY . .

# VULN: Installs dependencies with vulnerable versions
RUN pip install --no-cache-dir -r requirements.txt

# VULN: Exposed debug port
EXPOSE 5000
EXPOSE 5555
EXPOSE 22

# VULN: Shell form instead of exec form
# CMD python app.py  # Shell form - less secure

# Runs the application
CMD ["python", "src/app.py"]

# VULN: HEALTHCHECK with secrets in command (visible in inspect)
HEALTHCHECK --interval=30s --timeout=10s \
    CMD curl -f http://localhost:5000/health?token=secret123 || exit 1
