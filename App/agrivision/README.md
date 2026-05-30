# AgriVision Mobile Client (`App/agrivision`)

<p align="center">
  <img src="assets/images/logo-transparent.png" width="150" alt="AgriVision App Logo"/>
</p>

A cross-platform mobile client designed for real-time field utilization by farmers and agricultural researchers. Built on **Flutter**, the application features location-aware weather telemetry, camera-based leaf disease detection, and customized soil recommendations.

---

## Technology Stack

*   **Framework**: [Flutter SDK](https://flutter.dev/) (Dart)
*   **State Management**: Provider (MultiProvider architecture)
*   **Design System**: Custom Material & Cupertino adaptive layouts
*   **Localization**: Custom Multi-lingual asset localization engine
*   **API Client**: HTTP networking with backend services

---

## Directory Layout

```
lib/
├── main.dart            # Entrypoint, initializing Providers and locales
├── pages/               # Feature-based view screens
│   ├── authentication/  # Sign-in and OTP verification pages
│   │   ├── otp-verify.pages.dart
│   │   └── signin.pages.dart
│   ├── disease_predict/ # Leaf diagnostics and scanning pages
│   │   ├── prediction.pages.dart
│   │   └── scan.pages.dart
│   ├── general/         # Splash, home dashboard, and profile pages
│   │   ├── home.pages.dart
│   │   ├── profile.pages.dart
│   │   └── splash.pages.dart
│   ├── recommendation/  # Crop recommendation and fertilizer pages
│   │   ├── crop.pages.dart
│   │   └── fertilizer.pages.dart
│   └── weather/         # Weather dashboards
│       └── weather.pages.dart
├── services/            # API client layers and HTTP endpoints
├── themes/              # Custom design themes and dynamic ThemeProviders
│   ├── light.theme.dart # Light-mode typography & palettes
│   ├── dark.theme.dart  # Dark-mode color mappings
│   └── provider.theme.dart # Dynamic runtime switching provider
├── utils/               # App localization & asset mapping utilities
└── widgets/             # Reusable custom UI components (Buttons, Inputs)
```

---

## Features & UX Highlights

### 1. Multi-Lingual Capability
To eliminate communication barriers in farming sectors, the application utilizes a tailored localization mechanism. Supported languages (like English, Hindi, and regional dialects) are stored as JSON files under `assets/languages/` and dynamically compiled at runtime via `AppLocalizations`.

### Dynamic Aesthetic Themes
A custom `ThemeProvider` monitors environment states and adjusts color tones across light and dark displays. 
*   **Light Theme**: Fresh green palettes expressing organic growth.
*   **Dark Theme**: Deep ocean green layouts for low-light night conditions in rural landscapes.

### Crop Pathology Scanner
Leveraging device cameras, users capture leaf abnormalities. The application transmits binary payloads to the node server which processes diagnostics through computer vision, returning:
*   Identified disease label
*   Severity indicators
*   Immediate farming countermeasures & biological treatments

---

## Mobile Compilation & Setup

### Prerequisites
*   Ensure Flutter is installed (`flutter doctor` should report no errors).
*   Connect an Android emulator, iOS simulator, or a debug-configured mobile device.

### Installation Steps

1.  Navigate to the directory:
    ```bash
    cd App/agrivision
    ```

2.  Fetch package dependencies listed in `pubspec.yaml`:
    ```bash
    flutter pub get
    ```

3.  Configure API base URL:
    *   Open `lib/services/api.service.dart` (or your endpoint helper) and update the base host address to target your running Backend API server.

4.  Compile and execute the app:
    ```bash
    # Run on active device
    flutter run
    
    # Release build for Android
    flutter build apk --release
    ```
