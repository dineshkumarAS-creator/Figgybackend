from flask import Flask, jsonify
from flask_cors import CORS
from app.routes.worker import worker_bp
from app.routes.terms import terms_bp

def create_app():
    """App factory function to initialize Flask application."""
    app = Flask(__name__)
    
    # Configure CORS for all domains or specific ones if needed
    CORS(app)
    
    # Load settings from config object
    app.config.from_object('config.Config')

    # Register Blueprints
    app.register_blueprint(worker_bp)
    app.register_blueprint(terms_bp)

    # Health check endpoint
    @app.route('/health', methods=['GET'])
    def health():
        return jsonify({"status": "ok"}), 200

    return app
