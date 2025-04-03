import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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

  // Hàm lấy vị trí hiện tại và fetch thời tiết
  // Future<void> fetchWeatherByLocation() async {
  //   try {
  //     // Lấy vị trí hiện tại
  //     Position position = await _getCurrentLocation();

  //     // Gọi API để lấy thời tiết dựa trên vĩ độ và kinh độ
  //     final city = await _getCityFromCoordinates(position.latitude, position.longitude);
  //     await fetchWeather(city);
  //   } catch (e) {
  //     print("Error fetching location: $e");
  //   }
  // }

  // Hàm để lấy vị trí hiện tại
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra xem dịch vụ vị trí có được bật không
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    // Kiểm tra quyền truy cập vị trí
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        throw Exception('Location permission is denied');
      }
    }

    // Lấy vị trí hiện tại
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // Hàm lấy tên thành phố từ vĩ độ và kinh độ
  // Future<String> _getCityFromCoordinates(double latitude, double longitude) async {
  //   try {
  //     // Sử dụng geocoding để lấy địa chỉ từ tọa độ
  //     List<Placemark> placemarks = await GeocodingPlatform
  //     .instance.placemarkFromCoordinates(latitude, longitude);

  //     // Kiểm tra nếu có kết quả từ geocoding và lấy tên thành phố
  //     if (placemarks.isNotEmpty) {
  //       Placemark place = placemarks.first;
  //       return place.locality ?? 'Unknown City'; // Trả về tên thành phố hoặc 'Unknown City' nếu không có thông tin
  //     } else {
  //       return 'Unknown City'; // Trả về 'Unknown City' nếu không tìm thấy địa chỉ
  //     }
  //   } catch (e) {
  //     print('Error fetching city from coordinates: $e');
  //     return 'Unknown City'; // Trả về 'Unknown City' nếu có lỗi
  //   }
  // }
}
