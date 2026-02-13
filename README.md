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

| Archivo | Vulnerabilidad (Regla) | Línea |
|---|---|---|
| `k8s/insecure-pod.yaml` | stripe-access-token | 47 |
| `k8s/deployment.yaml` | stripe-access-token | 67 |
| `Dockerfile.worker` | generic-api-key | 12 |
| `src/api/user_handler.py` | generic-api-key | 83 |
| `.env.example` | slack-webhook-url | 11 |
| `.env.example` | private-key | 14 |
| `.env.example` | github-pat | 8 |
| `.env.example` | generic-api-key | 44 |
| `.env.example` | aws-access-token | 43 |
| `Dockerfile` | stripe-access-token | 13 |
| `Dockerfile` | generic-api-key | 9 |
| `Dockerfile` | generic-api-key | 12 |
| `Dockerfile` | generic-api-key | 17 |
| `Dockerfile` | aws-access-token | 18 |
| `docker-compose.yaml` | generic-api-key | 16 |
| `docker-compose.yaml` | generic-api-key | 18 |
| `docker-compose.yaml` | generic-api-key | 41 |
| `docker-compose.yaml` | aws-access-token | 17 |
| `src/routes/auth.py` | generic-api-key | 9 |
| `src/config.py` | sendgrid-api-token | 23 |
| `src/config.py` | generic-api-key | 9 |
| `src/config.py` | generic-api-key | 18 |
| `src/config.py` | aws-access-token | 8 |
| `src/config.py` | stripe-access-token | 22 |
| `terraform/lambda.tf` | hashicorp-tf-password | 17 |
| `terraform/lambda.tf` | stripe-access-token | 18 |
| `src/utils/email.py` | sendgrid-api-token | 17 |
| `src/utils/email.py` | generic-api-key | 13 |
| `terraform/ec2.tf` | generic-api-key | 76 |
| `src/auth/credentials.py` | slack-webhook-url | 22 |
| `src/auth/credentials.py` | private-key | 25 |
| `src/auth/credentials.py` | github-pat | 21 |
| `src/auth/credentials.py` | sendgrid-api-token | 20 |
| `src/auth/credentials.py` | generic-api-key | 19 |
| `src/auth/credentials.py` | stripe-access-token | 18 |
| `src/templates/task.html` | stripe-access-token | 88 |

### 2. SAST - Código Vulnerable (Semgrep)

