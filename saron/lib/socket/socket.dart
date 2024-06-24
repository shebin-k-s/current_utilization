import 'dart:convert';
import 'dart:io';

import 'package:saron/api/load_data/load_devices.dart';
import 'package:saron/api/url/url.dart';
import 'package:saron/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;



class SocketManager {
  late IO.Socket socket;

  SocketManager() {
    socket = IO.io(
      Url().baseUrl,
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );

    setDeviceStatusListener((data) async {
      if (data != null &&
          data['deviceId'] != null &&
          data['deviceOn'] != null) {
        int deviceId = data['deviceId'];
        bool deviceOn = data['deviceOn'].toLowerCase() == 'true';

        SharedPreferences prefs = await SharedPreferences.getInstance();

        final devices = await loadDeviceList();

        final int index =
            devices.indexWhere((device) => device.deviceId == deviceId);

        if (index != -1) {
          devices[index].deviceOn = deviceOn;

          List<String> updatedDeviceJsonList =
              devices.map((device) => jsonEncode(device.toJson())).toList();

          await prefs.remove(DEVICES);
          await prefs.setStringList(DEVICES, updatedDeviceJsonList);
          print('Device $deviceId status updated to $deviceOn');

        } else {
          print('Device $deviceId not found in the device list');
        }
      }
    });
  }

  void connect() {
    socket.connect();
  }

  void disconnect() {
    socket.disconnect();
  }

  void setDeviceStatusListener(void Function(dynamic) listener) {
    socket.on('deviceStatus', listener);
  }

  void emitEvent(String eventName, List<int> data) {
    socket.emit(eventName, data);
  }
}
