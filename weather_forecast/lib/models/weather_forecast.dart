class WeatherForecast {
  final String date;
  final double temperature;
  final double windSpeed;
  final int humidity;
  final String weatherIconUrl;

  WeatherForecast({
    required this.date,
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.weatherIconUrl,
  });

  // Factory method to create a WeatherForecast instance from JSON
  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: json['date'],
      temperature: json['day']['avgtemp_c'],
      windSpeed: json['day']['maxwind_kph'] * 0.277778, // From wind_kph to m/s
      humidity: json['day']['avghumidity'],
      weatherIconUrl: 'https:${json['day']['condition']['icon']}',
    );
  }
}