| Archivo | Vulnerabilidad (Regla) | CWE | Línea |
|---|---|---|---|
| `src/api/user_handler.py` | python.lang.security.audit.formatted-sql-query.formatted-sql-query | CWE-89 | 19 |
| `src/api/user_handler.py` | python.sqlalchemy.security.sqlalchemy-execute-raw-query.sqlalchemy-execute-raw-query | CWE-89 | 19 |
| `src/api/user_handler.py` | python.sqlalchemy.security.sqlalchemy-execute-raw-query.sqlalchemy-execute-raw-query | CWE-89 | 27 |
| `src/api/user_handler.py` | python.lang.security.audit.subprocess-shell-true.subprocess-shell-true | CWE-78 | 34 |
| `src/api/user_handler.py` | python.lang.security.deserialization.pickle.avoid-pickle | CWE-502 | 61 |
| `src/api/user_handler.py` | python.lang.security.audit.md5-used-as-password.md5-used-as-password | CWE-327 | 72 |
| `src/api/user_handler.py` | python.lang.security.insecure-hash-algorithms.insecure-hash-algorithm-sha1 | CWE-327 | 77 |
| `src/api/user_handler.py` | python.lang.security.audit.dynamic-urllib-use-detected.dynamic-urllib-use-detected | CWE-20 | 91 |
| `src/api/user_handler.py` | python.flask.security.audit.directly-returned-format-string.directly-returned-format-string | CWE-79 | 98 |
| `src/api/user_handler.py` | python.django.security.injection.raw-html-format.raw-html-format | CWE-79 | 98 |
| `src/api/user_handler.py` | python.flask.security.injection.raw-html-concat.raw-html-format | CWE-79 | 98 |
| `src/api/user_handler.py` | python.lang.security.audit.eval-detected.eval-detected | CWE-95 | 112 |
| `src/api/user_handler.py` | python.lang.security.audit.exec-detected.exec-detected | CWE-78 | 118 |
| `src/app.py` | python.flask.security.audit.app-run-param-config.avoid_app_run_with_bad_host | CWE-200 | 50 |
| `src/app.py` | python.flask.security.audit.debug-enabled.debug-enabled | CWE-200 | 50 |
| `src/routes/auth.py` | python.lang.security.audit.md5-used-as-password.md5-used-as-password | CWE-327 | 21 |
| `src/routes/auth.py` | python.jwt.security.jwt-hardcode.jwt-python-hardcoded-secret | CWE-798 | 27 |
| `src/routes/auth.py` | python.lang.security.audit.md5-used-as-password.md5-used-as-password | CWE-327 | 46 |
| `src/routes/auth.py` | python.django.security.injection.tainted-sql-string.tainted-sql-string | CWE-89 | 49 |
| `src/routes/auth.py` | python.flask.security.injection.tainted-sql-string.tainted-sql-string | CWE-89 | 49 |
| `src/routes/tasks.py` | python.django.security.injection.sql.sql-injection-using-db-cursor-execute.sql-injection-db-cursor-execute | CWE-89 | 16 |
| `src/routes/tasks.py` | python.django.security.injection.sql.sql-injection-using-db-cursor-execute.sql-injection-db-cursor-execute | CWE-89 | 17 |
| `src/routes/tasks.py` | python.django.security.injection.tainted-sql-string.tainted-sql-string | CWE-89 | 24 |
| `src/routes/tasks.py` | python.flask.security.injection.tainted-sql-string.tainted-sql-string | CWE-89 | 24 |
| `src/routes/tasks.py` | python.django.security.injection.tainted-sql-string.tainted-sql-string | CWE-89 | 26 |
| `src/routes/tasks.py` | python.flask.security.injection.tainted-sql-string.tainted-sql-string | CWE-89 | 26 |
| `src/routes/tasks.py` | python.flask.security.injection.tainted-sql-string.tainted-sql-string | CWE-89 | 41 |
| `src/routes/tasks.py` | python.lang.security.audit.formatted-sql-query.formatted-sql-query | CWE-89 | 42 |
| `src/routes/tasks.py` | python.sqlalchemy.security.sqlalchemy-execute-raw-query.sqlalchemy-execute-raw-query | CWE-89 | 42 |
| `src/routes/tasks.py` | python.lang.security.audit.eval-detected.eval-detected | CWE-95 | 59 |
| `src/routes/tasks.py` | python.flask.security.injection.subprocess-injection.subprocess-injection | CWE-78 | 85 |
| `src/routes/tasks.py` | python.lang.security.dangerous-subprocess-use.dangerous-subprocess-use | CWE-78 | 85 |
| `src/routes/tasks.py` | python.lang.security.audit.subprocess-shell-true.subprocess-shell-true | CWE-78 | 85 |
| `src/routes/tasks.py` | python.django.security.injection.raw-html-format.raw-html-format | CWE-79 | 97 |
| `src/routes/tasks.py` | python.flask.security.injection.raw-html-concat.raw-html-format | CWE-79 | 97 |
| `src/templates/task.html` | html.security.audit.missing-integrity.missing-integrity | CWE-933 | 36 |
| `src/utils/crypto_utils.py` | python.lang.security.insecure-hash-algorithms.insecure-hash-algorithm-sha1 | CWE-327 | 20 |
| `src/utils/crypto_utils.py` | python.pycryptodome.security.insecure-cipher-algorithm-des.insecure-cipher-algorithm-des | CWE-327 | 30 |
| `src/utils/crypto_utils.py` | python.pycryptodome.security.insufficient-rsa-key-size.insufficient-rsa-key-size | CWE-326 | 64 |
| `src/utils/files.py` | python.django.security.injection.path-traversal.path-traversal-open.path-traversal-open | CWE-22 | 32 |
| `src/utils/files.py` | python.flask.security.injection.path-traversal-open.path-traversal-open | CWE-22 | 35 |
| `src/utils/files.py` | python.lang.security.audit.subprocess-shell-true.subprocess-shell-true | CWE-78 | 72 |

### 3. SCA - Dependencias Vulnerables (Trivy)

