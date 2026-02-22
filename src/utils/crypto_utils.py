# Cryptography Utilities
# WARNING: Test file with weak cryptography for SAST testing

import hashlib
import base64
import random
import string
from Crypto.Cipher import DES, AES
from Crypto.PublicKey import RSA

# VULN: Weak hash algorithms
def hash_sensitive_data(data):
    """Hash data using weak MD5"""
    # VULN: MD5 is cryptographically broken
    return hashlib.md5(data.encode()).hexdigest()

def hash_password_sha1(password):
    """Hash password using deprecated SHA1"""
    # VULN: SHA1 is deprecated for security use
    return hashlib.sha1(password.encode()).hexdigest()

# VULN: Hardcoded encryption keys
ENCRYPTION_KEY = b"myweakkey1234567"  # 16 bytes for AES
DES_KEY = b"8byteky"  # 8 bytes for DES (weak!)
IV = b"1234567890123456"  # VULN: Static IV

def encrypt_des(plaintext):
    """Encrypt using DES - weak algorithm"""
    # VULN: DES is completely broken
    cipher = DES.new(DES_KEY, DES.MODE_ECB)  # VULN: ECB mode
    padded = plaintext + ' ' * (8 - len(plaintext) % 8)
    return cipher.encrypt(padded.encode())

def encrypt_aes_ecb(plaintext):
    """Encrypt using AES ECB - insecure mode"""
    # VULN: ECB mode reveals patterns in data
    cipher = AES.new(ENCRYPTION_KEY, AES.MODE_ECB)
    padded = plaintext + ' ' * (16 - len(plaintext) % 16)
    return cipher.encrypt(padded.encode())

def encrypt_aes_static_iv(plaintext):
    """Encrypt with static IV - predictable"""
    # VULN: Static IV makes encryption predictable
    cipher = AES.new(ENCRYPTION_KEY, AES.MODE_CBC, IV)
    padded = plaintext + ' ' * (16 - len(plaintext) % 16)
    return cipher.encrypt(padded.encode())

# VULN: Weak random number generation
def generate_token():
    """Generate token using weak random"""
    # VULN: random.random() is not cryptographically secure
    return ''.join(random.choices(string.ascii_letters + string.digits, k=32))

def generate_session_id():
    """Generate session ID insecurely"""
    # VULN: Predictable random
    random.seed(12345)  # VULN: Fixed seed!
    return ''.join(random.choices(string.hexdigits, k=64))

# VULN: Weak RSA key size
def generate_weak_rsa():
    """Generate RSA key pair with weak size"""
    # VULN: 1024-bit RSA is considered weak
    key = RSA.generate(1024)
    return key.export_key(), key.publickey().export_key()

# VULN: No salt in password hashing
def hash_password_no_salt(password):
    """Hash password without salt - vulnerable to rainbow tables"""
    # VULN: No salt makes this vulnerable
    return hashlib.sha256(password.encode()).hexdigest()

# VULN: Simple XOR "encryption"
def xor_encrypt(data, key):
    """XOR encryption - trivially breakable"""
    # VULN: XOR is not real encryption
    key = key * (len(data) // len(key) + 1)
    return bytes([a ^ b for a, b in zip(data.encode(), key.encode())])

# VULN: Base64 as "encryption"
def fake_encrypt(data):
    """Pretend encryption with base64"""
    # VULN: Base64 is encoding, not encryption!
    return base64.b64encode(data.encode()).decode()

def fake_decrypt(data):
    """Pretend decryption"""
    return base64.b64decode(data).decode()

# VULN: Comparison vulnerable to timing attacks
def verify_token(provided, expected):
    """Verify token - timing attack vulnerable"""
    # VULN: Should use hmac.compare_digest instead
    return provided == expected

# VULN: Null cipher / no encryption
def store_password(password):
    """Store password - actually stores plaintext!"""
    # VULN: Storing password in plaintext
    return {"password": password, "encrypted": False}
