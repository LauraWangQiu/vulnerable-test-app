# Authentication credentials module
# WARNING: Test file for security scanner validation

import os

# VULN: Hardcoded AWS credentials
AWS_ACCESS_KEY_ID = "AKIAIOSFODNN7EXAMPLE"
AWS_SECRET_ACCESS_KEY = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
AWS_SESSION_TOKEN = "AQoDYXdzEJr..."

# VULN: Hardcoded database credentials
DB_HOST = "prod-db.example.com"
DB_USER = "admin"
DB_PASSWORD = "SuperSecretPassword123!"
DB_CONNECTION_STRING = "postgresql://admin:SuperSecretPassword123!@prod-db.example.com:5432/production"

# VULN: API Keys
STRIPE_API_KEY = "sk_live_4eC39HqLyjWDarjtT1zdp7dc"
STRIPE_SECRET = "whsec_MfKQ9r8GKYqrTHLZ4w40tPVa"
SENDGRID_API_KEY = "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"
GITHUB_TOKEN = "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"
SLACK_WEBHOOK = "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"

# VULN: Private RSA Key
PRIVATE_KEY = """-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAwS2kSS+JXeR5cby9u6IB8dxPmDTeS2dme/1ApQQROhaVlIsZ
iXOsge8zyNA0RfLlSIlayeDhfU/62j57NvRvSuP64c/q2pN+17+8ZDBbakoo0oci
PKW5pEEI0YwnOwrNFnGFRPuzyPg7NqzVt6yGSKU/BXJ43C+KfrqbFrrT5hdoqLFL
CY0T0nxzXJ2CBk3MCwnbLrtdsQ6oeCydZV7OhvHP30JCagpp29tMmos5vRnK4EvK
5/zkRjK8SXwn7R+k/mDrsHR2sneS4jjKQoXkXDHsqYoMnqtaTolUKba8dF/WU9T3
Esp3b88gHFJ2ZjoXhwMUA7eEUYxaKsSf3BsWkQIDAQABAoIBAGs/zML5Clm/fBFC
SVA/vLarquEFERlp+cMCsn4rCOloGnmS1IW0W+TziZuGxE7FcLhZ0bbdDDOHUO0T
3VKAWL2KXwI5bdkWJEjh4VT6Z/ZV394qOj7Tf4KKvLuiBTHJaF16fxPybjk4X5+W
Sz0jIpZ4b8m1aRZNqqV7Mplm9jf6dgDn5Dv5ZRlCrFwE+Vs3KuYvJ8xupRDB/V/W
XJ7DksCNFB4dJ10ieOjeYsnILcosy0EhaIB8ehQvwDFn5ZyhXIE5qvDEVqXRAFHr
wrzh0w8YcxIh9Lv8ozHsLxikL4KHM45UjlwfK86O97LLDDzDHTaJkBHQjjbErlWk
uRnlmXECgYEA5ogD8NEMTqwhHdeHKjmSQ+ATAQeX3JvTVl9ax+C/XYyCBe8ODEMl
KMkeadK4FMbZV8Zu+BegiN+XCXpQlUgEqixcWMhM2uriqpGmMVxDpcdYGpwxtzHw
QXcJn/w008vhze+ylD3Ywgc5EaVHHVWzz0s8wlhgaykmh9fe56vluv0CgYEA1oUx
OYTaD9EebV+lp2UpMS5R6uFKX7dNcbQKLlvrQZVzuzJho4W/SAPj3CUCDjZkxdRL
WHCYgnzHh30DAszLfqBNHMruzEpzhXYbwcCQTP+d1q15YdC3BaFDgwiRMlqWEROi
3Pg9SAfmn1XPBa1Ck4FyBmsFXpQTTBPDnITYUCUCgYByoXe0K37/L8BX4nAnovEE
J0vL20a8QA/ahxfRBASkM9YDtVc66bh0i21AGbPHQQmaB+XuH3GIHgYwhE3FrUYE
iIJy80akJOAJCNum98X7jSBWOwzNl1tschCrKPHrzxm9GU+nPwmlkYnjKFgwUglT
LopL6T4oixHJwqHoeSWG0QKBgQCeujbOBIsFIQqOizMbRTLRfSCH1uMdJ5haBYly
+/h6sobLgF/WiuQZ+SbkgU2gDodKCecmLUnrY0CP8+QCcl4v95SXNWC0MHKB0f5/
wmgDUTAM5Jbn1XNW6xf1IKWuyHA5enoLXnKZlZ8DTo67+JNGaYVhUlbKwG324Ljg
WztjMQKBgQDl0ExPUfGLxOuS0HPgQ/DA34KJjBtJSTCE9ovzIQyx8Rl+MEJtBfhQ
VWrgLw9fD5xwpAPRualbRcgR/oWClctne5L7JX7u+Hyn2Drq6Z5ARuiGlCoz3/vZ
Vh/VF4EXU5D4icFxVcLM1F+LQr++FpOqb7+qXKAj4WFxTW5ODRQIfg==
-----END RSA PRIVATE KEY-----"""

# VULN: JWT Secret
JWT_SECRET = "super-secret-jwt-key-do-not-share"

def get_db_connection():
    """Connect to database with hardcoded credentials"""
    # VULN: Password in connection string
    return f"mysql://root:rootpassword@localhost:3306/myapp"

def authenticate_api(service):
    """Get API credentials - all hardcoded"""
    credentials = {
        "openai": "sk-proj-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "twilio": "SK2a1b3c4d5e6f7g8h9i0j1k2l3m4n5o6p",
        "mailchimp": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-us1"
    }
    return credentials.get(service)
