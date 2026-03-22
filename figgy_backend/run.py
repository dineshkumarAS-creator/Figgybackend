from app import create_app
import os

# Create the application instance
app = create_app()

if __name__ == "__main__":
    # Get port from environment or default to 5000
    host = os.getenv("HOST", "0.0.0.0")
    port = int(os.getenv("PORT", 5000))
    debug = os.getenv("FLASK_DEBUG", "True").lower() == "true"

    # Start the Flask development server
    app.run(host=host, port=port, debug=debug)
