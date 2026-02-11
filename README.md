# TaskManager - Vulnerable Test Application

> ⚠️ **REPOSITORIO DE PRUEBA PARA TFM** - Contiene vulnerabilidades intencionadas para testing de herramientas de seguridad CI/CD.

## Descripción

TaskManager es una aplicación web de gestión de tareas con:
- Backend Python (Flask)
- Base de datos PostgreSQL
- Infraestructura en AWS (Terraform)
- Despliegue en Kubernetes
- Contenedorización Docker

---

## 🎯 Vulnerabilidades Intencionadas

Este repositorio contiene vulnerabilidades controladas para validar el funcionamiento de herramientas de seguridad.

### 1. Secrets - Credenciales Expuestas (Gitleaks)

| Archivo | Vulnerabilidad | Línea |
|---------|---------------|-------|
| `src/config.py` | AWS Access Key ID hardcodeada | 8 |
| `src/config.py` | AWS Secret Access Key hardcodeada | 9 |
| `src/config.py` | Database password en código | 18 |
| `src/config.py` | Stripe API Key hardcodeada | 22 |
| `src/config.py` | SendGrid API Key hardcodeada | 23 |
| `src/config.py` | Redis password en URL | 29 |
| `src/utils/email.py` | SMTP password hardcodeado | 12 |
| `src/utils/email.py` | SendGrid API Key | 16 |
| `src/routes/auth.py` | JWT Secret hardcodeado | 8 |
| `Dockerfile` | DB_PASSWORD en ARG | 12 |
| `Dockerfile` | AWS_ACCESS_KEY_ID en ENV | 17 |
| `docker-compose.yaml` | AWS credentials en environment | 17-18 |
| `docker-compose.yaml` | POSTGRES_PASSWORD hardcodeado | 42 |
| `terraform/ec2.tf` | Secrets en user_data | 76-77 |

### 2. SAST - Código Vulnerable (Semgrep)

| Archivo | Vulnerabilidad | CWE | Línea |
|---------|---------------|-----|-------|
| `src/routes/tasks.py` | SQL Injection (f-string) | CWE-89 | 23-25 |
| `src/routes/tasks.py` | SQL Injection (format) | CWE-89 | 41 |
| `src/routes/tasks.py` | eval() con input usuario | CWE-95 | 55 |
| `src/routes/tasks.py` | Unsafe YAML load | CWE-502 | 67 |
| `src/routes/tasks.py` | Command Injection (shell=True) | CWE-78 | 78-79 |
| `src/routes/auth.py` | Weak password hashing (MD5) | CWE-328 | 20 |
| `src/routes/auth.py` | Hardcoded JWT secret | CWE-798 | 8 |
| `src/routes/auth.py` | SQL Injection en registro | CWE-89 | 47 |
| `src/utils/files.py` | Path traversal (os.path.join) | CWE-22 | 16-17 |
| `src/utils/files.py` | Arbitrary file read | CWE-22 | 34 |
| `src/utils/files.py` | Arbitrary file write | CWE-22 | 46 |

### 3. SCA - Dependencias Vulnerables (Trivy)

#### Python (`requirements.txt`)

| Dependencia | Versión | CVE | Severidad |
|-------------|---------|-----|-----------|
| Flask | 1.0.0 | CVE-2023-30861 | High |
| Jinja2 | 2.10 | CVE-2019-10906 | Critical |
| PyYAML | 5.1 | CVE-2020-14343 | Critical |
| requests | 2.20.0 | CVE-2018-18074 | Medium |
| SQLAlchemy | 1.2.0 | CVE-2019-7164 | High |
| Pillow | 8.0.0 | CVE-2022-22817 | Critical |
| lxml | 4.5.0 | CVE-2020-28463 | High |
| paramiko | 2.7.0 | CVE-2022-24302 | High |
| cryptography | 3.2 | CVE-2020-36242 | High |
| boto3 | 1.17.0 | CVE-2022-25168 | Medium |

#### Node.js (`package.json`)

