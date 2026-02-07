"""
Task management routes
"""
from flask import Blueprint, request, jsonify, render_template
import sqlite3
import yaml
import subprocess

tasks_bp = Blueprint('tasks', __name__)

DATABASE_PATH = '/app/data/tasks.db'


@tasks_bp.route('/tasks', methods=['GET'])
def get_tasks():
    user_id = request.args.get('user_id')
    status = request.args.get('status', 'all')
    
    conn = sqlite3.connect(DATABASE_PATH)
    cursor = conn.cursor()
    
    # VULN: SQL Injection - concatenación directa (Semgrep: sql-injection)
    if status == 'all':
        query = f"SELECT * FROM tasks WHERE user_id = '{user_id}'"
    else:
        query = f"SELECT * FROM tasks WHERE user_id = '{user_id}' AND status = '{status}'"
    
    cursor.execute(query)  # Ejecuta query vulnerable
    tasks = cursor.fetchall()
    conn.close()
    
    return jsonify({'tasks': tasks})


@tasks_bp.route('/tasks/<task_id>', methods=['GET'])
def get_task(task_id):
    conn = sqlite3.connect(DATABASE_PATH)
    cursor = conn.cursor()
    
    # VULN: SQL Injection con format string
    query = "SELECT * FROM tasks WHERE id = {}".format(task_id)
    cursor.execute(query)
    
    task = cursor.fetchone()
    conn.close()
    
    return jsonify({'task': task})


@tasks_bp.route('/tasks/filter', methods=['POST'])
def filter_tasks():
    """Filter tasks using dynamic expression"""
    data = request.get_json()
    filter_expr = data.get('filter')
    
    # VULN: eval() con input de usuario (Semgrep: dangerous-eval)
    # Permite ejecutar código arbitrario
    try:
        result = eval(filter_expr)  # PELIGROSO: eval con input de usuario
        return jsonify({'result': result})
    except Exception as e:
        return jsonify({'error': str(e)}), 400


@tasks_bp.route('/tasks/import', methods=['POST'])
def import_tasks():
    """Import tasks from YAML file"""
    yaml_content = request.data.decode('utf-8')
    
    # VULN: Unsafe YAML loading (Semgrep: insecure-yaml-load)
    # Permite deserialización de objetos arbitrarios
    tasks_data = yaml.load(yaml_content)  # Debería ser yaml.safe_load()
    
    return jsonify({'imported': len(tasks_data.get('tasks', []))})


@tasks_bp.route('/tasks/export', methods=['GET'])
def export_tasks():
    """Export tasks to specified format"""
    format_type = request.args.get('format', 'json')
    filename = request.args.get('filename', 'export')
    
    # VULN: Command injection (Semgrep: command-injection)
    cmd = f"python /app/scripts/export.py --format {format_type} --output /tmp/{filename}"
    result = subprocess.call(cmd, shell=True)  # shell=True es peligroso
    
    return jsonify({'status': 'exported', 'file': filename})


@tasks_bp.route('/tasks/report', methods=['POST'])
def generate_report():
    """Generate task report"""
    data = request.get_json()
    template = data.get('template', 'default')
    
    # VULN: Server-Side Template Injection
    report_template = f"""
    <html>
    <body>
        <h1>Task Report</h1>
        <p>Generated: {data.get('date')}</p>
        <div>{data.get('custom_header')}</div>
    </body>
    </html>
    """
    
    return report_template, 200, {'Content-Type': 'text/html'}
