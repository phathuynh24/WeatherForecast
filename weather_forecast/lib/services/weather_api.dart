import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_forecast/models/weather_forecast.dart';
import 'package:weather_forecast/models/weather_today.dart';
import 'package:weather_forecast/utils/api_keys.dart';

class WeatherApi {
  static const String baseUrl = 'https://api.weatherapi.com/v1';
  static String apiKey = '6908368d55094f2f87e45133250204'; // Lấy API key từ WeatherAPI

  // Lấy thời tiết hiện tại
  static Future<WeatherToday> fetchCurrentWeather(String city) async {
    print ('Fetching current weather for $city...');
    // apiKey
    print('API Key: $apiKey');
    final response = await http.get(Uri.parse('$baseUrl/current.json?key=$apiKey&q=$city'));

    if (response.statusCode == 200) {
      return WeatherToday.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load current weather');
    }
  }

  // Lấy dự báo thời tiết
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