#### Python (`requirements.txt`)

| Dependencia | Versión | CVE | Severidad | Versión Corregida |
|---|---|---|---|---|
| Flask | 1.0.0 | CVE-2023-30861 | HIGH | 2.3.2, 2.2.5 |
| Jinja2 | 2.10 | CVE-2019-10906 | HIGH | 2.10.1 |
| Pillow | 8.0.0 | CVE-2021-25289 | CRITICAL | 8.1.1 |
| Pillow | 8.0.0 | CVE-2021-34552 | CRITICAL | 8.3.0 |
| Pillow | 8.0.0 | CVE-2022-22817 | CRITICAL | 9.0.1 |
| Pillow | 8.0.0 | CVE-2023-50447 | CRITICAL | 10.2.0 |
| Pillow | 8.0.0 | CVE-2020-35653 | HIGH | 8.1.0 |
| Pillow | 8.0.0 | CVE-2020-35654 | HIGH | 8.1.0 |
| Pillow | 8.0.0 | CVE-2021-23437 | HIGH | 8.3.2 |
| Pillow | 8.0.0 | CVE-2021-25287 | HIGH | 8.2.0 |
| Pillow | 8.0.0 | CVE-2021-25288 | HIGH | 8.2.0 |
| Pillow | 8.0.0 | CVE-2021-25290 | HIGH | 8.1.1 |
| Pillow | 8.0.0 | CVE-2021-25291 | HIGH | 8.2.0 |
| Pillow | 8.0.0 | CVE-2021-25293 | HIGH | 8.1.1 |
| Pillow | 8.0.0 | CVE-2021-27921 | HIGH | 8.1.2 |
| Pillow | 8.0.0 | CVE-2021-27922 | HIGH | 8.1.2 |
| Pillow | 8.0.0 | CVE-2021-27923 | HIGH | 8.1.2 |
| Pillow | 8.0.0 | CVE-2021-28675 | HIGH | 8.2.0 |
| Pillow | 8.0.0 | CVE-2021-28676 | HIGH | 8.2.0 |
| Pillow | 8.0.0 | CVE-2021-28677 | HIGH | 8.2.0 |
| Pillow | 8.0.0 | CVE-2022-24303 | HIGH | 9.0.1 |
| Pillow | 8.0.0 | CVE-2022-45198 | HIGH | 9.2.0 |
| Pillow | 8.0.0 | CVE-2023-44271 | HIGH | 10.0.0 |
| Pillow | 8.0.0 | CVE-2023-4863 | HIGH | 10.0.1 |
| Pillow | 8.0.0 | CVE-2024-28219 | HIGH | 10.3.0 |
| PyJWT | 1.7.0 | CVE-2022-29217 | HIGH | 2.4.0 |
| PyYAML | 5.1 | CVE-2019-20477 | CRITICAL | 5.2 |
| PyYAML | 5.1 | CVE-2020-14343 | CRITICAL | 5.4 |
| PyYAML | 5.1 | CVE-2020-1747 | CRITICAL | 5.3.1 |
| SQLAlchemy | 1.2.0 | CVE-2019-7164 | CRITICAL | 1.3.0b3, 1.2.18 |
| SQLAlchemy | 1.2.0 | CVE-2019-7548 | CRITICAL | 1.2.19 |
| cryptography | 3.2 | CVE-2020-36242 | HIGH | 3.3.2 |
| cryptography | 3.2 | CVE-2023-0286 | HIGH | 39.0.1 |
| cryptography | 3.2 | CVE-2023-50782 | HIGH | 42.0.0 |
| cryptography | 3.2 | CVE-2026-26007 | HIGH | 46.0.5 |
| gunicorn | 20.0.4 | CVE-2024-1135 | HIGH | 22.0.0 |
| gunicorn | 20.0.4 | CVE-2024-6827 | HIGH | 22.0.0 |

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

