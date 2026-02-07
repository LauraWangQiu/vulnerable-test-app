"""Routes package"""
from .auth import auth_bp
from .tasks import tasks_bp

__all__ = ['auth_bp', 'tasks_bp']
