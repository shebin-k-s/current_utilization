import 'package:flutter/material.dart';
import 'package:saron/api/data/device.dart';
import 'package:saron/widgets/snackbar_message/snackbar_message.dart';

// ignore: must_be_immutable
class AddDevice extends StatelessWidget {
  AddDevice({super.key});
  TextEditingController serialNumberController = TextEditingController();
  TextEditingController deviceIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<String> _errorMessage = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 20.0,
      ),
      title: const Text(
        'Add New Device',
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
                controller: deviceIdController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Device ID',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: serialNumberController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Serial Number',
                  border: OutlineInputBorder(),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _errorMessage,
                builder: (context, value, child) {
                  if (value.length != 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
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

              String serialNumber = serialNumberController.text;
              String deviceId = deviceIdController.text;

              final statusCode =
                  await DeviceDB().addDevice(serialNumber, deviceId);
              if (statusCode == 200) {
                await DeviceDB().getDevices();
                Navigator.of(context).pop(true);
                snackbarMessage(context, "Device added successfully");
              } else if (statusCode == 400) {
                Navigator.of(context).pop(false);
                snackbarMessage(context, "Device already added to the user");
              } else if (statusCode == 204) {
                _errorMessage.value = "Device not found";
              } else if (statusCode == 404) {
                _errorMessage.value = "User not found";
              } else {
                _errorMessage.value = "Internal server error";
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          ),
          child: const Text(
            'Add',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