| Archivo | Recurso | Vulnerabilidad (Check ID) | Línea |
|---|---|---|---|
| `terraform/ec2.tf` | aws_security_group.web | CKV_AWS_24 | 5 |
| `terraform/ec2.tf` | aws_security_group.web | CKV_AWS_23 | 5 |
| `terraform/ec2.tf` | aws_security_group.web | CKV_AWS_382 | 5 |
| `terraform/ec2.tf` | aws_security_group.web | CKV_AWS_260 | 5 |
| `terraform/ec2.tf` | aws_instance.web | CKV_AWS_8 | 52 |
| `terraform/ec2.tf` | aws_instance.web | CKV_AWS_88 | 52 |
| `terraform/ec2.tf` | aws_instance.web | CKV_AWS_79 | 52 |
| `terraform/ec2.tf` | aws_instance.web | CKV_AWS_135 | 52 |
| `terraform/ec2.tf` | aws_instance.web | CKV_AWS_126 | 52 |
| `terraform/ec2.tf` | aws_subnet.public | CKV_AWS_130 | 97 |
| `terraform/iam.tf` | aws_iam_policy.admin_policy | CKV_AWS_62 | 5 |
| `terraform/iam.tf` | aws_iam_policy.admin_policy | CKV_AWS_290 | 5 |
| `terraform/iam.tf` | aws_iam_policy.admin_policy | CKV_AWS_355 | 5 |
| `terraform/iam.tf` | aws_iam_policy.admin_policy | CKV_AWS_289 | 5 |
| `terraform/iam.tf` | aws_iam_policy.admin_policy | CKV_AWS_287 | 5 |
| `terraform/iam.tf` | aws_iam_policy.admin_policy | CKV_AWS_286 | 5 |
| `terraform/iam.tf` | aws_iam_policy.admin_policy | CKV_AWS_288 | 5 |
| `terraform/iam.tf` | aws_iam_policy.admin_policy | CKV_AWS_63 | 5 |
| `terraform/iam.tf` | aws_iam_role.vulnerable_role | CKV_AWS_60 | 23 |
| `terraform/iam.tf` | aws_iam_user.admin_user | CKV_AWS_273 | 42 |
| `terraform/iam.tf` | aws_iam_user_policy.admin_inline | CKV_AWS_290 | 50 |
| `terraform/iam.tf` | aws_iam_user_policy.admin_inline | CKV_AWS_355 | 50 |
| `terraform/iam.tf` | aws_iam_user_policy.admin_inline | CKV_AWS_289 | 50 |
| `terraform/iam.tf` | aws_iam_user_policy.admin_inline | CKV_AWS_40 | 50 |
| `terraform/iam.tf` | aws_iam_user_policy.admin_inline | CKV_AWS_287 | 50 |
| `terraform/iam.tf` | aws_iam_user_policy.admin_inline | CKV_AWS_286 | 50 |
| `terraform/iam.tf` | aws_iam_user_policy.admin_inline | CKV_AWS_288 | 50 |
| `terraform/iam.tf` | aws_iam_group_policy.developer_policy | CKV_AWS_355 | 81 |
| `terraform/iam.tf` | aws_iam_group_policy.developer_policy | CKV_AWS_289 | 81 |
| `terraform/iam.tf` | aws_iam_group_policy.developer_policy | CKV_AWS_287 | 81 |
| `terraform/iam.tf` | aws_iam_group_policy.developer_policy | CKV_AWS_286 | 81 |
| `terraform/lambda.tf` | aws_lambda_function.vulnerable_lambda | CKV_AWS_173 | 5 |
| `terraform/lambda.tf` | aws_lambda_function.vulnerable_lambda | CKV_AWS_117 | 5 |
| `terraform/lambda.tf` | aws_lambda_function.vulnerable_lambda | CKV_AWS_116 | 5 |
| `terraform/lambda.tf` | aws_lambda_function.vulnerable_lambda | CKV_AWS_50 | 5 |
| `terraform/lambda.tf` | aws_lambda_function.vulnerable_lambda | CKV_AWS_115 | 5 |
| `terraform/lambda.tf` | aws_lambda_function.vulnerable_lambda | CKV_AWS_363 | 5 |
| `terraform/lambda.tf` | aws_lambda_function.vulnerable_lambda | CKV_AWS_272 | 5 |
| `terraform/lambda.tf` | aws_iam_role_policy_attachment.lambda_admin | CKV_AWS_274 | 48 |
| `terraform/lambda.tf` | aws_lambda_function_url.public_url | CKV_AWS_258 | 54 |
| `terraform/lambda.tf` | aws_cloudwatch_log_group.lambda_logs | CKV_AWS_158 | 67 |
| `terraform/lambda.tf` | aws_lambda_permission.public_invoke | CKV_AWS_301 | 74 |
| `terraform/rds.tf` | aws_db_instance.postgres | CKV_AWS_293 | 7 |
| `terraform/rds.tf` | aws_db_instance.postgres | CKV_AWS_17 | 7 |
| `terraform/rds.tf` | aws_db_instance.postgres | CKV_AWS_129 | 7 |
| `terraform/rds.tf` | aws_db_instance.postgres | CKV_AWS_118 | 7 |
| `terraform/rds.tf` | aws_db_instance.postgres | CKV_AWS_353 | 7 |
| `terraform/rds.tf` | aws_db_instance.postgres | CKV_AWS_16 | 7 |
| `terraform/rds.tf` | aws_db_instance.postgres | CKV_AWS_133 | 7 |
| `terraform/rds.tf` | aws_db_instance.postgres | CKV_AWS_226 | 7 |
| `terraform/rds.tf` | aws_db_instance.postgres | CKV_AWS_157 | 7 |
| `terraform/rds.tf` | aws_db_instance.postgres | CKV_AWS_161 | 7 |
| `terraform/s3.tf` | aws_s3_bucket_policy.uploads_policy | CKV_AWS_70 | 19 |
| `terraform/s3.tf` | aws_s3_bucket_public_access_block.uploads_public_access | CKV_AWS_53 | 37 |
| `terraform/s3.tf` | aws_s3_bucket_public_access_block.uploads_public_access | CKV_AWS_55 | 37 |
| `terraform/s3.tf` | aws_s3_bucket_public_access_block.uploads_public_access | CKV_AWS_54 | 37 |
| `terraform/s3.tf` | aws_s3_bucket_public_access_block.uploads_public_access | CKV_AWS_56 | 37 |
| `terraform/s3.tf` | aws_s3_bucket.uploads | CKV_AWS_145 | 7 |
| `terraform/s3.tf` | aws_s3_bucket.logs | CKV_AWS_145 | 47 |
| `terraform/s3.tf` | aws_s3_bucket.uploads | CKV2_AWS_61 | 7 |
| `terraform/s3.tf` | aws_s3_bucket.logs | CKV2_AWS_61 | 47 |
| `terraform/s3.tf` | aws_s3_bucket.uploads | CKV2_AWS_6 | 7 |
| `terraform/s3.tf` | aws_s3_bucket.logs | CKV2_AWS_6 | 47 |
| `terraform/s3.tf` | aws_s3_bucket.uploads | CKV_AWS_21 | 7 |
| `terraform/s3.tf` | aws_s3_bucket.logs | CKV_AWS_21 | 47 |
| `terraform/iam.tf` | aws_iam_policy.admin_policy | CKV2_AWS_40 | 5 |
| `terraform/ec2.tf` | aws_vpc.main | CKV2_AWS_12 | 87 |
| `terraform/s3.tf` | aws_s3_bucket.uploads | CKV_AWS_18 | 7 |
| `terraform/s3.tf` | aws_s3_bucket.logs | CKV_AWS_18 | 47 |
| `terraform/lambda.tf` | aws_lambda_function.vulnerable_lambda | CKV2_AWS_75 | 5 |
| `terraform/rds.tf` | aws_db_instance.postgres | CKV2_AWS_30 | 7 |
| `terraform/s3.tf` | aws_s3_bucket.uploads | CKV2_AWS_62 | 7 |
| `terraform/s3.tf` | aws_s3_bucket.logs | CKV2_AWS_62 | 47 |
| `terraform/ec2.tf` | aws_vpc.main | CKV2_AWS_11 | 87 |
| `terraform/s3.tf` | aws_s3_bucket.uploads | CKV_AWS_144 | 7 |
| `terraform/s3.tf` | aws_s3_bucket.logs | CKV_AWS_144 | 47 |
| `terraform/s3.tf` | aws_s3_bucket.uploads | CKV_AWS_20 | 7 |
| `terraform/ec2.tf` | aws_instance.web | CKV2_AWS_41 | 52 |
| `terraform/rds.tf` | aws_db_instance.postgres | CKV2_AWS_60 | 7 |