| Dependencia | Versión | CVE | Severidad |
|-------------|---------|-----|-----------|
| lodash | 4.17.15 | CVE-2021-23337 | High |
| axios | 0.21.0 | CVE-2021-3749 | High |
| jquery | 2.2.4 | CVE-2020-11023 | Medium |
| express | 4.16.0 | CVE-2022-24999 | High |
| node-fetch | 2.6.0 | CVE-2022-0235 | High |
| serialize-javascript | 2.1.0 | CVE-2020-7660 | Critical |
| minimist | 1.2.0 | CVE-2021-44906 | Critical |
| handlebars | 4.5.0 | CVE-2021-23369 | Critical |
| marked | 0.7.0 | CVE-2022-21680 | High |

### 4. IaC - Infraestructura Insegura (Checkov)

#### Terraform

| Archivo | Vulnerabilidad | Check ID |
|---------|---------------|----------|
| `terraform/s3.tf` | S3 bucket con ACL público | CKV_AWS_20 |
| `terraform/s3.tf` | S3 sin server-side encryption | CKV_AWS_19 |
| `terraform/s3.tf` | S3 sin versionado | CKV_AWS_21 |
| `terraform/s3.tf` | S3 sin logging | CKV_AWS_18 |
| `terraform/s3.tf` | S3 permite acceso público | CKV_AWS_53-56 |
| `terraform/ec2.tf` | Security Group SSH abierto (0.0.0.0/0) | CKV_AWS_24 |
| `terraform/ec2.tf` | Security Group DB abierta al mundo | CKV_AWS_23 |
| `terraform/ec2.tf` | EC2 sin IMDSv2 | CKV_AWS_79 |
| `terraform/ec2.tf` | EBS sin cifrado | CKV_AWS_3 |
| `terraform/ec2.tf` | Secrets en user_data | CKV_AWS_46 |
| `terraform/rds.tf` | RDS sin cifrado | CKV_AWS_16 |
| `terraform/rds.tf` | RDS públicamente accesible | CKV_AWS_17 |
| `terraform/rds.tf` | RDS sin backup habilitado | CKV_AWS_133 |
| `terraform/rds.tf` | RDS sin deletion protection | CKV_AWS_162 |

#### Kubernetes (`k8s/deployment.yaml`)

| Vulnerabilidad | Check ID | Línea |
|---------------|----------|-------|
| Container privilegiado | CKV_K8S_16 | 44 |
| Ejecuta como root (runAsUser: 0) | CKV_K8S_23 | 47 |
| runAsNonRoot: false | CKV_K8S_22 | 48 |
| allowPrivilegeEscalation: true | CKV_K8S_20 | 51 |
| readOnlyRootFilesystem: false | CKV_K8S_22 | 54 |
| Capabilities peligrosas (SYS_ADMIN) | CKV_K8S_39 | 58-61 |
| Secrets en env plano | CKV_K8S_35 | 64-70 |
| Sin liveness probe | CKV_K8S_8 | - |
| Sin readiness probe | CKV_K8S_9 | - |
| Sin resource limits | CKV_K8S_11-13 | - |
| Docker socket montado | CKV_K8S_27 | 79-80 |
| hostPath volume | CKV_K8S_26 | 75-76 |
| hostNetwork: true | CKV_K8S_19 | 87 |
| hostPID: true | CKV_K8S_17 | 88 |
| Namespace default | CKV_K8S_21 | 6 |
| Image tag :latest | CKV_K8S_14 | 25 |

#### Docker Compose (`docker-compose.yaml`)

| Vulnerabilidad | Descripción |
|---------------|-------------|
| Puerto SSH expuesto | Port 22:22 |
| Docker socket montado | /var/run/docker.sock |
| privileged: true | Container con todos los privilegios |
| Secrets en environment | Credenciales en texto plano |
| DB expuesta al host | Port 5432:5432 |
| Redis expuesto | Port 6379:6379 |
| Sin health checks | No defined |
| Sin resource limits | No defined |

### 5. Container - Imagen Vulnerable (Trivy)

