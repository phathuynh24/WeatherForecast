class WeatherToday {
  final String cityName;
  final double temperature;
  final double windSpeed;
  final int humidity;
  final String weatherDescription;

  WeatherToday({
    required this.cityName,
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.weatherDescription,
  });

  // Factory method để tạo object từ JSON
  factory WeatherToday.fromJson(Map<String, dynamic> json) {
    return WeatherToday(
      cityName: json['location']['name'],
      temperature: json['current']['temp_c'],
      windSpeed: json['current']['wind_kph'],
      humidity: json['current']['humidity'],
      weatherDescription: json['current']['condition']['text'],
    );
  }
}
