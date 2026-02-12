# User API Handler
# WARNING: Test file with SAST vulnerabilities

import os
import subprocess
import sqlite3
import pickle
import yaml
import hashlib
from flask import request, jsonify

# VULN: SQL Injection - user input directly in query
def get_user(user_id):
    """Get user by ID - vulnerable to SQL injection"""
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    # VULN: String formatting in SQL query
    query = f"SELECT * FROM users WHERE id = '{user_id}'"
    cursor.execute(query)
    return cursor.fetchone()

def search_users(name):
    """Search users by name - vulnerable to SQL injection"""
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    # VULN: String concatenation in SQL
    cursor.execute("SELECT * FROM users WHERE name LIKE '%" + name + "%'")
    return cursor.fetchall()

# VULN: Command Injection
def ping_server(hostname):
    """Ping a server - vulnerable to command injection"""
    # VULN: Shell=True with user input
    result = subprocess.run(f"ping -c 1 {hostname}", shell=True, capture_output=True)
    return result.stdout.decode()

def process_file(filename):
    """Process uploaded file - vulnerable to command injection"""
    # VULN: User input in os.system
    os.system(f"cat /uploads/{filename}")
    return "File processed"

# VULN: Path Traversal
def read_document(doc_name):
    """Read document - vulnerable to path traversal"""
    # VULN: No path validation
    filepath = f"/documents/{doc_name}"
    with open(filepath, 'r') as f:
        return f.read()

def download_file(filename):
    """Download file - path traversal vulnerability"""
    # VULN: User can traverse directories
    base_path = "/var/www/files"
    return open(base_path + "/" + filename, 'rb').read()

# VULN: Insecure Deserialization
def load_session(session_data):
    """Load session from serialized data - insecure deserialization"""
    # VULN: pickle.loads on untrusted data
    return pickle.loads(session_data)

def parse_config(config_yaml):
    """Parse YAML config - unsafe YAML loading"""
    # VULN: yaml.load without safe_load
    return yaml.load(config_yaml)

# VULN: Weak Cryptography
def hash_password(password):
    """Hash password - using weak algorithm"""
    # VULN: MD5 is cryptographically broken
    return hashlib.md5(password.encode()).hexdigest()

def encrypt_data(data):
    """Encrypt data - using weak algorithm"""
    # VULN: SHA1 is deprecated for security
    return hashlib.sha1(data.encode()).hexdigest()

# VULN: Hardcoded credentials (for SAST detection)
def connect_admin():
    """Admin connection with hardcoded password"""
    admin_password = "admin123"
    api_key = "1234567890abcdef"
    return {"password": admin_password, "key": api_key}

# VULN: SSRF - Server Side Request Forgery
def fetch_url(url):
    """Fetch external URL - SSRF vulnerability"""
    import urllib.request
    # VULN: No URL validation, allows internal network access
    return urllib.request.urlopen(url).read()

# VULN: XSS - reflected in response
def greet_user():
    """Greet user - XSS vulnerability"""
    name = request.args.get('name', '')
    # VULN: User input directly in response without escaping
    return f"<h1>Hello {name}!</h1>"

# VULN: Open Redirect
def redirect_handler():
    """Handle redirect - open redirect vulnerability"""
    from flask import redirect
    next_url = request.args.get('next', '/')
    # VULN: No validation of redirect URL
    return redirect(next_url)

# VULN: Eval on user input
def calculate(expression):
    """Calculate expression - code injection via eval"""
    # VULN: eval() on user-controlled input
    return eval(expression)

# VULN: exec on user input
def run_code(code):
    """Run dynamic code - code injection via exec"""
    # VULN: exec() on user-controlled input
    exec(code)
    return "Code executed"
