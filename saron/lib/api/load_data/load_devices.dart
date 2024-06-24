import 'dart:convert';
import 'package:saron/api/device_model/device.dart';
import 'package:saron/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Device>> loadDeviceList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String>? deviceJsonList = prefs.getStringList(DEVICES);

  if (deviceJsonList == null) {
    return [];
  }

  List<Device> devices = [];
  for (String deviceJson in deviceJsonList) {
    Map<String, dynamic> deviceMap = jsonDecode(deviceJson);
    Device device = Device.fromJson(deviceMap);
    devices.add(device);
  }
  return devices;
}