| Archivo | Vulnerabilidad | Descripción |
|---------|---------------|-------------|
| `Dockerfile` | Imagen base antigua | python:3.8-slim con CVEs conocidos |
| `Dockerfile` | Ejecución como root | No define USER non-root |
| `Dockerfile` | Secrets en ARG | DB_PASSWORD, API_KEY visibles en history |
| `Dockerfile` | Secrets en ENV | DATABASE_URL, SECRET_KEY, AWS keys |
| `Dockerfile` | Puerto 22 expuesto | EXPOSE 22 (SSH) |
| `Dockerfile` | Herramientas debug | strace, tcpdump en producción |
| `Dockerfile` | Sin verificación checksum | curl sin validación |
| `Dockerfile` | Secret en HEALTHCHECK | token=secret123 visible |

---

## 📊 Resultados Esperados

Ejecutando los scanners deberías obtener aproximadamente:

| Scanner | Findings |
|---------|----------|
| **Secrets** | ~16 |
| **SAST** | ~26 |
| **SCA** | ~37 |
| **IaC** | ~77 |
| **Container** | ~34 |

---

## 🧪 Cómo Ejecutar los Scanners

### Prerequisitos

- **Docker** instalado y en ejecución
- **jq** instalado (requerido para contar findings en los scripts)

#### Instalar jq

```bash
# Ubuntu/Debian
sudo apt-get install jq

# macOS (Homebrew)
brew install jq

# Windows (Chocolatey) - en PowerShell como Admin
choco install jq

# Windows (winget)
winget install jqlang.jq
```

> ⚠️ **Importante**: Los scripts `test-scanners.sh` requieren `jq` para parsear los resultados SARIF y mostrar el conteo de findings. Sin `jq`, el script mostrará 0 findings aunque se hayan detectado vulnerabilidades.

#### Instalar make (opcional)

`make` es necesario para usar el `Makefile` que facilita la construcción de las imágenes Docker de los scanners.

```bash
# Ubuntu/Debian
sudo apt-get install make

# macOS (viene preinstalado con Xcode Command Line Tools)
xcode-select --install

# Windows (Chocolatey) - en PowerShell como Admin
choco install make

# Windows (winget)
winget install GnuWin32.Make

# Windows (alternativa: usar Git Bash que incluye make)
# O instalar MSYS2: https://www.msys2.org/
```

> 💡 **Nota**: En Windows, si no tienes `make`, puedes construir las imágenes manualmente con `docker build`:
> ```powershell
> docker build -t cicd-secret-scanner .\cicd-security-scanner\secrets
> docker build -t cicd-sast-scanner .\cicd-security-scanner\sast
> docker build -t cicd-sca-scanner .\cicd-security-scanner\sca
> docker build -t cicd-iac-scanner .\cicd-security-scanner\iac
> docker build -t cicd-container-scanner .\cicd-security-scanner\containers
> ```

### Construir las Imágenes de los Scanners

Desde el directorio `cicd-security-scanner`:

```bash
# Construir todas las imágenes
make all

# O construir individualmente
make secrets   # cicd-secret-scanner
make sast      # cicd-sast-scanner
make sca       # cicd-sca-scanner
make iac       # cicd-iac-scanner
make containers # cicd-container-scanner
```

---

### 🐧 Linux / macOS - `test-scanners.sh`

```bash
# Dar permisos de ejecución
chmod +x test-scanners.sh

# Ejecutar todos los scanners
./test-scanners.sh

# Ejecutar desde otro directorio
./test-scanners.sh /path/to/repo
```

**Salida esperada:**
```
==========================================
  Security Scanner Test Suite
==========================================

Repository: .

==========================================
  1. SECRETS SCAN (Gitleaks)
==========================================
[*] Running Secrets scanner...
[✓] Secrets: 16 findings → results-secret.sarif

==========================================
  2. SAST SCAN (Semgrep)
==========================================
[*] Running SAST scanner...
[✓] SAST: 26 findings → results-sast.sarif

...

==========================================
  SUMMARY
==========================================

  results-container.sarif: 34 findings
  results-iac.sarif: 77 findings
  results-sast.sarif: 26 findings
  results-sca.sarif: 37 findings
  results-secret.sarif: 16 findings

Test complete!
```

