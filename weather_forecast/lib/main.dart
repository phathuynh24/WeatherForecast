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

void main() async {
  // Load environment variables
  await dotenv.load();

  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase with FirebaseOptions
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBtL_vc2DsJSqDQ8w2x7c6uIXjletNPHcA",
      authDomain: "weather-forecast-20c68.firebaseapp.com",
      projectId: "weather-forecast-20c68",
      storageBucket: "weather-forecast-20c68.firebasestorage.app",
      messagingSenderId: "344306934590",
      appId: "1:344306934590:web:45a04f2a1dea3ae20ec26f",
      measurementId: "G-DJ310MVNB4",
    ),
  );

  // Handle web URL strategy
  setUrlStrategy(PathUrlStrategy());

  // Turn off debug banner
  WidgetsApp.debugAllowBannerOverride = false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),  // Đảm bảo AuthProvider được tạo ra tại đây
        ChangeNotifierProvider(create: (context) => WeatherProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
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
