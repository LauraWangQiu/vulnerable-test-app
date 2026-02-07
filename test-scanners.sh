#!/bin/bash
# =============================================================================
# test-scanners.sh
# Script para probar todos los scanners contra el repositorio vulnerable
# =============================================================================

set -e

REPO_PATH="${1:-.}"
SCANNER_IMAGE_PREFIX="${2:-cicd-security-scanner}"
OUTPUT_DIR="./scan-results"

echo "=========================================="
echo "  Security Scanner Test Suite"
echo "=========================================="
echo ""
echo "Repository: $REPO_PATH"
echo "Results will be saved to: $OUTPUT_DIR"
echo ""

# Crear directorio de resultados
mkdir -p "$OUTPUT_DIR"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

run_scanner() {
    local scanner_name=$1
    local expected_findings=$2
    
    echo -e "${YELLOW}[*] Running $scanner_name scanner...${NC}"
    
    # Ejecutar scanner y guardar resultado
    docker run --rm \
        -v "$REPO_PATH:/scan" \
        "$SCANNER_IMAGE_PREFIX:$scanner_name" \
        > "$OUTPUT_DIR/${scanner_name}-results.json" 2>&1 || true
    
    # Contar findings
    if [ -f "$OUTPUT_DIR/${scanner_name}-results.json" ]; then
        findings=$(grep -c '"severity"' "$OUTPUT_DIR/${scanner_name}-results.json" 2>/dev/null || echo "0")
        
        if [ "$findings" -gt 0 ]; then
            echo -e "${GREEN}[✓] $scanner_name: Found $findings issues (expected: $expected_findings+)${NC}"
        else
            echo -e "${RED}[✗] $scanner_name: No findings detected!${NC}"
        fi
    else
        echo -e "${RED}[✗] $scanner_name: Failed to generate results${NC}"
    fi
    echo ""
}

echo "=========================================="
echo "  1. SECRETS SCAN (Gitleaks)"
echo "=========================================="
run_scanner "secrets" "4"

echo "=========================================="
echo "  2. SAST SCAN (Semgrep)"
echo "=========================================="
run_scanner "sast" "6"

echo "=========================================="
echo "  3. SCA SCAN (Trivy - Dependencies)"
echo "=========================================="
run_scanner "sca" "10"

echo "=========================================="
echo "  4. IAC SCAN (Checkov)"
echo "=========================================="
run_scanner "iac" "15"

echo "=========================================="
echo "  5. CONTAINER SCAN (Trivy - Image)"
echo "=========================================="
# Para el scan de containers, primero construir la imagen
echo -e "${YELLOW}[*] Building test Docker image...${NC}"
docker build -t taskmanager:test "$REPO_PATH" 2>/dev/null || true

echo -e "${YELLOW}[*] Running container scanner...${NC}"
docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    "$SCANNER_IMAGE_PREFIX:containers" \
    taskmanager:test \
    > "$OUTPUT_DIR/containers-results.json" 2>&1 || true

if [ -f "$OUTPUT_DIR/containers-results.json" ]; then
    echo -e "${GREEN}[✓] Container scan completed${NC}"
fi
echo ""

echo "=========================================="
echo "  SUMMARY"
echo "=========================================="
echo ""
echo "Scan results saved to: $OUTPUT_DIR/"
echo ""
ls -la "$OUTPUT_DIR/"
echo ""
echo "=========================================="
echo "  Detailed Expected Findings"
echo "=========================================="
cat << 'EOF'

SECRETS (Gitleaks):
  - src/config.py: AWS keys, DB password
  - .env.example: GitHub token, Slack webhook
  - src/utils/email.py: SMTP password

SAST (Semgrep):
  - src/routes/tasks.py: SQL Injection (L23, L37)
  - src/routes/tasks.py: eval() usage (L45)
  - src/routes/auth.py: MD5 hashing (L18)
  - src/utils/files.py: Path traversal (L12)
  - src/templates/task.html: XSS (innerHTML)

SCA (Trivy):
  - Flask 1.0.0: CVE-2023-30861
  - Jinja2 2.10: CVE-2019-10906  
  - PyYAML 5.1: CVE-2020-14343
  - lodash 4.17.15: CVE-2021-23337
  
IaC (Checkov):
  - terraform/s3.tf: Public bucket, no encryption
  - terraform/ec2.tf: Open security groups
  - terraform/rds.tf: Public DB, no encryption
  - k8s/deployment.yaml: Privileged container, root user

CONTAINERS (Trivy):
  - Base image python:3.8-slim with old CVEs
  - Running as root
  - Debug tools installed

EOF

echo ""
echo -e "${GREEN}Test complete!${NC}"
