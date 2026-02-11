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

function Run-Scanner([string]$name, [string]$image, [string]$outputFile, [string]$extraArgs) {
    Write-Info "`n==> Running $name scanner (image: $image)`n"

    $tmp = Join-Path $RepoPath 'results.sarif'
    if (Test-Path $tmp) { Remove-Item $tmp -Force }

    $vol = "${RepoPath}:/scan"
    $cmd = @('run','--rm','-v',$vol)
    if ($extraArgs) { $cmd += $extraArgs }
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
        Write-Ok ("{0}: {1} findings → {2}" -f $name, $count, $outputFile)
    }
    else {
        Write-Warn ("{0}: no results.sarif produced" -f $name)
    }
}

Write-Info "Starting scanners..."

Run-Scanner -name 'Secrets' -image 'cicd-secret-scanner' -outputFile 'results-secret.sarif' -extraArgs ''
Run-Scanner -name 'SAST' -image 'cicd-sast-scanner' -outputFile 'results-sast.sarif' -extraArgs ''
Run-Scanner -name 'SCA' -image 'cicd-sca-scanner' -outputFile 'results-sca.sarif' -extraArgs ''
Run-Scanner -name 'IaC' -image 'cicd-iac-scanner' -outputFile 'results-iac.sarif' -extraArgs ''
Run-Scanner -name 'Containers' -image 'cicd-container-scanner' -outputFile 'results-container.sarif' -extraArgs ''

Write-Host "=========================================="
Write-Host "  SUMMARY"
Write-Host "=========================================="
Write-Host ""
Get-ChildItem -Path $RepoPath -Filter 'results-*.sarif' | ForEach-Object {
    $f = $_.FullName
    try { $j = Get-Content $f -Raw | ConvertFrom-Json -ErrorAction Stop; $c = 0; if ($j.runs -and $j.runs.Count -gt 0 -and $j.runs[0].results) { $c = ($j.runs[0].results | Measure-Object).Count } }
    catch { $c = 0 }
    Write-Host "  $($_.Name): $c findings"
}

Write-Ok "`nTest complete!`n"
