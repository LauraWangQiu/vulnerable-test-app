#!/usr/bin/env bash
# test-scanners.sh
# Run each scanner container against the repository and save SARIF outputs

set -euo pipefail

REPO_PATH="${1:-.}"
# Normalize to absolute path so output matches PowerShell style
REPO_PATH="$(cd "$REPO_PATH" && pwd -P)"
OUTPUT_DIR="${REPO_PATH}"

printf "%b" "\033[0;36mRepository: $REPO_PATH\033[0m\n"
printf "%b" "\033[0;36mStarting scanners...\033[0m\n"
echo

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

run_scanner() {
    scanner_name=$1
    image_name=$2
    output_file=$3
    extra_args=$4


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

display_pre_run() {
    local scanner="$1"
    local tool="$2"
    case "$scanner" in
        Secrets|SAST|SCA|IaC|Containers)
            printf "${CYAN}\n==> Running %s scanner (image: %s)\n\n${NC}" "$scanner" "cicd-${scanner,,}-scanner"
            ;;
        *)
            printf "\n==> Running %s scanner (image: %s)\n\n" "$scanner" "$scanner"
            ;;
    esac
}

choose_tool() {
    local label="$1"; shift
    local default="$1"; shift
    local opts=("$@")

    # Non-interactive -> return default
    # If no tty and no /dev/tty, return default
    if [ ! -t 0 ] && [ ! -e /dev/tty ]; then
        echo "$default"
        return
    fi

    # Choose appropriate io device (prefer /dev/tty when present)
    local out=/dev/stdout
    local in=/dev/stdin
    if [ -e /dev/tty ]; then
        out=/dev/tty
        in=/dev/tty
    fi

    printf "Select tool for %s:\n" "$label" > "$out"
    local i=1
    for o in "${opts[@]}"; do
        printf "  %d) %s\n" "$i" "$o" > "$out"
        i=$((i+1))
    done
    printf "  0) Use default (%s)\n" "$default" > "$out"

    while true; do
        # Read from chosen input device so prompt appears in interactive consoles
        if read -r -p "Choice [enter=default]: " choice < "$in"; then
            :
        else
            echo "$default"
            return
        fi
        if [ -z "$choice" ]; then
            echo "$default"
            return
        fi
        if [[ "$choice" =~ ^[0-9]+$ ]]; then
            if [ "$choice" -eq 0 ]; then
                echo "$default"
                return
            elif [ "$choice" -ge 1 ] && [ "$choice" -le ${#opts[@]} ]; then
                echo "${opts[$((choice-1))]}"
                return
            fi
        fi
        printf "Invalid choice. Try again.\n" > "$out"
    done
}

TOOL_SECRETS=$(choose_tool "Secrets" "gitleaks" "gitleaks" "trufflehog")
EXTRA_SECRETS="-e TOOL=${TOOL_SECRETS}"
display_pre_run "Secrets" "$TOOL_SECRETS"
run_scanner "Secrets" "cicd-secret-scanner" "results-secret.sarif" "$EXTRA_SECRETS"

TOOL_SAST=$(choose_tool "SAST" "semgrep" "semgrep" "bandit")
EXTRA_SAST="-e TOOL=${TOOL_SAST}"
display_pre_run "SAST" "$TOOL_SAST"
run_scanner "SAST" "cicd-sast-scanner" "results-sast.sarif" "$EXTRA_SAST"

TOOL_SCA=$(choose_tool "SCA" "trivy" "trivy" "grype")
EXTRA_SCA="-e TOOL=${TOOL_SCA}"
display_pre_run "SCA" "$TOOL_SCA"
run_scanner "SCA" "cicd-sca-scanner" "results-sca.sarif" "$EXTRA_SCA"

TOOL_IAC=$(choose_tool "IaC" "checkov" "checkov" "trivy")
EXTRA_IAC="-e TOOL=${TOOL_IAC}"
display_pre_run "IaC" "$TOOL_IAC"
run_scanner "IaC" "cicd-iac-scanner" "results-iac.sarif" "$EXTRA_IAC"

TOOL_CONT=$(choose_tool "Containers" "trivy" "trivy" "grype")
EXTRA_CONT="-e TOOL=${TOOL_CONT}"
display_pre_run "Containers" "$TOOL_CONT"
run_scanner "Containers" "cicd-container-scanner" "results-container.sarif" "$EXTRA_CONT"

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
