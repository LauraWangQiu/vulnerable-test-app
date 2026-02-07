"""
Authentication routes for TaskManager
"""
from flask import Blueprint, request, jsonify
import hashlib
import jwt

# VULN: Hardcoded JWT secret (Semgrep: hardcoded-credentials)
JWT_SECRET = "super-secret-jwt-key-2024"

auth_bp = Blueprint('auth', __name__)


@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')
    
    # VULN: Weak password hashing - MD5 (Semgrep: use-of-md5)
    password_hash = hashlib.md5(password.encode()).hexdigest()
    
    # Simulated database check
    # In real app, this would query the database
    if verify_user(username, password_hash):
        # VULN: Using hardcoded secret for JWT
        token = jwt.encode(
            {'user': username, 'role': 'user'},
            JWT_SECRET,
            algorithm='HS256'
        )
        return jsonify({'token': token})
    
    return jsonify({'error': 'Invalid credentials'}), 401


@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')
    email = data.get('email')
    
    # VULN: No password strength validation
    # VULN: Weak hashing again
    password_hash = hashlib.md5(password.encode()).hexdigest()
    
    # VULN: SQL Injection in f-string (Semgrep: sql-injection)
    query = f"INSERT INTO users (username, password, email) VALUES ('{username}', '{password_hash}', '{email}')"
    
    # execute_query(query)  # Would execute vulnerable query
    
    return jsonify({'message': 'User created'}), 201


@auth_bp.route('/reset-password', methods=['POST'])
def reset_password():
    email = request.form.get('email')
    
    # VULN: Information disclosure - reveals if email exists
    # query = f"SELECT * FROM users WHERE email = '{email}'"
    
    return jsonify({'message': f'If {email} exists, a reset link was sent'})


def verify_user(username, password_hash):
    """Verify user credentials - placeholder"""
    return True  # Placeholder for demo
