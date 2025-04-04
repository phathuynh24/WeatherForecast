# 🌦️ Weather Forecast App

A cross-platform Flutter application that shows weather forecasts with subscription-based email notifications powered by **Firebase Cloud Functions** and **SendGrid**.

---

## 🧾 Features

- 🌤️ Realtime weather data and forecasts.
- 📧 Email confirmation system via Firebase Functions + SendGrid.
- 📦 Firebase integration (Auth, Firestore, Hosting, Functions).
- 🔐 Environment-based config via `.env`.

---

## 📁 Project Structure

```
WEATHER_FORECAST/
├── assets/                    # Static assets
├── build/                    # Auto-generated build files
├── functions/                # Firebase Cloud Functions (Node.js + SendGrid)
│   ├── index.js
│   ├── package.json
│   └── .eslintrc.js
├── lib/
│   ├── models/               # Weather models
│   ├── providers/            # State management (Provider)
│   ├── screens/              # All UI screens
│   ├── services/             # API and Firestore services
│   ├── utils/                # Utility functions/constants
│   └── widgets/              # Custom reusable widgets
├── public/                  # Firebase hosting for web
├── .env                     # 🔐 Environment file (copy from `.env.example`)
├── .gitignore
└── README.md
```

---

## 🚀 Getting Started

### 1. 🔧 Environment Setup

Create your own `.env` file:

```bash
cp .env.example .env
```

Then open `.env` and fill in the following keys:

```env
WEATHER_API_KEY=your_openweather_api_key
SENDGRID_API_KEY=your_sendgrid_api_key
SENDGRID_VERIFIED_SENDER=email@yourdomain.com
```

### 2. 📲 Flutter App Setup

Install dependencies and run the app:

```bash
flutter pub get
flutter run
```

### 3. 🔥 Firebase Setup

#### Install Firebase CLI:

```bash
npm install -g firebase-tools
```

#### Login and initialize:

```bash
firebase login
firebase use --add
```

#### Deploy Firebase Functions (email confirmation):

```bash
cd functions
npm install
firebase deploy --only functions
```

#### Deploy Firebase Hosting (for web):

```bash
flutter build web
firebase deploy --only hosting
```

---

## 📎 Demo

🔗 Hosted Demo: [https://weather-forecast-20c68.web.app](https://weather-forecast-20c68.web.app)

---

## 🛠️ Built With

- Flutter
- Firebase (Auth, Firestore, Functions, Hosting)
- SendGrid (Email API)
- OpenWeatherMap API

---

## 🧑‍💻 Author

**Huỳnh Phát** — [GitHub](https://github.com/phathuynh24)

---

## 📄 License

MIT License © 2025
