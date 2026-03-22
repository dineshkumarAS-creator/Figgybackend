# FIGGY Backend

Production-ready Flask backend using MongoDB and deterministic mock data.

## Project Structure
- **app/**: Core application code
  - **routes/**: API Blueprints
  - **utils/**: Helper utilities (including deterministic mock generator)
  - **models.py**: MongoDB connection helper
- **config.py**: Configuration handling
- **run.py**: Entry point for starting the server
- **requirements.txt**: Python dependencies

## Features
- **Deterministic Mocking**: Same Swiggy ID/Phone → Same Result.
- **Worker Registration**: Stores worker details and calculated premiums in MongoDB.
- **Clean API Design**: Modular Blueprints and type hints.

## How to Run

1. **Install Dependencies**
   ```bash
   pip install -r requirements.txt
   ```

2. **Configure MongoDB**
   Ensure MongoDB is running locally at `mongodb://localhost:27017` or set the `MONGO_URI` environment variable.

3. **Start the Server**
   ```bash
   python run.py
   ```

## API Endpoints

### 1. Fetch Worker Data (Deterministic Mock)
- **POST** `/api/worker/fetch`
- **Request Body**:
  ```json
  {
    "swiggy_id": "SWG12345"
  }
  ```
- **Response**: Returns mocked worker data based on the ID.

### 2. Register Worker
- **POST** `/api/worker/register`
- **Request Body**: (JSON from Fetch + swiggy_id)
- **Response**: Confirms registration and returns the newly generated `worker_id`.

### 3. Health Check
- **GET** `/health`
- **Response**: `{"status": "ok"}`
