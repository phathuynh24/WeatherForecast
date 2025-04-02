import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_forecast/utils/constants.dart';

class ApiKeys {
  static String get weatherApiKey {
    // Load the environment variables from the .env file
    final apiKey = dotenv.env[EnvKeys.weatheraApiKey];

    // Check if the API key is null or empty
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
        apiKey == null
            ? ErrorMessages.weatherApiKeyNotFound
            : ErrorMessages.weatherApiKeyEmpty,
      );
    }

    return apiKey;
  }
}
