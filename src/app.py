"""
TaskManager - Main Application
Flask web application for task management
"""
from flask import Flask, jsonify
from routes.auth import auth_bp
from routes.tasks import tasks_bp
from config import DEBUG, SECRET_KEY

app = Flask(__name__)

# VULN: Insecure configuration
app.config['DEBUG'] = DEBUG  # VULN: Debug enabled
app.config['SECRET_KEY'] = SECRET_KEY
app.config['SESSION_COOKIE_SECURE'] = False  # VULN: Cookies without secure flag
app.config['SESSION_COOKIE_HTTPONLY'] = False  # VULN: Cookies accessible from JS

# Register blueprints
app.register_blueprint(auth_bp, url_prefix='/api/auth')
app.register_blueprint(tasks_bp, url_prefix='/api/tasks')


@app.route('/')
def index():
    return jsonify({
        'app': 'TaskManager',
        'version': '1.0.0',
        # VULN: Information disclosure
        'debug': app.config['DEBUG'],
        'environment': 'production'
    })


@app.route('/health')
def health():
    return jsonify({'status': 'healthy'})


@app.errorhandler(500)
def handle_500(error):
    # VULN: Stack trace exposed in errors
    return jsonify({
        'error': str(error),
        'trace': str(error.__traceback__)  # VULN: Sensitive information
    }), 500


if __name__ == '__main__':
    # VULN: Bind to 0.0.0.0 exposes to the whole network
    app.run(host='0.0.0.0', port=5000, debug=True)
