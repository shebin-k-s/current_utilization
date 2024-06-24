import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:saron/Screens/device_screen/widget/add_device.dart';
import 'package:saron/Screens/device_screen/widget/device_card.dart';
import 'package:saron/api/device_model/device.dart';
import 'package:saron/api/load_data/load_devices.dart';
import 'package:saron/main.dart';
import 'package:saron/socket/socket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceScreen extends StatelessWidget {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ValueNotifier<List<Device>> deviceList = ValueNotifier([]);
  final SocketManager socketManager;

  DeviceScreen({super.key, required this.socketManager});

  void reloadDevices() async {
    socketManager.setDeviceStatusListener((data) async {
      final String currentDeviceListJson = jsonEncode(deviceList.value);
      List<Device> newDeviceList = await loadDeviceList();
      String newDeviceListJson = jsonEncode(newDeviceList);
      int i = 0;
      while (currentDeviceListJson == newDeviceListJson && i <= 10) {
        await Future.delayed(Duration(seconds: 1));

        newDeviceList = await loadDeviceList();
        newDeviceListJson = jsonEncode(newDeviceList);
        i++;
      }
      _isLoading.value = true;
      deviceList.value = newDeviceList;
      _isLoading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _isLoading.value = true;
      deviceList.value = await loadDeviceList();
      _isLoading.value = false;

      reloadDevices();
    });

    return FutureBuilder<String?>(
      future: getName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final String? username = snapshot.data;
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 210,
                        decoration: const BoxDecoration(
                          color: Color(0xFF5B0569),
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(30)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "HELLO, ",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    username?.toUpperCase() ?? '',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Good to see you again!",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "CONSERVATION: IT DOESN’T COST; IT SAVES.\nFOR YOUR BETTER TOMORROW, SAVE ENERGY TODAY.",
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 0.75),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ValueListenableBuilder(
                        valueListenable: _isLoading,
                        builder: (context, value, child) {
                          if (deviceList.value.isNotEmpty && !value) {
                            return GridView.count(
                              crossAxisCount: 2,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: List.generate(
                                deviceList.value.length,
                                (index) {
                                  final _isConnected =
                                      deviceList.value[index].deviceOn;
                                  return DeviceCard(
                                    deviceName:
                                        '${deviceList.value[index].deviceName}',
                                    deviceId:
                                        '${deviceList.value[index].deviceId}',
                                    serialNumber:
                                        '${deviceList.value[index].serialNumber}',
                                    connected: _isConnected!,
                                  );
                                },
                              ),
                            );
                          } else if (deviceList.value.isEmpty &&
                              !_isLoading.value) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/send_request.png",
                                ),
                                const Text(
                                  "Add device....",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddDevice();
                        },
                      ).then((value) async {
                        print(value);
                        if (value != null && value == true) {
                          _isLoading.value = true;
                          deviceList.value = await loadDeviceList();
                          _isLoading.value = false;
                          List<int> deviceIds = deviceList.value
                              .map((device) => device.deviceId!)
                              .toList();
                          socketManager.emitEvent('setDevices', deviceIds);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                    child: const Text(
                      'ADD NEW DEVICE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Future<String?> getName() async {
    final SharedPreferences _sharedPref = await SharedPreferences.getInstance();
    return _sharedPref.getString(USERNAME);
  }
}
