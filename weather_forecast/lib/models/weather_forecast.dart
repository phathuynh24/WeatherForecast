class WeatherForecast {
  final String date;
  final double temperature;
  final double windSpeed;
  final int humidity;

  WeatherForecast({
    required this.date,
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
  });

  // Factory method để tạo object từ JSON
  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: json['date'],
      temperature: json['day']['avgtemp_c'],
      windSpeed: json['day']['maxwind_kph'],
      humidity: json['day']['avghumidity'],
    );
  }
}
