import os
from dotenv import load_dotenv

# Load .env file if it exists
load_dotenv()

class Config:
    """Config class for the Flask application."""
    MONGO_URI = os.getenv("MONGO_URI", "mongodb://localhost:27017/figgy")
    # Toggle MongoDB: Set to False to use In-Memory storage (Demo Mode)
    USE_DB = os.getenv("USE_DB", "False").lower() == "true"
    
    # Razorpay Test Keys
    RAZORPAY_KEY_ID = os.getenv("RAZORPAY_KEY_ID")
    RAZORPAY_KEY_SECRET = os.getenv("RAZORPAY_KEY_SECRET")