#### Kubernetes

| Archivo | Recurso | Vulnerabilidad (Check ID) | Línea |
|---|---|---|---|
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_31 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_29 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_13 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_40 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_39 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_16 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_17 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_28 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_21 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_19 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_27 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_22 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_23 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_9 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_38 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_10 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_20 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_37 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_12 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_8 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_25 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_43 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_11 | 3 |
| `k8s/deployment.yaml` | Deployment.default.taskmanager | CKV_K8S_14 | 3 |
| `k8s/insecure-pod.yaml` | Pod.default.insecure-app | CKV_K8S_18 | 3 |
| `k8s/deployment.yaml` | Pod.default.taskmanager.app-taskmanager | CKV2_K8S_6 | 3 |

#### Dockerfile

| Archivo | Recurso | Vulnerabilidad (Check ID) | Línea |
|---|---|---|---|
| `Dockerfile` | /Dockerfile.EXPOSE | CKV_DOCKER_1 | 22 |
| `Dockerfile` | /Dockerfile. | CKV_DOCKER_3 | 1 |
| `Dockerfile.worker` | /Dockerfile.worker.FROM | CKV_DOCKER_7 | 1 |
| `Dockerfile.worker` | /Dockerfile.worker. | CKV_DOCKER_2 | 1 |
| `k8s/insecure-pod.yaml` | 4be16fa962e0608739c80c244f4f8ffe9d1a7142 | CKV_SECRET_6 | 47 |
| `terraform/ec2.tf` | 892a6ffafdfb0255bab8a35c5dd8f64630276e8b | CKV_SECRET_2 | 76 |

