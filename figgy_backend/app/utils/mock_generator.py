import random
import hashlib
from typing import Dict, Any

# Mock list of Indian cities for deterministic choices
INDIAN_CITIES = [
    "Mumbai", "Delhi", "Bangalore", "Hyderabad", "Ahmedabad", 
    "Chennai", "Kolkata", "Pune", "Jaipur", "Lucknow"
]

# Mock list of zones for deterministic choices
ZONES = ["North", "South", "East", "West", "Central"]

# Official Swiggy Partner Database (Allowed IDs)
# Now Includes your specific demo IDs
VALID_SWIGGY_IDS = ["SWG101", "SWG102", "dinesh_", "7550080899", "SWG777", "SWG999"]

def generate_worker_data(identifier: str) -> Dict[str, Any]:
    """
    Generates deterministic mock data based on the provided identifier.
    Returns None if the ID is not in our official records.
    """
    # Use identifier in our check
    if identifier not in VALID_SWIGGY_IDS:
        return None
    
    # MD5 Seed for cross-session consistency
    seed_hash = int(hashlib.md5(identifier.encode()).hexdigest(), 16)
    random.seed(seed_hash)

    last_three = identifier[-3:] if len(identifier) >= 3 else identifier
    
    # Profile Generation
    name = f"Rider_{last_three}"
    # Special naming for your demo account
    if identifier == "dinesh_":
        name = "dinesh "

    phone = f"9XXXXXX{last_three}"
    if identifier == "7550080899" or identifier == "dinesh_":
        phone = "7550080899"

    city = random.choice(INDIAN_CITIES)
    zone = random.choice(ZONES)
    
    daily_hours = random.randint(4, 10)
    weekly_deliveries = random.randint(80, 200)
    total_deliveries = random.randint(1200, 8000)
    avg_daily_earnings = random.randint(500, 1200)
    
    return {
        "name": name,
        "phone": phone,
        "platform": "Swiggy",
        "city": city,
        "zone": zone,
        "daily_hours": daily_hours,
        "weekly_deliveries": weekly_deliveries,
        "total_deliveries": total_deliveries,
        "avg_daily_earnings": avg_daily_earnings,
        "weekly_earnings": avg_daily_earnings * 7,
        "monthly_earnings": avg_daily_earnings * 30
    }
