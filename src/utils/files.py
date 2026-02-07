"""
File handling utilities
"""
import os
from flask import send_file, request

UPLOAD_FOLDER = '/app/uploads'
ALLOWED_EXTENSIONS = {'txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'}


def get_file(filename):
    """
    Retrieve a file from the uploads folder
    VULN: Path traversal vulnerability (Semgrep: path-traversal)
    """
    # VULN: No sanitización del path - permite ../../../etc/passwd
    filepath = os.path.join(UPLOAD_FOLDER, filename)
    
    # Debería verificar que el path está dentro de UPLOAD_FOLDER
    # Correcto: filepath = os.path.realpath(filepath)
    #           if not filepath.startswith(os.path.realpath(UPLOAD_FOLDER)):
    #               raise SecurityException("Invalid path")
    
    return send_file(filepath)


def download_file():
    """
    Download file by user-provided path
    VULN: Arbitrary file read (Semgrep: arbitrary-file-read)
    """
    file_path = request.args.get('path')
    
    # VULN: Lectura directa de archivo sin validación
    with open(file_path, 'r') as f:
        content = f.read()
    
    return content


def save_upload(file, user_path):
    """
    Save uploaded file
    VULN: Arbitrary file write 
    """
    # VULN: Permite escribir en cualquier ubicación
    full_path = user_path  # Debería ser: os.path.join(UPLOAD_FOLDER, secure_filename(user_path))
    
    with open(full_path, 'wb') as f:
        f.write(file.read())
    
    return full_path


def allowed_file(filename):
    """Check if file extension is allowed"""
    # VULN: Solo verifica extensión, no el contenido real del archivo
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


def execute_script(script_name):
    """
    Execute a script from scripts folder
    VULN: Command injection possibility
    """
    import subprocess
    
    # VULN: shell=True con input no sanitizado
    result = subprocess.run(
        f'/app/scripts/{script_name}',
        shell=True,
        capture_output=True
    )
    
    return result.stdout.decode()
