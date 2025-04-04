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
│   ├── .env.example           # Example environment config
│   └── .env                   # 🔐 Actual environment file (user-created)
├── build/                     # Auto-generated build files
├── functions/                 # Firebase Cloud Functions (Node.js + SendGrid)
│   ├── index.js
│   ├── package.json
│   ├── package-lock.json
│   └── .eslintrc.js
├── lib/
│   ├── models/                # Weather data models
│   ├── providers/             # State management logic
│   ├── screens/               # UI screens (Home, Signup, Login, etc.)
│   ├── services/              # APIs and Firestore-related logic
│   ├── utils/                 # Utility helpers (constants, theme, etc.)
│   └── widgets/               # Custom reusable Flutter widgets
├── public/                    # Static web files for Firebase Hosting
├── test/                      # Flutter test files
├── .gitignore
└── README.md
```

---

## 🚀 Getting Started

### 1. 🔧 Environment Setup

Create your own `.env` file:

```bash
cp assets/.env.example assets/.env
```

Then open `.env` and fill in the following keys:

```env
WEATHER_API_KEY=your-weather-api-key-here
GOOGLE_API_KEY=your-google-api-key-here
AUTH_DOMAIN=your-auth-domain-here
PROJECT_ID=your-project-id-here
...
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
