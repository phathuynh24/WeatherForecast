class WeatherToday {
  final String cityName;
  final double temperature;
  final double windSpeed;
  final int humidity;
  final String weatherDescription;
  final String weatherIconUrl;

  WeatherToday({
    required this.cityName,
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.weatherDescription,
    required this.weatherIconUrl,
  });

  // Factory method to create a WeatherToday instance from JSON
  factory WeatherToday.fromJson(Map<String, dynamic> json) {
    return WeatherToday(
      cityName: json['location']['name'],
      temperature: json['current']['temp_c'],
      windSpeed: json['current']['wind_kph'] * 0.277778, // From wind_kph to m/s
      humidity: json['current']['humidity'],
      weatherDescription: json['current']['condition']['text'],
      weatherIconUrl: 'https:${json['current']['condition']['icon']}',
    );
  }
}
