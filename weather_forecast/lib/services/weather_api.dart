import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:weather_forecast/models/weather_forecast.dart';
import 'package:weather_forecast/models/weather_today.dart';
import 'package:weather_forecast/utils/constants.dart';

class WeatherApi {
  static const String baseUrl = 'https://api.weatherapi.com/v1';
  static String apiKey = dotenv.env[EnvKeys.weatherApiKey]!;

  // Lấy thời tiết hiện tại
  static Future<WeatherToday> fetchCurrentWeather(String city) async {
    final response = await http.get(Uri.parse('$baseUrl/current.json?key=$apiKey&q=$city'));

    if (response.statusCode == 200) {
      return WeatherToday.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load current weather');
    }
  }

  static Future<List<WeatherForecast>> fetchForecastWeather(String city) async {
    final response = await http.get(Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$city&days=5'));

    if (response.statusCode == 200) {
      var forecastData = jsonDecode(response.body)['forecast']['forecastday'] as List;
      return forecastData.map((data) => WeatherForecast.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load forecast weather');
    }
  }
}
