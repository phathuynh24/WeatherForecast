import 'package:flutter/material.dart';
import 'package:weather_forecast/models/weather_today.dart';
import 'package:weather_forecast/utils/constants.dart';
import 'package:weather_forecast/utils/date_utils.dart';
import 'package:weather_forecast/utils/theme.dart';

class WeatherTodayWidget extends StatelessWidget {
  final WeatherToday weatherToday;

  const WeatherTodayWidget({super.key, required this.weatherToday});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: AppColors.darkBlue,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(AppBorderRadius.weatherCardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${weatherToday.cityName} (${MyDateUtils.formatDate(DateTime.now())})',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Temperature: ${weatherToday.temperature}°C',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Wind: ${weatherToday.windSpeed.toStringAsFixed(2)} M/S',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Humidity: ${weatherToday.humidity}%',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  weatherToday.weatherIconUrl,
                  scale: 0.7,
                ),
                Text(
                  weatherToday.weatherDescription,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
