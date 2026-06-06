# AgriVision Backend API Server (`Backend/`)

A high-performance REST API Gateway designed to coordinate data models, manage user profiles, compile weather conditions, and execute Machine Learning diagnostics. Built with **Node.js**, **Express**, and **TypeScript**.

---

## Technology Stack

*   **Runtime Environment**: Node.js v18+
*   **Web Framework**: Express.js with TypeScript (`@types/express`)
*   **Database Integration**: MongoDB (via Mongoose ODM)
*   **Security & Encryption**: JWT (JSON Web Tokens) & bcryptjs hashing
*   **Compilation & Watch**: `tsc` compiler & `nodemon` hot reloading
*   **Testing Suite**: Jest & Supertest integration

---

## Architecture Structure

```
Backend/
├── config/              # Configuration (MongoDB connections, credentials)
├── interfaces/          # TypeScript structural interfaces (model types)
├── middlewares/         # Express middlewares (JWT auth validation, cors)
├── models/              # MongoDB/Mongoose database schemas (User, Prediction)
├── python-services/     # Machine Learning services written in Python
├── routes/              # Express API endpoint routers
│   ├── auth.routes.ts   # Registrations & session token handshakes
│   ├── environment.routes.ts   # Weather data fetches
│   ├── prediction,routes.ts    # Leaf disease catalog and diagnostics
│   └── recommend.routes.ts     # Crop suggestion endpoint
├── services/            # Component business logic layers
├── utils/               # Child process spawning tools for Python integrations
├── server.ts            # Bootstraps HTTP listeners
└── app.ts               # Express configuration, middlewares, & router maps
```

---

## API Endpoints & Payload Contracts

### 1. Authentication (`/auth`)
All authenticated endpoints require a `Authorization: Bearer <token>` HTTP header.

*   `POST /auth/register`
    *   *Payload*: `{ "name": "...", "email": "...", "password": "..." }`
    *   *Result*: `{ "success": true, "token": "JWT..." }`
*   `POST /auth/login`
    *   *Payload*: `{ "email": "...", "password": "..." }`
    *   *Result*: `{ "success": true, "token": "JWT..." }`

### 2. Crop Recommendations (`/recommend`)
*   `POST /recommend/crop`
    *   *Headers*: `Authorization: Bearer <token>`
    *   *Payload*: `{ "lat": 23.456, "lon": 78.910 }`
    *   *Result*: Returns suggested agricultural options based on geographical soil properties and climate records.

### 3. Plant Disease Diagnostics (`/prediction`)
*   `POST /prediction/disease-info`
    *   *Headers*: `Authorization: Bearer <token>`
    *   *Payload*: `{ "disease": "Tomato_Early_blight" }`
    *   *Result*: Returns catalog data, remediation measures, chemical remedies, and prevention guides.

---

## Python Integration Bridge
To deliver machine learning suggestions, the backend triggers standard Python sub-environments. The system implements a robust OS child process execution loop (`utils/python.child.utils.ts`):

```typescript
import { spawn } from "child_process";

// Example of background stream communication targeting main.py
const pythonProcess = spawn('python', ['python-services/AgriVision/main.py', latitude, longitude]);
```

Data flows via `stdin` / `stdout` as JSON string streams. This ensures optimal speed and resource consumption while separating the API gateway from machine learning operations.

---

## Setup & Execution

### Prerequisites
*   Installed [MongoDB](https://www.mongodb.com/) instance.
*   Installed [Node.js](https://nodejs.org/) (v18 or higher) and `npm`.

### Installation Steps

1.  Navigate to the folder:
    ```bash
    cd Backend
    ```

2.  Install dependencies:
    ```bash
    npm install
    ```

3.  Configure environment keys. Create a `.env` file:
    ```env
    PORT=5000
    MONGO_URI=mongodb://localhost:27017/agrivision
    JWT_SECRET=your_secret_passphrase
    WEATHER_API_KEY=your_openweathermap_api_key
    ```

4.  Execute development mode:
    ```bash
    # Runs the server with Nodemon compilation
    npm run dev
    
    # Executes Jest tests
    npm run test
    ```
