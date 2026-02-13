# Windows PowerShell wrapper to run all scanners and collect SARIF results
# Builds (optional) scanner images and runs them, collecting each scanner's
# results.sarif into results-*.sarif in the repository root. Counts findings
# using PowerShell JSON parsing (no jq required).

param(
    [string]$RepoPath = (Get-Location).Path,
    [switch]$Build
)

function Write-Info($m){ Write-Host $m -ForegroundColor Cyan }
function Write-Ok($m){ Write-Host $m -ForegroundColor Green }
function Write-Warn($m){ Write-Host $m -ForegroundColor Yellow }
function Write-Err($m){ Write-Host $m -ForegroundColor Red }

Set-StrictMode -Version Latest

# Force UTF-8 console encoding so Unicode from scanner output displays correctly
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
try { $OutputEncoding = New-Object System.Text.UTF8Encoding $false } catch {}

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Err "Docker is not installed or not in PATH. Install Docker Desktop and retry."
    exit 1
}

$RepoPath = (Resolve-Path -Path $RepoPath).Path
Write-Info "Repository: $RepoPath"

function Build-Image([string]$tag, [string]$relPath) {
    $path = Join-Path $RepoPath $relPath
    if (-not (Test-Path $path)) { Write-Warn "Skipping build: $path not found"; return }
    Write-Info "Building $tag from $path..."
    docker build -t $tag $path
}

if ($Build) {
    Write-Info "Building all scanner images..."
    Build-Image -tag 'cicd-secret-scanner' -relPath 'cicd-security-scanner\secrets'
    Build-Image -tag 'cicd-sast-scanner' -relPath 'cicd-security-scanner\sast'
    Build-Image -tag 'cicd-sca-scanner' -relPath 'cicd-security-scanner\sca'
    Build-Image -tag 'cicd-iac-scanner' -relPath 'cicd-security-scanner\iac'
    Build-Image -tag 'cicd-container-scanner' -relPath 'cicd-security-scanner\containers'
}

function Run-Scanner([string]$name, [string]$image, [string]$outputFile, $extraArgs) {
    Write-Info "`n==> Running $name scanner (image: $image)`n"

    $tmp = Join-Path $RepoPath 'results.sarif'
    if (Test-Path $tmp) { Remove-Item $tmp -Force }

    $vol = "${RepoPath}:/scan"
    $cmd = @('run','--rm','-v',$vol)
    if ($extraArgs) {
        if ($extraArgs -is [string]) {
            $tokens = $extraArgs -split '\s+'
            $cmd += $tokens
        }
        elseif ($extraArgs -is [System.Array]) {
            $cmd += $extraArgs
        }
        else {
            $cmd += $extraArgs.ToString()
        }
    }
    $cmd += $image

    # Run docker and capture output to avoid PowerShell throwing NativeCommandError
    $output = & docker @cmd 2>&1
    $exitCode = $LASTEXITCODE
    if ($output) { $output | ForEach-Object { Write-Host $_ } }

    if (Test-Path $tmp) {
        $dest = Join-Path $RepoPath $outputFile
        Move-Item -Path $tmp -Destination $dest -Force
        try {
            $json = Get-Content $dest -Raw | ConvertFrom-Json -ErrorAction Stop
            $count = 0
            if ($json.runs -and $json.runs.Count -gt 0 -and $json.runs[0].results) { $count = ($json.runs[0].results | Measure-Object).Count }
        }
        catch {
            Write-Warn "Failed to parse $dest as JSON"
            $count = 0
        }
        Write-Host ("[OK] {0}: {1} findings -> {2}" -f $name, $count, $outputFile) -ForegroundColor Green
    }
    else {
        Write-Host ("[FAIL] {0}: no results generated" -f $name) -ForegroundColor Red
    }
}

Write-Info "Starting scanners..."

function Choose-Tool([string]$Name, [string[]]$Options, [string]$Default) {
    # Interactive selection of tool; returns selected tool string
    try {
        if (-not [System.Environment]::UserInteractive) { return $Default }
    } catch {
        return $Default
    }

    Write-Host "`nSelect tool for ${Name}:`n"
    for ($i = 0; $i -lt $Options.Length; $i++) {
        Write-Host "  $($i+1)) $($Options[$i])"
    }
    Write-Host "  0) Use default ($Default)"

    $choice = Read-Host "Choice [enter=default]"
    if ([string]::IsNullOrWhiteSpace($choice)) { return $Default }
    if ($choice -eq '0') { return $Default }
    $ok = [int]::TryParse($choice,[ref]$null)
    if ($ok -and [int]$choice -ge 1 -and [int]$choice -le $Options.Length) {
        return $Options[[int]$choice - 1]
    }
    Write-Warn "Invalid choice, using default $Default"
    return $Default
}

$toolSecrets = Choose-Tool 'Secrets' @('gitleaks','trufflehog') 'gitleaks'
Run-Scanner -name 'Secrets' -image 'cicd-secret-scanner' -outputFile 'results-secret.sarif' -extraArgs @('-e', "TOOL=$toolSecrets")

$toolSast = Choose-Tool 'SAST' @('semgrep','bandit') 'semgrep'
Run-Scanner -name 'SAST' -image 'cicd-sast-scanner' -outputFile 'results-sast.sarif' -extraArgs @('-e', "TOOL=$toolSast")

$toolSca = Choose-Tool 'SCA' @('trivy','grype') 'trivy'
Run-Scanner -name 'SCA' -image 'cicd-sca-scanner' -outputFile 'results-sca.sarif' -extraArgs @('-e', "TOOL=$toolSca")

$toolIac = Choose-Tool 'IaC' @('checkov','trivy') 'checkov'
Run-Scanner -name 'IaC' -image 'cicd-iac-scanner' -outputFile 'results-iac.sarif' -extraArgs @('-e', "TOOL=$toolIac")

$toolCont = Choose-Tool 'Containers' @('trivy','grype') 'trivy'
Run-Scanner -name 'Containers' -image 'cicd-container-scanner' -outputFile 'results-container.sarif' -extraArgs @('-e', "TOOL=$toolCont")

Write-Host "=========================================="
Write-Host "  SUMMARY"
Write-Host "=========================================="
Write-Host ""
Get-ChildItem -Path $RepoPath -Filter 'results-*.sarif' | ForEach-Object {
    $f = $_.FullName
    try { $j = Get-Content $f -Raw | ConvertFrom-Json -ErrorAction Stop; $c = 0; if ($j.runs -and $j.runs.Count -gt 0 -and $j.runs[0].results) { $c = ($j.runs[0].results | Measure-Object).Count } }
    catch { $c = 0 }
    # Print filename in green, the rest in default color
    Write-Host -NoNewline "  "
    Write-Host -NoNewline -ForegroundColor Green "$($_.Name)"
    Write-Host ": $c findings"
}

Write-Ok "`nTest complete!`n"
