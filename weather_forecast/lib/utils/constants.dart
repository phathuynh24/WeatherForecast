class EnvKeys {
  // Weather API keys
  static const String weatherApiKey = 'WEATHER_API_KEY';

  // Firebase keys
  static const String googleApiKey = 'GOOGLE_API_KEY';
  static const String authDomain = 'AUTH_DOMAIN';
  static const String projectId = 'PROJECT_ID';
  static const String storageBucket = 'STORAGE_BUCKET';
  static const String messagingSenderId = 'MESSAGING_SENDER_ID';
  static const String appId = 'APP_ID';
  static const String measurementId = 'MEASUREMENT_ID';
}

class ErrorMessages {
  static const String weatherApiKeyNotFound =
      'WEATHER_API_KEY not found in .env file';
  static const String weatherApiKeyEmpty =
      'WEATHER_API_KEY is empty in .env file';
  static const String failedToLoadData = 'Failed to load data';
}

class AppBorderRadius {
  static const double inputBorderRadius = 4.0;
  static const double buttonBorderRadius = 4.0;
  static const double weatherCardBorderRadius = 4.0;
  static const double forecastCardBorderRadius = 4.0;
}
