import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/providers/auth_provider.dart';
import 'package:weather_forecast/providers/weather_provider.dart';
import 'package:weather_forecast/screens/home_screen.dart';
import 'package:weather_forecast/screens/login_screen.dart';
import 'package:weather_forecast/screens/signup_screen.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:weather_forecast/utils/constants.dart';

void main() async {
  // Load environment variables
  await dotenv.load();

  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase with FirebaseOptions
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env[EnvKeys.googleApiKey]!,
      authDomain: dotenv.env[EnvKeys.authDomain]!,
      projectId: dotenv.env[EnvKeys.projectId]!,
      storageBucket: dotenv.env[EnvKeys.storageBucket]!,
      messagingSenderId: dotenv.env[EnvKeys.messagingSenderId]!,
      appId: dotenv.env[EnvKeys.appId]!,
      measurementId: dotenv.env[EnvKeys.measurementId]!,
    ),
  );

  // Handle web URL strategy
  setUrlStrategy(PathUrlStrategy());

  // Turn off debug banner
  WidgetsApp.debugAllowBannerOverride = false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => WeatherProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Forecast',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',  // Đặt route mặc định
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