#### GitHub Actions

> **Nota de Seguridad:** El workflow `.github/workflows/cicd-security-scanner.yml` presenta la vulnerabilidad **CKV_GHA_7**, que advierte sobre el uso de `workflow_dispatch` con `inputs`. Esto podría permitir a un usuario con permisos de escritura manipular los parámetros del pipeline. Aunque es un riesgo de seguridad, se ha mantenido intencionadamente en este repositorio de prueba para demostrar la detección de malas configuraciones en pipelines CI/CD. En un entorno de producción, se recomienda eliminar los `inputs` o implementar validaciones estrictas.

| Archivo | Recurso | Vulnerabilidad (Check ID) | Línea |
|---|---|---|---|
| `.github/workflows/security.yml` | on(Security Pipeline) | CKV_GHA_7 | 3 |

### 5. Container - Imagen Vulnerable (Trivy)

| Archivo | Tipo | Vulnerabilidad (ID) | Severidad | Mensaje | Línea |
|---|---|---|---|---|---|
| `Dockerfile` | dockerfile | DS002 | HIGH | Specify at least 1 USER command in Dockerfile with non-root user as argument | 1 |
| `Dockerfile` | dockerfile | DS029 | HIGH | '--no-install-recommends' flag is missed: 'apt-get update && apt-get install -y     curl     wget     netcat-openbsd     vim     strace     tcpdump' | 26 |
| `Dockerfile` | dockerfile | DS031 | CRITICAL | Possible exposure of secret env "API_KEY" in ARG | 13 |
| `Dockerfile` | dockerfile | DS031 | CRITICAL | Possible exposure of secret env "AWS_ACCESS_KEY_ID" in ENV | 18 |
| `Dockerfile` | dockerfile | DS031 | CRITICAL | Possible exposure of secret env "SECRET_KEY" in ENV | 17 |
| `Dockerfile.worker` | dockerfile | DS002 | HIGH | Specify at least 1 USER command in Dockerfile with non-root user as argument | 1 |
| `Dockerfile.worker` | dockerfile | DS029 | HIGH | '--no-install-recommends' flag is missed: 'apt-get update &&     apt-get install -y     curl     wget     telnet     netcat     nmap     ssh     vim     sudo' | 16 |
| `Dockerfile.worker` | dockerfile | DS031 | CRITICAL | Possible exposure of secret env "ENCRYPTION_KEY" in ENV | 13 |
| `Dockerfile.worker` | dockerfile | DS031 | CRITICAL | Possible exposure of secret env "JWT_SIGNING_KEY" in ENV | 12 |
| `Dockerfile.worker` | dockerfile | DS031 | CRITICAL | Possible exposure of secret env "MYSQL_ROOT_PASSWORD" in ENV | 10 |
| `Dockerfile.worker` | dockerfile | DS031 | CRITICAL | Possible exposure of secret env "REDIS_PASSWORD" in ENV | 11 |
| `k8s/deployment.yaml` | kubernetes | KSV005 | HIGH | Container 'taskmanager' of Deployment 'taskmanager' should not include 'SYS_ADMIN' in 'securityContext.capabilities.add' | 23 |
| `k8s/deployment.yaml` | kubernetes | KSV006 | HIGH | Deployment 'taskmanager' should not specify '/var/run/docker.socker' in 'spec.template.volumes.hostPath.path' | 10 |
| `k8s/deployment.yaml` | kubernetes | KSV009 | HIGH | Deployment 'taskmanager' should not set 'spec.template.spec.hostNetwork' to true | 10 |
| `k8s/deployment.yaml` | kubernetes | KSV010 | HIGH | Deployment 'taskmanager' should not set 'spec.template.spec.hostPID' to true | 10 |
| `k8s/deployment.yaml` | kubernetes | KSV014 | HIGH | Container 'taskmanager' of Deployment 'taskmanager' should set 'securityContext.readOnlyRootFilesystem' to true | 23 |
| `k8s/deployment.yaml` | kubernetes | KSV017 | HIGH | Container 'taskmanager' of Deployment 'taskmanager' should set 'securityContext.privileged' to false | 23 |
| `k8s/deployment.yaml` | kubernetes | KSV118 | HIGH | deployment taskmanager in default namespace is using the default security context, which allows root privileges | 19 |
| `k8s/insecure-pod.yaml` | kubernetes | KSV005 | HIGH | Container 'app' of Pod 'insecure-app' should not include 'SYS_ADMIN' in 'securityContext.capabilities.add' | 21 |
| `k8s/insecure-pod.yaml` | kubernetes | KSV006 | HIGH | Pod 'insecure-app' should not specify '/var/run/docker.socker' in 'spec.template.volumes.hostPath.path' | 9 |
| `k8s/insecure-pod.yaml` | kubernetes | KSV008 | HIGH | Pod 'insecure-app' should not set 'spec.template.spec.hostIPC' to true | 9 |
| `k8s/insecure-pod.yaml` | kubernetes | KSV009 | HIGH | Pod 'insecure-app' should not set 'spec.template.spec.hostNetwork' to true | 9 |
| `k8s/insecure-pod.yaml` | kubernetes | KSV010 | HIGH | Pod 'insecure-app' should not set 'spec.template.spec.hostPID' to true | 9 |
| `k8s/insecure-pod.yaml` | kubernetes | KSV014 | HIGH | Container 'app' of Pod 'insecure-app' should set 'securityContext.readOnlyRootFilesystem' to true | 21 |
| `k8s/insecure-pod.yaml` | kubernetes | KSV017 | HIGH | Container 'app' of Pod 'insecure-app' should set 'securityContext.privileged' to false | 21 |
| `k8s/insecure-pod.yaml` | kubernetes | KSV121 | HIGH | pod insecure-app in default namespace shouldn't have volumes set to {"/", "/etc"} | 9 |
| `terraform/ec2.tf` | terraform | AVD-AWS-0028 | HIGH | Instance does not require IMDS access to require a token. | 52 |
| `terraform/ec2.tf` | terraform | aws-autoscaling-no-public-ip | CRITICAL | Sensitive data found in instance user data: Password literal text | 74 |
| `terraform/ec2.tf` | terraform | aws-vpc-no-public-egress-sgr | CRITICAL | Security group rule allows unrestricted egress to any IP address. | 42 |
| `terraform/ec2.tf` | terraform | AVD-AWS-0107 | HIGH | Security group rule allows unrestricted ingress from any IP address. | 16 |
| `terraform/ec2.tf` | terraform | AVD-AWS-0131 | HIGH | Root block device is not encrypted. | 70 |
| `terraform/ec2.tf` | terraform | aws-vpc-no-public-ingress-sgr | HIGH | Subnet associates public IP address. | 101 |
| `terraform/rds.tf` | terraform | AVD-AWS-0080 | HIGH | Instance does not have storage encryption enabled. | 26 |
| `terraform/rds.tf` | terraform | AVD-AWS-0180 | HIGH | Instance has Public Access enabled | 23 |
| `terraform/s3.tf` | terraform | AVD-AWS-0086 | HIGH | No public access block so not blocking public acls | 47 |
| `terraform/s3.tf` | terraform | AVD-AWS-0086 | HIGH | Public access block does not block public ACLs | 40 |
| `terraform/s3.tf` | terraform | AVD-AWS-0087 | HIGH | No public access block so not blocking public policies | 47 |
| `terraform/s3.tf` | terraform | AVD-AWS-0087 | HIGH | Public access block does not block public policies | 41 |
| `terraform/s3.tf` | terraform | AVD-AWS-0088 | HIGH | Bucket does not have encryption enabled | 47 |
| `terraform/s3.tf` | terraform | AVD-AWS-0088 | HIGH | Bucket does not have encryption enabled | 7 |
| `terraform/s3.tf` | terraform | AVD-AWS-0091 | HIGH | No public access block so not blocking public acls | 47 |
| `terraform/s3.tf` | terraform | AVD-AWS-0091 | HIGH | Public access block does not ignore public ACLs | 42 |
| `terraform/s3.tf` | terraform | AVD-AWS-0092 | HIGH | Bucket has a public ACL: "public-read" | 11 |
| `terraform/s3.tf` | terraform | AVD-AWS-0093 | HIGH | No public access block so not restricting public buckets | 47 |
| `terraform/s3.tf` | terraform | AVD-AWS-0093 | HIGH | Public access block does not restrict public buckets | 43 |
| `terraform/s3.tf` | terraform | AVD-AWS-0132 | HIGH | Bucket does not encrypt data with a customer managed key. | 47 |
| `terraform/s3.tf` | terraform | AVD-AWS-0132 | HIGH | Bucket does not encrypt data with a customer managed key. | 7 |

