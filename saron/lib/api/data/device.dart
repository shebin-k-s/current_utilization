import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:saron/api/device_model/device.dart';
import 'package:saron/api/device_model/device_model.dart';
import 'package:saron/api/url/url.dart';
import 'package:saron/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceResult {
  final List<Device> devices;
  final int statusCode;

  DeviceResult(this.devices, this.statusCode);
}

abstract class ApiCalls {
  Future<DeviceResult> getDevices();
  Future<int> addDevice(
    String serialNumber,
    String deviceId,
  );
  Future<int> deleteDevice(
    String serialNumber,
    String deviceId,
  );
  Future<int> changeDeviceName(
    String serialNumber,
    String deviceId,
    String deviceName,
  );
}

class DeviceDB extends ApiCalls {
  final Dio dio = Dio();
  final Url url = Url();
  late SharedPreferences _sharedPref;
  late String _token;
  bool _initialized = false;

  DeviceDB() {
    _initialize();
  }

  Future<void> _initialize() async {
    _sharedPref = await SharedPreferences.getInstance();
    _token = _sharedPref.getString(TOKEN) ?? '';
    dio.options = BaseOptions(
      baseUrl: url.baseUrl,
      responseType: ResponseType.plain,
      headers: {
        "authorization": _token,
      },
    );
    _initialized = true;
  }

  @override
  Future<int> addDevice(String serialNumber, String deviceId) async {
    if (!_initialized) {
      await _initialize();
    }

    try {
      final response = await dio.post(
        url.addDevice,
        data: {
          'serialNumber': serialNumber,
          'deviceId': deviceId,
        },
      );

      return response.statusCode ?? -1;
    } catch (e) {
      if (e is DioException && e.response != null) {
        return e.response!.statusCode ?? -1;
      } else {
        return -1;
      }
    }
  }

  @override
  Future<int> deleteDevice(String serialNumber, String deviceId) async {
    if (!_initialized) {
      await _initialize();
    }

    try {
      final response = await dio.delete(
        url.removeDevice,
        data: {
          'serialNumber': serialNumber,
          'deviceId': deviceId,
        },
      );

      return response.statusCode ?? -1;
    } catch (e) {
      if (e is DioException && e.response != null) {
        return e.response!.statusCode ?? -1;
      } else {
        return -1;
      }
    }
  }

  @override
  Future<DeviceResult> getDevices() async {
    if (!_initialized) await _initialize();

    try {
      final response = await dio.get(url.getDevice);

      if (response.statusCode == 200) {
        final resultAsJson = jsonDecode(response.data);
        final deviceModel = DeviceModel.fromJson(resultAsJson);
        final devices = deviceModel.devices;

        if (devices != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove(DEVICES);
          final deviceStrings =
              devices.map((device) => jsonEncode(device.toJson())).toList();
          prefs.setStringList(DEVICES, deviceStrings);
        }
        return DeviceResult(devices!, response.statusCode!);
      } else {
        return DeviceResult([], response.statusCode!);
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        return DeviceResult([], e.response!.statusCode!);
      } else {
        return DeviceResult([], -1);
      }
    }
  }

  @override
  Future<int> changeDeviceName(
      String serialNumber, String deviceId, String deviceName) async {
    if (!_initialized) {
      await _initialize();
    }

    try {
      final response = await dio.post(
        url.changeDeviceName,
        data: {
          'serialNumber': serialNumber,
          'deviceId': deviceId,
          'deviceName': deviceName
        },
      );

      return response.statusCode ?? -1;
    } catch (e) {
      if (e is DioException && e.response != null) {
        return e.response!.statusCode ?? -1;
      } else {
        return -1;
      }
    }
  }
}
