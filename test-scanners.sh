#!/usr/bin/env bash
# test-scanners.sh
# Run each scanner container against the repository and save SARIF outputs

set -euo pipefail

REPO_PATH="${1:-.}"
OUTPUT_DIR="${REPO_PATH}"

echo "=========================================="
echo "  Security Scanner Test Suite"
echo "=========================================="
echo
echo "Repository: $REPO_PATH"
echo

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

run_scanner() {
    scanner_name=$1
    image_name=$2
    output_file=$3
    extra_args=$4

    printf "%b" "${YELLOW}[*] Running ${scanner_name} scanner...${NC}\n"

    # Remove stale result
    rm -f "$REPO_PATH/results.sarif"

    docker run --rm \
        -v "$REPO_PATH:/scan" \
        $extra_args \
        "$image_name" || true

    if [ -f "$REPO_PATH/results.sarif" ]; then
        mv "$REPO_PATH/results.sarif" "$OUTPUT_DIR/$output_file"
        TOTAL=$(jq '.runs[0].results | length' "$OUTPUT_DIR/$output_file" 2>/dev/null || echo "0")
        printf "%b" "${GREEN}[✓] ${scanner_name}: ${TOTAL} findings → ${output_file}${NC}\n"
    else
        printf "%b" "${RED}[✗] ${scanner_name}: No results generated${NC}\n"
    fi
    echo
}

echo "=========================================="
echo "  1. SECRETS SCAN (Gitleaks)"
echo "=========================================="
run_scanner "Secrets" "cicd-secret-scanner" "results-secret.sarif" ""

echo "=========================================="
echo "  2. SAST SCAN (Semgrep)"
echo "=========================================="
run_scanner "SAST" "cicd-sast-scanner" "results-sast.sarif" ""

echo "=========================================="
echo "  3. SCA SCAN (Trivy - Dependencies)"
echo "=========================================="
run_scanner "SCA" "cicd-sca-scanner" "results-sca.sarif" ""

echo "=========================================="
echo "  4. IAC SCAN (Checkov)"
echo "=========================================="
run_scanner "IaC" "cicd-iac-scanner" "results-iac.sarif" ""

echo "=========================================="
echo "  5. CONTAINER SCAN (Trivy - Dockerfiles)"
echo "=========================================="
run_scanner "Containers" "cicd-container-scanner" "results-container.sarif" ""

echo "=========================================="
echo "  SUMMARY"
echo "=========================================="
echo
for f in "$OUTPUT_DIR"/results-*.sarif; do
    if [ -f "$f" ]; then
        name=$(basename "$f")
        count=$(jq '.runs[0].results | length' "$f" 2>/dev/null || echo "0")
        printf "%b" "  ${GREEN}${name}${NC}: ${count} findings\n"
    fi
done
echo
printf "%b" "${GREEN}Test complete!${NC}\n"
