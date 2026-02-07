"""
Email utilities for TaskManager
"""
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# VULN: SMTP credentials hardcodeadas (Gitleaks)
SMTP_CONFIG = {
    "server": "smtp.gmail.com",
    "port": 587,
    "username": "taskmanager.app@gmail.com",
    "password": "xmtp-app-password-12345"  # VULN: Hardcoded SMTP password
}

# VULN: SendGrid API key
SENDGRID_KEY = "SG.xxxxxx-xxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"


def send_email(to_email, subject, body):
    """Send email notification"""
    msg = MIMEMultipart()
    msg['From'] = SMTP_CONFIG['username']
    msg['To'] = to_email
    msg['Subject'] = subject
    
    msg.attach(MIMEText(body, 'html'))
    
    try:
        server = smtplib.SMTP(SMTP_CONFIG['server'], SMTP_CONFIG['port'])
        server.starttls()
        # VULN: Usando credenciales hardcodeadas
        server.login(SMTP_CONFIG['username'], SMTP_CONFIG['password'])
        server.send_message(msg)
        server.quit()
        return True
    except Exception as e:
        print(f"Email error: {e}")
        return False


def send_password_reset(email, reset_token):
    """Send password reset email"""
    # VULN: Token expuesto en URL sin cifrar
    reset_link = f"https://taskmanager.com/reset?token={reset_token}&email={email}"
    
    body = f"""
    <html>
    <body>
        <h2>Password Reset Request</h2>
        <p>Click the link below to reset your password:</p>
        <a href="{reset_link}">Reset Password</a>
        <p>This link expires in 24 hours.</p>
    </body>
    </html>
    """
    
    return send_email(email, "Password Reset - TaskManager", body)


def send_notification(user_email, task_title):
    """Send task notification"""
    # VULN: XSS en email si task_title no está sanitizado
    body = f"""
    <html>
    <body>
        <h2>Task Update</h2>
        <p>Your task "{task_title}" has been updated.</p>
    </body>
    </html>
    """
    
    return send_email(user_email, f"Task Update: {task_title}", body)
