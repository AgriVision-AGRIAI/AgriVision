# Flutter Pages & Navigation

This directory houses the screens and forms of the AgriVision mobile application. The pages are partitioned into feature-based sub-modules to enforce clean separation of concerns.

---

## Sub-Module Structure

```
pages/
├── authentication/      # Sign-up, sign-in, and password reset views
│   ├── login.dart       # User session credentials validator forms
│   └── register.dart    # Profile creation and authentication routes
├── disease_predict/     # Plant pathology visual diagnostic views
│   └── scanner.dart     # Handles camera inputs, image selection, and server upload
├── general/             # Core dashboards and navigation views
│   ├── splash.dart      # Loading screen that handles startup initialization and localization
│   └── home.dart        # Farmer dashboard featuring feature-access cards
├── recommendation/      # Soil and environment analytical forms
│   └── form.dart        # Soil property entry (N-P-K, pH, location coordinates)
├── weather/             # Atmospheric updates and forecasts
│   └── weather_page.dart# Displays temperature indices, rain percentages, and weekly projections
└── tab-shell.pages.dart # Primary layout housing the bottom navigation bar controllers
```

---

## Core Shell Architecture (`tab-shell.pages.dart`)

The primary structural container of the application after authentication. It builds an adaptive navigation interface (using standard material design `BottomNavigationBar` or Cupertino shells):
*   **Persistent Navigation**: Retains individual tab layouts and state profiles.
*   **Interactive Switcher**: Navigates dynamically between **Home**, **Disease Scan**, **Crop Recommendation**, and **Weather Update** pages.

---

## View Component Highlights

### 1. Leaf Disease Scanner (`disease_predict/`)
*   Integrates with the `image_picker` dependency to grab pictures via camera devices or internal galleries.
*   Shows a crop preview and diagnostic load indicators.
*   Parses backend pathology responses, presenting a structured result layout detailing the disease profile and treatment guidance.

### 2. Analytical Soil Form (`recommendation/`)
*   Implements secure input validation for Chemical ratios (Nitrogen, Phosphorus, Potassium in mg/kg), soil pH levels, and location values.
*   Submits data payloads to the REST server, updating recommendation visual widgets based on Scikit-Learn estimations.
