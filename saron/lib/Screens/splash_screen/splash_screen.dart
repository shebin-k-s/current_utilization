import 'package:flutter/material.dart';
import 'package:saron/Screens/auth_screen/auth_screen.dart';
import 'package:saron/Screens/main_sceen/main_screen.dart';
import 'package:saron/api/data/device.dart';
import 'package:saron/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    UserLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/saron.png"),
      ),
    );
  }

  void UserLoggedIn() async {
    final _sharedPref = await SharedPreferences.getInstance();
    final _userLoggedIn = _sharedPref.getString(TOKEN);

    if (_userLoggedIn == null ) {
      await Future.delayed(Duration(milliseconds: 3000));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => AuthScreen(),
        ),
      );
    } else {
      DeviceDB().getDevices();
      await Future.delayed(Duration(milliseconds: 3000));

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => MainScreen(),
        ),
      );
    }
  }
}
