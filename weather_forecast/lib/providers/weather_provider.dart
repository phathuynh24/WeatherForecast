import 'package:flutter/material.dart';
import 'package:weather_forecast/models/weather_forecast.dart';
import 'package:weather_forecast/models/weather_today.dart';
import 'package:weather_forecast/services/weather_api.dart';

class WeatherProvider with ChangeNotifier {
  WeatherToday? _currentWeather;
  List<WeatherForecast>? _forecastWeather;

  WeatherToday? get currentWeather => _currentWeather;
  List<WeatherForecast>? get forecastWeather => _forecastWeather;

  // Hàm gọi API để fetch weather data
  Future<void> fetchWeather(String city) async {
    try {
      // Lấy dữ liệu thời tiết hiện tại
      _currentWeather = await WeatherApi.fetchCurrentWeather(city);

      // Lấy dữ liệu dự báo thời tiết
      _forecastWeather = await WeatherApi.fetchForecastWeather(city);
      debugPrint('Current Weather: ${_currentWeather?.cityName}');
      debugPrint('Forecast Weather: ${_forecastWeather?.length}');

      // Gọi notifyListeners để cập nhật UI
      notifyListeners(); // Cập nhật UI khi có thay đổi dữ liệu
    } catch (e) {
      print("Error fetching weather: $e");
    }
  }
}
