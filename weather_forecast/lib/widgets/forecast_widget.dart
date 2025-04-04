import 'package:flutter/material.dart';
import 'package:weather_forecast/models/weather_forecast.dart';
import 'package:weather_forecast/services/weather_api.dart';
import 'package:weather_forecast/utils/constants.dart';
import 'package:weather_forecast/utils/theme.dart';

class ForecastWidget extends StatefulWidget {
  final List<WeatherForecast> forecastData;

  const ForecastWidget({super.key, required this.forecastData});

  @override
  ForecastWidgetState createState() => ForecastWidgetState();
}

class ForecastWidgetState extends State<ForecastWidget> {
  late ScrollController _scrollController;
  bool _isLoading = false;
  int _totalDays = 4;
  final int _maxDays = 14;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (widget.forecastData.length != _totalDays) {
        _totalDays = 4;
      }
      if (!_isLoading && _totalDays < _maxDays) {
        _loadMoreData();
      }
    }
  }

  void _loadMoreData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final newDays = _totalDays + 5;
      if (newDays > _maxDays) {
        return;
      }
      final newForecastData =
          await WeatherApi.fetchForecastWeather('London', newDays);

      final newData = newForecastData
          .where((forecast) => !widget.forecastData.any(
              (existingForecast) => existingForecast.date == forecast.date))
          .toList();

      setState(() {
        widget.forecastData.addAll(newData);
        _totalDays = newDays;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching more data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 735,
      child: ListView.builder(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: widget.forecastData.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == widget.forecastData.length) {
            if (_isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              Future.delayed(const Duration(milliseconds: 1000), () {
                setState(() {
                  _isLoading = true;
                });
              });
            }
          }

          final forecast = widget.forecastData[index];
          return Padding(
            padding: EdgeInsets.only(
                right: index == widget.forecastData.length - 1 ? 4.0 : 18.0),
            child: Container(
              width: 170,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.greyBlue,
                borderRadius: BorderRadius.circular(
                    AppBorderRadius.forecastCardBorderRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('(${forecast.date})',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      )),
                  const SizedBox(height: 8),
                  Image.network(forecast.weatherIconUrl, width: 60, height: 60),
                  Text(
                    'Temp: ${forecast.temperature}°C',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Wind: ${forecast.windSpeed.toStringAsFixed(2)} M/S',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Humidity: ${forecast.humidity}%',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
