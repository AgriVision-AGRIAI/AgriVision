# AgriVision Webpage

An interactive showcase designed to present the AgriVision application to users and developer communities. Built with **HTML5**, **CSS3**, and **Vanilla JavaScript**.

---

## Interface (`Webpage/assets/`)
The landing page includes visual mockup showcases mapping out mobile client interfaces:
*   **`logo-transparent.png`**: High-resolution project branding asset.
*   **`homepage.png`**: Visual mockup of the primary farmer console dashboard.
*   **`disease.png`**: Presentation of the leaf scanner interface.
*   **`fertilizer.png`**: Visual representing the crop prediction form and output cards.
*   **`weather.png`**: Representation of the localization weather telemetry layout.

---

## Code Architecture

*   **`index.html`**: Semantic HTML5 document dividing sections into:
    *   **Hero Unit**: Immersive branding showcase using clean Typography and calls to action.
    *   **Features Grid**: Structured cards mapping out *Disease Prediction*, *Soil Recommendation*, and *Real-time Weather*.
    *   **Technical Showcase**: System architecture flows, detailing the Mobile -> Backend Node -> Python ML bridge.
    *   **Developer Guide**: Quick start commands for deployment.
*   **`style.css`**: Complete responsive layout system.
    *   Custom HSL organic color schemes (Leaf greens, soil browns, and sleek slate-darks).
    *   Flexbox and Grid configurations designed for all viewport screen ratios.
    *   Micro-animations and hover scales for interactive engagements.
*   **`script.js`**: Interactive scripts handling scroll triggers, responsive mobile menus, and mockup image carousels.

---

## Quick Launch

### Option A: Local File Loading
Open the `index.html` file inside any standard web browser:
```bash
# On Windows
start index.html

# On macOS
open index.html
```

### Option B: Local Server Deployment
Serve using a lightweight node or python command:

```bash
# Using Python
python -m http.server 8000

# Using Node.js (with live-server or local-web-server)
npx live-server
```
Once started, navigate your browser to `http://localhost:8000`.
