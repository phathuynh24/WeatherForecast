import 'package:flutter/material.dart';
import 'package:weather_forecast/models/weather_forecast.dart';

class ForecastWidget extends StatelessWidget {
  final List<WeatherForecast> forecastData;

  const ForecastWidget({super.key, required this.forecastData});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
      ),
      itemCount: forecastData.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(forecastData[index].date),
                Text('Temp: ${forecastData[index].temperature}'),
                Text('Wind: ${forecastData[index].windSpeed}'),
                Text('Humidity: ${forecastData[index].humidity}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
