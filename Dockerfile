# Dockerfile for TaskManager
# VULN: Múltiples misconfiguraciones para testing de Trivy

# VULN: Imagen base antigua con CVEs conocidos
FROM python:3.8-slim

# VULN: Labels con información sensible
LABEL maintainer="admin@taskmanager.com"
LABEL db_password="this_is_not_a_password"

# VULN: Secrets en ARG (visible en docker history)
ARG DB_PASSWORD=SuperSecretPass123
ARG API_KEY=sk_live_xxxxxxxxxxxx

# VULN: Variables de entorno con secrets
ENV DATABASE_URL=postgresql://admin:password123@db:5432/taskmanager
ENV SECRET_KEY=super-secret-key-not-for-production
ENV AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE

# VULN: Ejecuta como root (no hay USER instruction)
# Debería tener:
# RUN useradd -m appuser
# USER appuser

# VULN: apt-get sin limpiar cache (aumenta tamaño de imagen)
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    netcat \
    vim \
    # VULN: Herramientas de debug innecesarias en producción
    strace \
    tcpdump

# VULN: Sin verificación de checksums en descargas
RUN curl -o /tmp/script.sh http://example.com/setup.sh && \
    chmod +x /tmp/script.sh

WORKDIR /app

# VULN: Copia todo incluyendo posibles secrets
COPY . .

# VULN: Instala dependencias con versiones vulnerables
RUN pip install --no-cache-dir -r requirements.txt

# VULN: Puerto de debug expuesto
EXPOSE 5000
EXPOSE 5555
EXPOSE 22

# VULN: Shell form en lugar de exec form
# CMD python app.py  # Shell form - menos seguro

# Ejecuta la aplicación
CMD ["python", "src/app.py"]

# VULN: HEALTHCHECK con secrets en comando (visible en inspect)
HEALTHCHECK --interval=30s --timeout=10s \
    CMD curl -f http://localhost:5000/health?token=secret123 || exit 1
