import random
import string
from datetime import datetime
from flask import Blueprint, request, jsonify
from app.utils.mock_generator import generate_worker_data
from app.models import db_handler

# 🔥 NEW IMPORT
from app.utils.premium import calculate_premium

# Blueprint
worker_bp = Blueprint('worker', __name__, url_prefix='/api/worker')

def generate_worker_id() -> str:
    """Generates a random unique worker ID: GS- + 6 uppercase chars."""
    chars = string.ascii_uppercase + string.digits
    unique_suffix = ''.join(random.choices(chars, k=6))
    return f"GS-{unique_suffix}"

@worker_bp.route('/fetch', methods=['POST'])
def fetch_worker():
    """POST /api/worker/fetch - Uses deterministic mocking."""
    try:
        data = request.get_json() or {}
        swiggy_id = data.get("swiggy_id")
        phone = data.get("phone")
        identifier = swiggy_id or phone
        
        if not identifier:
            return jsonify({"status": "error", "message": "swiggy_id or phone required"}), 400
            
        mock_data = generate_worker_data(identifier)
        
        # If not in whitelist, check if they are already registered in our local system
        if mock_data is None:
            existing_workers = db_handler.get_all_workers()
            for w in existing_workers:
                if w.get("swiggy_id") == identifier or w.get("phone") == identifier:
                    mock_data = w
                    break
        
        if mock_data is None:
            return jsonify({
                "status": "error", 
                "message": "ID Not Found: This Swiggy ID is not registered in the official partner records."
            }), 404
            
        return jsonify({"status": "success", "data": mock_data}), 200
        
    except Exception as e:
        return jsonify({"status": "error", "message": f"Server Error: {str(e)}"}), 500


@worker_bp.route('/register', methods=['POST'])
def register_worker():
    """POST /api/worker/register - Stores in DB or In-Memory fallback."""
    try:
        body = request.get_json() or {}

        # Support both wrapped and flat data structures
        data = body.get("data", body) if isinstance(body.get("data"), dict) else body
        
        swiggy_id = body.get("swiggy_id") or data.get("swiggy_id")
        phone = body.get("phone") or data.get("phone")
        identifier = swiggy_id or phone
        
        if not identifier:
            return jsonify({"status": "error", "message": "Identifier required for registration"}), 400

        # 🔥 EXISTING LOGIC (keep this)
        avg_daily = data.get("avg_daily_earnings", 0)
        if avg_daily < 700:
            cat, prem = "Low", 10
        elif avg_daily < 1000:
            cat, prem = "Medium", 20
        else:
            cat, prem = "High", 35

        # 🔥 NEW: Dynamic Premium Calculation
        premium_data = calculate_premium(data)

        worker_id = generate_worker_id()

        # 🧪 Merge full mock data
        full_mock_data = generate_worker_data(identifier) or {}

        worker_doc = {
            **full_mock_data,
            "worker_id": worker_id,
            "swiggy_id": swiggy_id,

            # Existing fields
            "income_category": cat,
            "suggested_premium": prem,

            # 🔥 NEW FIELD
            "premium": premium_data,

            "created_at": datetime.now().isoformat(),

            # Merge user input
            **{k: v for k, v in data.items() if k not in ["_id", "worker_id", "created_at"]}
        }

        # Save to DB
        db_handler.insert_worker(worker_doc)

        return jsonify({
            "status": "success",
            "message": "Worker registered successfully",
            "worker_id": worker_id,

            # 🔥 Return premium separately also
            "premium": premium_data,

            "data": worker_doc
        }), 201

    except Exception as e:
        return jsonify({"status": "error", "message": f"Registration Error: {str(e)}"}), 500


@worker_bp.route('/list', methods=['GET'])
def list_workers():
    """GET /api/worker/list - Returns all registered workers."""
    try:
        workers = db_handler.get_all_workers()
        return jsonify({
            "status": "success",
            "count": len(workers),
            "data": workers
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": f"Fetch Error: {str(e)}"}), 500