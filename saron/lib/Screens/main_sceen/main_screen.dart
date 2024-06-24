import 'dart:io';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:saron/Screens/device_screen/device_screen.dart';
import 'package:saron/Screens/home_screen/home_screen.dart';
import 'package:saron/Screens/main_sceen/widgets/bottom_navigation/bottom_navigation.dart';
import 'package:saron/Screens/settings_screen/settings_screen.dart';
import 'package:saron/Screens/usage_screen/usage_screen.dart';
import 'package:saron/api/device_model/device.dart';
import 'package:saron/api/load_data/load_devices.dart';
import 'package:saron/main.dart';
import 'package:saron/socket/socket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatelessWidget {
  final ValueNotifier<int> selectedBottomIndex = ValueNotifier(0);

  final SocketManager socketManager = SocketManager();

  bool isDeviceScreen = false;

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      List<Device> deviceList = await loadDeviceList();

      List<int> deviceIds =
          deviceList.map((device) => device.deviceId!).toList();
      socketManager.emitEvent('setDevices', deviceIds);
      
    });

    final _screens = [
      HomeScreen(),
      DeviceScreen(
        socketManager: socketManager,
      ),
      UsageScreen(),
      const SettingsScreen(),
    ];
    return ValueListenableBuilder(
      valueListenable: selectedBottomIndex,
      builder: (context, value, child) {
        return Scaffold(
          bottomNavigationBar: BottomNavigation(
            onItemTapped: (index) {
              return selectedBottomIndex.value = index;
            },
            selectedIndex: value,
          ),
          body: DoubleBackToCloseApp(
            snackBar: const SnackBar(
              content: Text('Tap back again to leave'),
            ),
            child: _screens[value],
          ),
        );
      },
    );
  }
}
