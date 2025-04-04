import 'package:flutter/material.dart';
import 'package:weather_forecast/models/weather_forecast.dart';
import 'package:weather_forecast/models/weather_today.dart';
import 'package:weather_forecast/services/firestore_service.dart';
import 'package:weather_forecast/services/weather_api.dart';
import 'package:geolocator/geolocator.dart';

class WeatherProvider with ChangeNotifier {
  WeatherToday? _currentWeather;
  List<WeatherForecast>? _forecastWeather;

  WeatherToday? get currentWeather => _currentWeather;
  List<WeatherForecast>? get forecastWeather => _forecastWeather;

  final FirestoreService _firestoreService = FirestoreService();

  Future<List<Map<String, dynamic>>> getSearchHistory() async {
    return await _firestoreService.getSearchHistory();
  }

  Future<void> fetchWeather(String city, {bool isInit = false}) async {
    _currentWeather = await WeatherApi.fetchCurrentWeather(city);

    _forecastWeather = await WeatherApi.fetchForecastWeather(city, 4);

    if (_currentWeather == null) {
      throw Exception('Failed to load current weather');
    }
    if (_forecastWeather == null) {
      throw Exception('Failed to load forecast weather');
    }
    if (!isInit) {
      final weatherData = {
        'temperature': _currentWeather!.temperature,
        'windSpeed': _currentWeather!.windSpeed,
        'humidity': _currentWeather!.humidity,
        'weatherDescription': _currentWeather!.weatherDescription,
        'weatherIconUrl': _currentWeather!.weatherIconUrl,
      };

      await _firestoreService.saveSearchHistory(
          _currentWeather!.cityName, weatherData);
    }

    notifyListeners();
  }

  Future<Position> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        throw Exception('Location permission is denied');
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> fetchWeatherByUserLocation() async {
    Position position = await _getUserLocation();
    double latitude = position.latitude;
    double longitude = position.longitude;

    _currentWeather =
        await WeatherApi.fetchCurrentWeatherByCoordinates(latitude, longitude);
    _forecastWeather = await WeatherApi.fetchForecastWeatherByCoordinates(
        latitude, longitude, 4);

    if (_currentWeather == null) {
      throw Exception('Failed to load current weather');
    }
    if (_forecastWeather == null) {
      throw Exception('Failed to load forecast weather');
    }

    final weatherData = {
      'temperature': _currentWeather!.temperature,
      'windSpeed': _currentWeather!.windSpeed,
      'humidity': _currentWeather!.humidity,
      'weatherDescription': _currentWeather!.weatherDescription,
      'weatherIconUrl': _currentWeather!.weatherIconUrl,
    };

    await _firestoreService.saveSearchHistory(
        _currentWeather!.cityName, weatherData);

    notifyListeners();
  }

  Future<void> loadDefaultData() async {
    await fetchWeather('London', isInit: true);
  }
}
