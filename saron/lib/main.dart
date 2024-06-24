import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saron/Screens/splash_screen/splash_screen.dart';

const TOKEN = 'User Token';
const USERNAME = 'User Name';
const EMAIL = 'Email';
const DEVICES = 'DeviceList';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            color: Colors.black,
            foregroundColor: Colors.white,
          ),
          textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
              bodyLarge: TextStyle(color: Colors.white)),
          splashFactory: NoSplash.splashFactory),
      home: const SplashScreen(),
    );
  }
}
