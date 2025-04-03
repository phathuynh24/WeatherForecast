import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/providers/weather_provider.dart';
import 'package:weather_forecast/utils/constants.dart';
import 'package:weather_forecast/utils/theme.dart';
import 'package:weather_forecast/widgets/forecast_widget.dart';
import 'package:weather_forecast/widgets/weather_today_widget.dart';

class HomeScreen extends StatelessWidget {
  final _cityController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        foregroundColor: AppColors.textSecondary,
        backgroundColor: AppColors.darkBlueHeader,
      ),
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // ô tìm kiếm và nút "Use Current Location"
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Enter a City Name',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            hintText: 'E.g., New York, London, Tokyo',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    AppBorderRadius.inputBorderRadius)),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            final city = _cityController.text;
                            context.read<WeatherProvider>().fetchWeather(city);
                            debugPrint('City: $city');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppBorderRadius.buttonBorderRadius)),
                            backgroundColor: AppColors.darkBlueHeader,
                          ),
                          child: const Text(
                            'Search',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              // primary: Colors.blue, // Set background color
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppBorderRadius.buttonBorderRadius)),
                              backgroundColor: AppColors.greyBlueSection),
                          child: const Text(
                            'Use Current Location',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  // Hiển thị thông tin thời tiết hiện tại từ Provider
                  Consumer<WeatherProvider>(
                    builder: (context, provider, child) {
                      if (provider.currentWeather != null) {
                        return WeatherTodayWidget(
                          cityName: provider.currentWeather!.cityName,
                          temperature:
                              provider.currentWeather!.temperature.toString(),
                          windSpeed:
                              provider.currentWeather!.windSpeed.toString(),
                          humidity:
                              provider.currentWeather!.humidity.toString(),
                          weatherDescription:
                              provider.currentWeather!.weatherDescription,
                        );
                      } else {
                        return const Center(child: Text('No data available'));
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  // Hiển thị dự báo 4 ngày tới từ Provider
                  Consumer<WeatherProvider>(
                    builder: (context, provider, child) {
                      if (provider.forecastWeather != null) {
                        return ForecastWidget(
                          forecastData: provider.forecastWeather!,
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
