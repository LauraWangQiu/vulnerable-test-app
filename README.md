# TaskManager - Vulnerable Test Application

> ⚠️ **REPOSITORIO DE PRUEBA PARA TFM** - Contiene vulnerabilidades intencionadas para testing de herramientas de seguridad CI/CD.

## Descripción

TaskManager es una aplicación web de gestión de tareas con:
- Backend Python (Flask)
- Base de datos PostgreSQL
- Infraestructura en AWS (Terraform)
- Despliegue en Kubernetes
- Contenedorización Docker

## 🎯 Vulnerabilidades Intencionadas

Este repositorio contiene vulnerabilidades controladas para validar el funcionamiento de herramientas de seguridad.

### 1. Secrets (Gitleaks)
| Archivo | Vulnerabilidad | Línea |
|---------|---------------|-------|
| `src/config.py` | AWS Access Key hardcodeada | 8-9 |
| `src/config.py` | Database password en código | 15 |
| `.env.example` | Token de API real (no ejemplo) | 3 |
| `src/utils/email.py` | SMTP password hardcodeado | 12 |

### 2. SAST - Código Vulnerable (Semgrep)
| Archivo | Vulnerabilidad | CWE | Línea |
|---------|---------------|-----|-------|
| `src/routes/tasks.py` | SQL Injection | CWE-89 | 23 |
| `src/routes/tasks.py` | eval() con input usuario | CWE-95 | 45 |
| `src/routes/auth.py` | Weak password hashing (MD5) | CWE-328 | 18 |
| `src/routes/auth.py` | Hardcoded JWT secret | CWE-798 | 8 |
| `src/templates/task.html` | XSS (innerHTML) | CWE-79 | 15 |
| `src/utils/files.py` | Path traversal | CWE-22 | 12 |

### 3. SCA - Dependencias Vulnerables (Trivy)
| Archivo | Dependencia | CVE | Severidad |
|---------|------------|-----|-----------|
| `requirements.txt` | Flask 1.0.0 | CVE-2023-30861 | High |
| `requirements.txt` | Jinja2 2.10 | CVE-2019-10906 | Critical |
| `requirements.txt` | PyYAML 5.1 | CVE-2020-14343 | Critical |
| `requirements.txt` | requests 2.20.0 | CVE-2018-18074 | Medium |
| `package.json` | lodash 4.17.15 | CVE-2021-23337 | High |

### 4. IaC - Infraestructura Insegura (Checkov)
| Archivo | Vulnerabilidad | Check ID | Línea |
|---------|---------------|----------|-------|
| `terraform/s3.tf` | S3 bucket público | CKV_AWS_19 | 5 |
| `terraform/s3.tf` | S3 sin cifrado | CKV_AWS_20 | 1 |
| `terraform/ec2.tf` | Security Group abierto (0.0.0.0/0) | CKV_AWS_24 | 15 |
| `terraform/rds.tf` | RDS sin cifrado | CKV_AWS_16 | 8 |
| `terraform/rds.tf` | RDS públicamente accesible | CKV_AWS_17 | 12 |
| `k8s/deployment.yaml` | Container privilegiado | CKV_K8S_1 | 25 |
| `k8s/deployment.yaml` | Root user | CKV_K8S_6 | 28 |

### 5. Container - Imagen Vulnerable (Trivy)
| Archivo | Vulnerabilidad | Descripción |
|---------|---------------|-------------|
| `Dockerfile` | Imagen base antigua | python:3.8-slim (CVEs conocidos) |
| `Dockerfile` | Root user | No usa USER non-root |
| `Dockerfile` | Secrets en build | ARG con password |

## 📊 Resultados Esperados

Ejecutando el scanner completo deberías obtener:

```
┌─────────────┬──────────┬──────────┬─────────┐
│ Scanner     │ Critical │ High     │ Medium  │
├─────────────┼──────────┼──────────┼─────────┤
│ Secrets     │ 4        │ 0        │ 0       │
│ SAST        │ 2        │ 3        │ 1       │
│ SCA         │ 2        │ 2        │ 1       │
│ IaC         │ 3        │ 4        │ 2       │
│ Container   │ 5+       │ 10+      │ 15+     │
└─────────────┴──────────┴──────────┴─────────┘
```

## 🧪 Cómo Probar

```bash
# Clonar el repo de prueba
git clone https://github.com/tu-usuario/vulnerable-test-app.git
cd vulnerable-test-app

# Ejecutar el scanner
docker run -v $(pwd):/scan cicd-security-scanner:secrets
docker run -v $(pwd):/scan cicd-security-scanner:sast
docker run -v $(pwd):/scan cicd-security-scanner:sca
docker run -v $(pwd):/scan cicd-security-scanner:iac
docker run -v $(pwd):/scan cicd-security-scanner:containers
```

## ⚠️ Disclaimer

Este repositorio es únicamente para fines educativos y de testing. **NO usar en producción.**
Las credenciales incluidas son ficticias pero tienen formato válido para ser detectadas por las herramientas.
