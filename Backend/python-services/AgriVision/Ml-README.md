# AgriVision Machine Learning Engine (`Backend/python-services/AgriVision`)

The analytical intelligence engine of the AgriVision platform. This directory houses the pre-trained machine learning classifiers and deep learning models used to execute real-time crop recommendations and plant disease diagnostics.

---

## Directory Layout

As depicted in the system file structure, the machine learning workspace is organized as follows:

```
AgriVision/
├── data/                       # Dataset directory
│   └── Crop_recommendation.csv # Tabular dataset for crop recommendation training
├── models/                     # Serialized AI models ready for inference
│   ├── crop_model.pkl          # Scikit-learn Random Forest model (Crop Recommendation)
│   └── prediction_model.onnx   # Deep Learning model in ONNX format (Disease Classification)
├── source/                     # Core Python algorithms and helper modules
│   ├── __init__.py             # Module initialization
│   ├── disease_info.py         # Leaf pathology lookup tables and remedies
│   ├── ml_function.py          # Prediction algorithms & serialization routines
│   └── utils.py                # Coordinate utilities & OpenWeather connection scripts
├── .DS_Store                   # System metadata file
└── main.py                     # Execution entrypoint for predictions & integrations
```

---

## AI Model Pipelines

The workspace features a hybrid AI architecture combining traditional statistical models with neural network execution frameworks:

### 1. Crop Recommendation Classifier (`models/crop_model.pkl`)
*   **Model Type**: Scikit-Learn Random Forest Classifier.
*   **Attributes**: Evaluates seven soil and climatic features (Nitrogen, Phosphorus, Potassium, Ambient Temperature, Humidity, pH, and Rainfall).
*   **Telemetry Fetch**: Dynamic environmental characteristics are extracted automatically via GPS coordinates, or manually inputted by users during override runs.

### 2. Plant Disease Predictor (`models/prediction_model.onnx`)
*   **Model Type**: Deep Neural Network (e.g., MobileNet or ResNet) exported to the **ONNX (Open Neural Network Exchange)** format.
*   **Execution**: Uses ONNX Runtime for high-performance, cross-platform inference.
*   **Task**: Processes input plant leaf photographs to classify plant type and identify specific pathologies (e.g. *Tomato Early Blight*, *Potato Late Blight*).

---

## Execution & Inference Testing

To maintain separation of concerns and avoid server latency, the Node.js API server executes predictions by spawning a Python child process directed at `main.py`.

### Installation & Setup

1.  **System Requirements**: Ensure [Python 3.9+](https://www.python.org/) is installed on the hosting server.
2.  **Dependencies**: Python requirements are configured inside the parent backend directory (`Backend/requirements.txt`). Install them using pip:
    ```bash
    cd Backend
    pip install -r requirements.txt
    ```
    *Core dependencies include: `scikit-learn`, `onnxruntime`, `pandas`, `numpy`, `requests`.*

---

### Command Line Inference Test

You can run automated crop recommendation predictions directly from the console to verify execution performance:

```bash
# Navigate to the workspace
cd Backend/python-services/AgriVision

# Run local inference test using Latitude and Longitude arguments
python main.py 23.456 78.910
```

The script will query climate variables via `source/utils.py`, load the appropriate models from `models/`, and output a structured JSON stream:
```json
{
  "success": true,
  "data": {
    "recommended_crop": "rice",
    "confidence": 0.94,
    "soil_requirements": { "N": 80, "P": 40, "K": 40 }
  }
}
```