#### Troubleshooting Linux/macOS

Si ves errores de sintaxis o `$'\r': command not found`:

```bash
# Convertir a formato Unix (elimina CRLF)
dos2unix test-scanners.sh
# o con sed
sed -i 's/\r$//' test-scanners.sh

chmod +x test-scanners.sh
./test-scanners.sh
```

---

### 🪟 Windows (PowerShell) - `test-scanners.ps1`

```powershell
# Ejecutar todos los scanners
.\test-scanners.ps1

# Construir imágenes y luego escanear
.\test-scanners.ps1 -Build

# Especificar ruta del repositorio
.\test-scanners.ps1 -RepoPath "C:\path\to\repo"
```

**Salida esperada:**
```
Repository: C:\Users\Laura\Documents\GitHub\vulnerable-test-app
Starting scanners...

==> Running Secrets scanner (image: cicd-secret-scanner)

🔍 Running Gitleaks...
...
Secrets: 16 findings → results-secret.sarif

==> Running SAST scanner (image: cicd-sast-scanner)
...

Summary:

  results-container.sarif: 34 findings
  results-iac.sarif: 77 findings
  results-sast.sarif: 26 findings
  results-sca.sarif: 37 findings
  results-secret.sarif: 16 findings

All done. SARIF files saved to C:\Users\Laura\Documents\GitHub\vulnerable-test-app
```

#### Troubleshooting Windows

Si ves caracteres extraños (ƒôè, Ô£à, etc.):

```powershell
# Establecer encoding UTF-8 antes de ejecutar
chcp 65001
.\test-scanners.ps1
```

---

### 📁 Archivos de Resultado

Después de ejecutar los scanners, encontrarás los siguientes archivos SARIF:

| Archivo | Scanner | Herramienta |
|---------|---------|-------------|
| `results-secret.sarif` | Secrets | Gitleaks |
| `results-sast.sarif` | SAST | Semgrep |
| `results-sca.sarif` | SCA | Trivy |
| `results-iac.sarif` | IaC | Checkov |
| `results-container.sarif` | Container | Trivy |

### Consultar Resultados con jq

```bash
# Ver número total de findings
jq '.runs[0].results | length' results-sast.sarif

# Ver todas las reglas detectadas
jq '.runs[0].results[].ruleId' results-sast.sarif

# Ver findings con severidad alta
jq '.runs[0].results[] | select(.level == "error")' results-sast.sarif

# Listar archivos afectados
jq '.runs[0].results[].locations[0].physicalLocation.artifactLocation.uri' results-sast.sarif | sort -u

# Exportar resumen a CSV
jq -r '.runs[0].results[] | [.ruleId, .level, .locations[0].physicalLocation.artifactLocation.uri] | @csv' results-sast.sarif
```

---

### 🐳 Ejecutar Scanners Individualmente

```bash
# Secrets (Gitleaks)
docker run --rm -v $(pwd):/scan cicd-secret-scanner

# SAST (Semgrep)
docker run --rm -v $(pwd):/scan cicd-sast-scanner

# SCA (Trivy - Dependencies)
docker run --rm -v $(pwd):/scan cicd-sca-scanner

# IaC (Checkov)
docker run --rm -v $(pwd):/scan cicd-iac-scanner

# Container (Trivy - Dockerfile)
docker run --rm -v $(pwd):/scan cicd-container-scanner
```

En PowerShell:
```powershell
docker run --rm -v "${PWD}:/scan" cicd-secret-scanner
docker run --rm -v "${PWD}:/scan" cicd-sast-scanner
docker run --rm -v "${PWD}:/scan" cicd-sca-scanner
docker run --rm -v "${PWD}:/scan" cicd-iac-scanner
docker run --rm -v "${PWD}:/scan" cicd-container-scanner
```

---

## ⚠️ Disclaimer

Este repositorio es únicamente para fines educativos y de testing. **NO usar en producción.**

Las credenciales incluidas son ficticias pero tienen formato válido para ser detectadas por las herramientas de seguridad.
