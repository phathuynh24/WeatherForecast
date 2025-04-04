import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/providers/auth_provider.dart';
import 'package:weather_forecast/providers/weather_provider.dart';
import 'package:weather_forecast/utils/constants.dart';
import 'package:weather_forecast/utils/snackbar_helper.dart';
import 'package:weather_forecast/utils/theme.dart';
import 'package:weather_forecast/widgets/forecast_widget.dart';
import 'package:weather_forecast/widgets/or_divider.dart';
import 'package:weather_forecast/widgets/search_history_widget.dart';
import 'package:weather_forecast/widgets/weather_today_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _cityController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Check if the user is authenticated and load default data
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<AuthProvider>().checkAuthentication(context);
      context.read<WeatherProvider>().loadDefaultData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: AppBar(
        title: const Text('Weather Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
        automaticallyImplyLeading: false,
        centerTitle: true,
        foregroundColor: AppColors.textSecondary,
        backgroundColor: AppColors.darkBlue,
        actions: [
          // Subscribe to Weather Forecast Emails
          IconButton(
            icon: const Icon(Icons.email, color: Colors.white, size: 30),
            onPressed: () async {
              final isSubscribed = await context
                  .read<AuthProvider>()
                  .isSubscribedToWeatherForecast();

              if (isSubscribed) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showCustomSnackbar(context, 'You are already subscribed.',
                      isSuccess: true);
                });
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title:
                            const Text('Subscribe to Weather Forecast Emails'),
                        content: const Text(
                          'Would you like to subscribe to daily weather forecast notifications via email?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Please Wait',
                                      textAlign: TextAlign.center,
                                    ),
                                    contentPadding: const EdgeInsets.all(20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    content: const SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  );
                                },
                              );

                              try {
                                await context
                                    .read<AuthProvider>()
                                    .sendEmailConfirmation(context);
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();

                                  showCustomSnackbar(
                                      context, 'Successfully subscribed!',
                                      isSuccess: true);
                                });
                              } catch (e) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();

                                  showCustomSnackbar(
                                      context, 'Failed to subscribe: $e',
                                      isSuccess: false);
                                });
                              }
                            },
                            child: const Text('Subscribe'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );
                });
              }
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("|"),
          ),
          // Logout
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton.icon(
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              label: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Log Out'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            await Provider.of<AuthProvider>(context,
                                    listen: false)
                                .logout();

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.pop(context);
                              context.go('/login');
                              showCustomSnackbar(
                                  context, 'Logged out successfully',
                                  isSuccess: true);
                            });
                          } catch (e) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              showCustomSnackbar(
                                  context, 'Error logging out: ${e.toString()}',
                                  isSuccess: false);
                            });
                          }
                        },
                        child: const Text('Yes'),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
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
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z\s]')),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    final city = _cityController.text.trim();
                                    if (city.isEmpty) {
                                      showCustomSnackbar(
                                          context, 'Please enter a city name.',
                                          isSuccess: false);
                                    } else {
                                      try {
                                        await context
                                            .read<WeatherProvider>()
                                            .fetchWeather(city);
                                        if (context.mounted) {
                                          showCustomSnackbar(
                                              context, 'Search successful!',
                                              isSuccess: true);
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          showCustomSnackbar(context,
                                              'Error fetching data: ${e.toString()}',
                                              isSuccess: false);
                                        }
                                      }
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 30),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            AppBorderRadius
                                                .buttonBorderRadius)),
                                    backgroundColor: AppColors.darkBlue,
                                  ),
                                  child: const Text(
                                    'Search',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                const OrDivider(),
                                ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    try {
                                      await context
                                          .read<WeatherProvider>()
                                          .fetchWeatherByUserLocation();
                                      if (context.mounted) {
                                        showCustomSnackbar(context,
                                            'Current location fetched successfully!',
                                            isSuccess: true);
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        showCustomSnackbar(context,
                                            'Error fetching current location: ${e.toString()}',
                                            isSuccess: false);
                                      }
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 30),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppBorderRadius
                                                  .buttonBorderRadius)),
                                      backgroundColor: AppColors.greyBlue),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer<WeatherProvider>(
                            builder: (context, provider, child) {
                              if (provider.currentWeather != null) {
                                return WeatherTodayWidget(
                                  weatherToday: provider.currentWeather!,
                                );
                              } else {
                                return const Center(
                                    child: Text('No data available'));
                              }
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 4-Day Forecast
                                const Text(
                                  '4 - Day Forecast',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Consumer<WeatherProvider>(
                                  builder: (context, provider, child) {
                                    if (provider.forecastWeather != null) {
                                      return ForecastWidget(
                                          forecastData:
                                              provider.forecastWeather!);
                                    } else {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Today\'s Search History',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const SearchHistoryWidget(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
