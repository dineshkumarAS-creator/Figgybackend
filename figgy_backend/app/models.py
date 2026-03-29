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

class PolicyTermsStore:
    """Handles Terms & Conditions data with multiregional support."""
    def __init__(self):
        self._terms = [
            {
                "id": 1,
                "version": "1.0",
                "effective_from": "2026-03-01",
                "language": "English",
                "sections": [
                    {"title": "1. Introduction", "content": "GigShield is a parametric micro-insurance product designed exclusively for food delivery partners (Zomato, Swiggy, etc.). It provides weekly protection against loss of income caused by external disruptions like heavy rain, extreme heat, or severe pollution."},
                    {"title": "2. Coverage", "content": "We cover only loss of income due to defined parametric triggers in your registered delivery zone. Payout is fixed and automatic — no need to file a claim or prove your loss."},
                    {"title": "3. What is NOT Covered (Exclusions)", "content": "Any health-related issues, medical expenses, accidents or vehicle damage, or loss due to personal reasons are not covered."},
                    {"title": "4. Policy Period & Premium", "content": "Your policy is valid for 7 days (weekly cycle). Premium is charged weekly and auto-renews unless you cancel."},
                    {"title": "5. Claim Process", "content": "Claims are fully automatic (zero-touch). When a trigger is detected, payout is processed automatically within 24–48 hours."},
                    {"title": "6. Your Responsibilities", "content": "Keep your location and contact details updated. GPS spoofing will lead to policy cancellation."},
                    {"title": "7. Fraud Prevention", "content": "We use AI + location validation to prevent fraudulent claims. Detected fraud will result in immediate cancellation."},
                    {"title": "8. Cancellation & Refund", "content": "You can cancel anytime before renewal. No refund for the current active week once payment is made."},
                    {"title": "9. Dispute Resolution", "content": "Any disputes will be subject to the laws of India and resolved through arbitration in Chennai."},
                    {"title": "10. Important Note", "content": "This is a parametric product — payout depends only on objective weather/pollution data, not on your actual earnings loss."}
                ],
                "is_active": True
            },
            {
                "id": 2,
                "version": "1.0",
                "effective_from": "2026-03-01",
                "language": "Hindi",
                "sections": [
                    {"title": "1. परिचय", "content": "GigShield एक पैरामीट्रिक माइक्रो-इंश्योरेंस उत्पाद है जो विशेष रूप से फूड डिलीवरी पार्टनर्स के लिए बनाया गया है।"},
                    {"title": "2. कवरेज", "content": "हम केवल आपके पंजीकृत डिलीवरी क्षेत्र में परिभाषित पैरामीट्रिक ट्रिगर्स के कारण आय की हानि को कवर करते हैं।"},
                    {"title": "3. क्या कवर नहीं है (अपवाद)", "content": "स्वास्थ्य संबंधी समस्याएं, चिकित्सा व्यय, दुर्घटनाएं या वाहन की मरम्मत कवर नहीं है।"},
                    {"title": "4. पॉलिसी अवधि और प्रीमियम", "content": "आपकी पॉलिसी 7 दिनों (साप्ताहिक चक्र) के लिए वैध है। प्रीमियम साप्ताहिक रूप से लिया जाता है।"},
                    {"title": "5. दावा प्रक्रिया", "content": "दावे पूरी तरह से स्वचालित (जीरो-टच) हैं।"},
                    {"title": "6. आपकी जिम्मेदारियां", "content": "अपनी लोकेशन और संपर्क विवरण अपडेट रखें।"},
                    {"title": "7. धोखाधड़ी रोकथाम", "content": "धोखाधड़ी के परिणामस्वरूप पॉलिसी तुरंत रद्द कर दी जाएगी।"},
                    {"title": "8. रद्दीकरण और धनवापसी", "content": "आप नवीनीकरण से पहले किसी भी समय रद्द कर सकते हैं।"},
                    {"title": "9. विवाद समाधान", "content": "कोई भी विवाद भारत के कानूनों के अधीन होगा।"},
                    {"title": "10. महत्वपूर्ण नोट", "content": "यह एक पैरामीट्रिक उत्पाद है - भुगतान केवल वस्तुनिष्ठ मौसम/प्रदूषण डेटा पर निर्भर करता है।"}
                ],
                "is_active": True
            }
        ]

    def get_terms(self, language="English", version="1.0"):
        """Fetch active terms for a given language and version."""
        for t in self._terms:
            if t["language"] == language and t["version"] == version and t["is_active"]:
                return t
        # Fallback to English 1.0
        return self._terms[0]

    def get_current_version(self):
        return "1.0"

# Terms Storage Singleton
terms_store = PolicyTermsStore()
