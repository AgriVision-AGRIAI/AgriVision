# Flutter Pages & Views (`App/agrivision/lib/pages`)

This directory houses all the user-facing view layouts and pages of the **AgriVision** mobile application. The pages are grouped into feature-based subdirectories to keep the codebase modular, clean, and easy to maintain.

---

## Directory Layout

As depicted in the system file structure, the pages are organized as follows:

```
pages/
├── authentication/           # User access management
│   ├── otp-verify.pages.dart # Dynamic OTP input and verification page
│   └── signin.pages.dart     # Farmer credentials login portal
├── disease_predict/          # AI leaf diagnosis scanning
│   ├── prediction.pages.dart # Results view presenting diagnostics and remedies
│   └── scan.pages.dart       # Photographic capture and gallery selector view
├── general/                  # Essential utilities and settings
│   ├── home.pages.dart       # Primary ecosystem dashboard
│   ├── profile.pages.dart    # Farmer profile, preferences, and details
│   └── splash.pages.dart     # Core app boots page handling locales initialization
├── recommendation/           # AI soil analytics
│   ├── crop.pages.dart       # Location and soil parameters collection interface
│   └── fertilizer.pages.dart # Fertilizer supplements and recommendation results
├── weather/                  # Meteorological telemetry
│   └── weather.pages.dart    # Detailed live climate conditions and multi-day forecasts
└── README.md                 # Pages module documentation
```

---

## 🔍 Detailed Component Profiles

### 1. Authentication (`authentication/`)
Manages registration security and credentials confirmation:
*   **`signin.pages.dart`**: Secure login interface. Captures credentials, communicates with backend sessions, and stores session tokens.
*   **`otp-verify.pages.dart`**: Handles Multi-Factor Authentication. Farmers enter the dynamic verification codes dispatched to their emails or mobile phones during registry handshakes.

### 2. Crop Pathology Scanner (`disease_predict/`)
Real-time image classification tool to diagnose unhealthy leaves:
*   **`scan.pages.dart`**: Integrates the native camera to capture photos or pick existing pictures from the device storage gallery.
*   **`prediction.pages.dart`**: Visualizes the AI findings returned from the Express server. Renders the identified disease label, estimated infection severity, and organic/chemical remedies.

### 3. Core Shell & Utilities (`general/`)
Core panels coordinating dashboard metrics and startup runs:
*   **`splash.pages.dart`**: Loading page that boots translation resources (`app-localization.utils.dart`) and dynamic styling models.
*   **`home.pages.dart`**: Central grid console providing prompt access cards to key features, current weather updates, and diagnostic history.
*   **`profile.pages.dart`**: Displays personal farm profiles, history graphs, settings, and regional language toggles.

### 4. Precision Recommendation (`recommendation/`)
Integrates the pre-trained Scikit-Learn Python classifiers:
*   **`crop.pages.dart`**: Collects soil properties (Nitrogen, Phosphorus, Potassium in mg/kg), pH, and location telemetry to recommend optimal crops.
*   **`fertilizer.pages.dart`**: Recommends customized chemical compounds or biological additions to treat soil deficiencies.

### 5. Weather Monitoring (`weather/`)
*   **`weather.pages.dart`**: Provides live meteorological data using the open-weather integrations. Visualizes temperature gauges, relative humidity charts, and wind indexes.
