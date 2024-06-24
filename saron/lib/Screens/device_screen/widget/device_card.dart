import 'package:flutter/material.dart';
import 'package:saron/api/data/device.dart';
import 'package:saron/widgets/snackbar_message/snackbar_message.dart';

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final String deviceId;
  final String serialNumber;
  final bool connected;

  DeviceCard({
    Key? key,
    required this.deviceName,
    required this.deviceId,
    required this.serialNumber,
    required this.connected,
  }) : super(key: key);
  final ValueNotifier<String> _deviceName = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    _deviceName.value = deviceName;
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color(0xff7A195F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.asset("assets/images/plug_socket.png"),
                  const SizedBox(width: 8.0),
                  Text(
                    connected ? 'CONNECTED' : 'DISCONNECTED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: _deviceName,
                        builder: (context, value, child) {
                          return Text(
                            value.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          _showChangeNameDialog(
                              context, serialNumber, deviceId);
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'DEVICE ID: $deviceId',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'S.NO: $serialNumber',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeNameDialog(
      BuildContext context, String serialNumber, String deviceId) {
    final TextEditingController deviceNameController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 20.0,
          ),
          title: const Text(
            'Change Device Name',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: deviceNameController,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'New Device Name',
                      labelStyle: TextStyle(
                        fontSize: 16,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  FocusScope.of(context).unfocus();

                  final statusCode = await DeviceDB().changeDeviceName(
                      serialNumber, deviceId, deviceNameController.text);
                  if (statusCode == 200) {
                    DeviceDB().getDevices();
                    _deviceName.value = deviceNameController.text;
                    Navigator.of(context).pop();
                    snackbarMessage(
                        context, "Device name updated successfully");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
              ),
              child: const Text(
                'Update',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
