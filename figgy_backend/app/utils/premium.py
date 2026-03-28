def calculate_premium(worker_data):
    """
    Advanced AI-like premium calculation
    """

    base_premium = 100

    deliveries = worker_data.get("total_deliveries", 0)
    rating = worker_data.get("rating", 4.5)
    earnings = worker_data.get("avg_daily_earnings", 500)

    # 🔥 Smart Factors
    delivery_factor = min(deliveries / 1000, 1) * 20
    rating_factor = max(0, (5 - rating) * 15)
    earnings_factor = max(0, (500 - earnings) / 10)

    premium = base_premium + delivery_factor + rating_factor + earnings_factor

    # 🔥 Risk Level
    if premium > 140:
        risk_level = "HIGH"
    elif premium > 120:
        risk_level = "MEDIUM"
    else:
        risk_level = "LOW"

    # 🔥 AI Risk Score (0–100)
    risk_score = (
        (5 - rating) * 20 +
        min(deliveries / 100, 20) +
        max(0, (500 - earnings) / 5)
    )
    risk_score = min(100, round(risk_score, 2))

    # 🔥 Fraud Detection
    fraud_flag = False
    if deliveries > 2000 and rating > 4.9:
        fraud_flag = True
    if earnings > 2000:
        fraud_flag = True

    # 🔥 Explainability (XAI)
    explanation = []

    if rating < 4.2:
        explanation.append("Low rating increases risk")

    if deliveries > 800:
        explanation.append("High workload increases fatigue risk")

    if earnings < 450:
        explanation.append("Low income indicates financial instability")

    return {
        "base": base_premium,
        "delivery_factor": round(delivery_factor, 2),
        "rating_factor": round(rating_factor, 2),
        "earnings_factor": round(earnings_factor, 2),
        "total_premium": round(premium, 2),
        "risk_level": risk_level,
        "risk_score": risk_score,
        "fraud_flag": fraud_flag,
        "explanation": explanation
    }