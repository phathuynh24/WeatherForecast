import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast/providers/weather_provider.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/utils/constants.dart';
import 'package:weather_forecast/utils/theme.dart';

class SearchHistoryWidget extends StatefulWidget {
  const SearchHistoryWidget({super.key});

  @override
  SearchHistoryWidgetState createState() => SearchHistoryWidgetState();
}

class SearchHistoryWidgetState extends State<SearchHistoryWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        return FutureBuilder(
          future: provider.getSearchHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final history = snapshot.data!;

              history.sort((a, b) {
                final aTime = DateTime.parse(a.values.first['searchTime']);
                final bTime = DateTime.parse(b.values.first['searchTime']);
                return bTime.compareTo(aTime);
              });

              return SizedBox(
                height: 230,
                width: 735,
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(), // Horizontal scroll
                  scrollDirection: Axis.horizontal,
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final city = history[index].keys.first; // City name
                    final weather =
                        history[index][city]; // Weather data for the city

                    // Display search history info in a card
                    return Padding(
                      padding: EdgeInsets.only(
                          right: index == history.length - 1 ? 8.0 : 16.0),
                      child: Container(
                        width: 170, // Set width for each item
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColors.darkBlue,
                          borderRadius: BorderRadius.circular(
                              AppBorderRadius.forecastCardBorderRadius),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$city City',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Image.network(weather['weatherIconUrl'],
                                width: 70, height: 70),
                            Text(
                              'Temp: ${weather['temperature']}°C',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Humidity: ${weather['humidity']}%',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Wind: ${weather['windSpeed'].toStringAsFixed(2)} M/S',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Search at ${DateFormat('HH:mm:ss').format(DateTime.parse(weather['searchTime']).toLocal())}s',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Text('No history found');
            }
          },
        );
      },
    );
  }
}