---

## 📊 Resultados Esperados

Ejecutando los scanners (default) deberías obtener aproximadamente:

| Scanner | Findings |
|---------|----------|
| **Secrets** | ~25 |
| **SAST** | ~26 |
| **SCA** | ~37 |
| **IaC** | ~79 |
| **Container** | ~33 |

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

### Salida esperada

```
Repository: C:\Users\Laura\Documents\GitHub\vulnerable-test-app
Starting scanners...

Select tool for Secrets:

  1) gitleaks
  2) trufflehog
  0) Use default (gitleaks)
Choice [enter=default]: 

==> Running Secrets scanner (image: cicd-secret-scanner)

🔐 Secret Scanner
   Tool: gitleaks
   Mode: files
[*] Tool: Gitleaks
[*] Scanning current files on disk...
...
[OK] Secrets: 29 findings -> results-secret.sarif

Select tool for SAST:

  1) semgrep
  2) bandit
  0) Use default (semgrep)
Choice [enter=default]:

==> Running SAST scanner (image: cicd-sast-scanner)
...

========================================== 
  SUMMARY
========================================== 

  results-container.sarif: 33 findings
  results-iac.sarif: 79 findings
  results-sast.sarif: 26 findings
  results-sca.sarif: 37 findings
  results-secret.sarif: 25 findings        

Test complete!
```

#### Troubleshooting Windows

Si ves caracteres extraños (ƒôè, Ô£à, etc.):

```powershell
# Establecer encoding UTF-8 antes de ejecutar
chcp 65001
.\test-scanners.ps1
```

---

### Selección de herramienta (breve)

Los scripts `test-scanners.sh` y `test-scanners.ps1` permiten elegir la herramienta de escaneo (por ejemplo `gitleaks`, `trufflehog`, `semgrep`, `bandit`, `trivy`, `grype`, `checkov`). Si prefieres evitar prompts o seleccionar una herramienta explícita, ejecuta el contenedor pasando la variable de entorno `TOOL` con `docker run`.

Ejemplo:

```bash
docker run --rm -v $(pwd):/scan -e TOOL=trufflehog cicd-secret-scanner
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
