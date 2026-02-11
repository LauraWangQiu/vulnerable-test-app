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
    # VULN: No path sanitization - allows ../../../etc/passwd
    filepath = os.path.join(UPLOAD_FOLDER, filename)
    
    # Should check that the path is inside UPLOAD_FOLDER
    # Correct: filepath = os.path.realpath(filepath)
    #          if not filepath.startswith(os.path.realpath(UPLOAD_FOLDER)):
    #              raise SecurityException("Invalid path")
    
    return send_file(filepath)


def download_file():
    """
    Download file by user-provided path
    VULN: Arbitrary file read (Semgrep: arbitrary-file-read)
    """
    file_path = request.args.get('path')
    
    # VULN: Direct file read without validation
    with open(file_path, 'r') as f:
        content = f.read()
    
    return content


def save_upload(file, user_path):
    """
    Save uploaded file
    VULN: Arbitrary file write 
    """
    # VULN: Allows writing to any location
    full_path = user_path  # Should be: os.path.join(UPLOAD_FOLDER, secure_filename(user_path))
    
    with open(full_path, 'wb') as f:
        f.write(file.read())
    
    return full_path


def allowed_file(filename):
    """Check if file extension is allowed"""
    # VULN: Only checks extension, not actual file content
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


def execute_script(script_name):
    """
    Execute a script from scripts folder
    VULN: Command injection possibility
    """
    import subprocess
    
    # VULN: shell=True with unsanitized input
    result = subprocess.run(
        f'/app/scripts/{script_name}',
        shell=True,
        capture_output=True
    )
    
    return result.stdout.decode()
