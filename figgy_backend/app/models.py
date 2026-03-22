import os
import logging
from flask import current_app
from pymongo import MongoClient
from pymongo.errors import ServerSelectionTimeoutError, ConfigurationError

# Logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("FIGGY_APP")

# Memory Storage for Hackathon Mode (Python List)
memory_workers = []

class Database:
    """Robust MongoDB handler with Memory Mode fallback."""
    def __init__(self):
        self._client = None
        self._db = None
        # Default fallback to Local for stability
        self.local_uri = os.getenv("MONGO_URI_LOCAL", "mongodb://localhost:27017/figgy")
        self.atlas_uri = os.getenv("MONGO_URI_ATLAS")
        self.db_name = os.getenv("DB_NAME", "figgy")

    @property
    def is_db_enabled(self):
        # We manually toggle this based on the USE_DB config
        # Safe access using current_app.config
        return current_app.config.get('USE_DB', False)

    def connect(self):
        """Attempts to connect to Atlas then Local MongoDB."""
        if not self.is_db_enabled:
            logger.info("⚠️  DEMO MODE: MongoDB is disabled. Using In-Memory Storage.")
            return False

        # 1. Try Atlas
        if self.atlas_uri:
            try:
                temp_client = MongoClient(self.atlas_uri, serverSelectionTimeoutMS=5000)
                temp_client.server_info()
                self._client = temp_client
                logger.info("✅ Connected to MongoDB Atlas.")
                return True
            except (ServerSelectionTimeoutError, ConfigurationError) as e:
                logger.warning(f"❌ Atlas failed: {e}")

        # 2. Try Local
        try:
            temp_client = MongoClient(self.local_uri, serverSelectionTimeoutMS=2000)
            temp_client.server_info()
            self._client = temp_client
            logger.info("✅ Connected to Local MongoDB.")
            return True
        except Exception as e:
            logger.error(f"❌ Local MongoDB failed: {e}")
            return False

    def insert_worker(self, worker_doc: dict):
        """Generic insert that routes to DB or Memory."""
        if self.is_db_enabled and (self._client or self.connect()):
            try:
                res = self.client[self.db_name].workers.insert_one(worker_doc)
                worker_doc.pop("_id", None)
                return True
            except Exception as e:
                logger.error(f"DB Insert Error: {e}. Falling back to Memory.")
        
        # Memory Fallback
        logger.info(f"Storing Worker '{worker_doc.get('worker_id')}' in Memory...")
        memory_workers.append(worker_doc)
        return True

    def get_all_workers(self):
        """Generic fetch all."""
        if self.is_db_enabled and (self._client or self.connect()):
            try:
                # Return list for simplicity
                return list(self.client[self.db_name].workers.find({}, {"_id": 0}))
            except Exception as e:
                logger.error(f"DB Fetch Error: {e}")
        
        return memory_workers

    @property
    def client(self):
        if self._client is None and self.is_db_enabled:
            self.connect()
        return self._client

# Singleton
db_handler = Database()
