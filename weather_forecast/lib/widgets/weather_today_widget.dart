import 'package:flutter/material.dart';

class WeatherTodayWidget extends StatelessWidget {
  final String cityName;
  final String temperature;
  final String windSpeed;
  final String humidity;
  final String weatherDescription;

  const WeatherTodayWidget({super.key, 
    required this.cityName,
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.weatherDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '$cityName (Today)',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Temperature: $temperature°C'),
            Text('Wind Speed: $windSpeed km/h'),
            Text('Humidity: $humidity%'),
            Text('Weather: $weatherDescription'),
          ],
        ),
      ),
    );
  }
}
