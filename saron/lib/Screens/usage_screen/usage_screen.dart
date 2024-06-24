import 'package:animated_loading_indicators/animated_loading_indicators.dart';
import 'package:flutter/material.dart';
import 'package:saron/api/data/utilization.dart';
import 'package:saron/api/device_model/device.dart';
import 'package:saron/api/load_data/load_devices.dart';
import 'package:saron/widgets/custom_button/custom_button.dart';
import 'package:saron/Screens/usage_screen/widgets/scrollable_date/scrollable_date.dart';
import 'package:saron/Screens/usage_screen/widgets/usage_card/usage_card.dart';
import 'package:saron/api/utilization_model/utilization_model.dart';
import 'package:intl/intl.dart';

class UsageScreen extends StatelessWidget {
  UsageScreen({super.key});

  final ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());

  final ValueNotifier<List<UtilizationModel>> utilizationList =
      ValueNotifier([]);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<int> _selectedDeviceIndex = ValueNotifier(0);
  final ValueNotifier<List<Device>> deviceList = ValueNotifier([]);
  String imageUrl = "assets/images/no_data.png";
  String message =
      "Excellent! Today's usage is nil,\nsaving energy effectively.";

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        isLoading.value = true;
        deviceList.value = await loadDeviceList();

        utilizationList.value.clear();
        final _data = await UtilizationDB().history(
          selectedDate.value.toString(),
          selectedDate.value.toString(),
          deviceList.value[_selectedDeviceIndex.value].deviceId ?? -1,
        );

        if (_data.statusCode == 200) {
          utilizationList.value = _data.utilization;
        } else {
          imageUrl = "assets/images/network_error.png";
          message = "Could not send request";
        }
        isLoading.value = false;
      },
    );
    return SafeArea(
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: selectedDate,
            builder: (context, value, child) {
              return ScrollableDate(
                  selectedDate: selectedDate,
                  onDateChange: (date) => fetchData(date));
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 1,
            color: Color.fromRGBO(255, 255, 255, 0.3),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            child: ValueListenableBuilder(
              valueListenable: deviceList,
              builder: (context, device, child) {
                if (device.isNotEmpty) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ValueListenableBuilder(
                          valueListenable: _selectedDeviceIndex,
                          builder: (context, deviceIndex, child) {
                            return CustomButton(
                              btnColor: deviceIndex == index
                                  ? Color.fromRGBO(27, 94, 32, 1)
                                  : Colors.transparent,
                              text:
                                  device[index].deviceName!.toUpperCase(),
                              onClick: () {
                                _selectedDeviceIndex.value = index;
                                fetchData(selectedDate.value);
                              },
                            );
                          },
                        ),
                      );
                    },
                    itemCount: device.length,
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (context, value, child) {
                if (value) {
                  return const Center(
                      child: InfinityCradle(
                    size: 50,
                    color: Colors.green,
                    duration: Duration(seconds: 1),
                  ));
                } else if (!value && utilizationList.value.isNotEmpty) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final _utilization = utilizationList.value[index];

                      return UsageCard(
                        deviceName: _utilization.deviceName ?? "",
                        startTime: getTime(_utilization.startDate!),
                        endTime: getTime(_utilization.endDate!),
                        unitConsumed: _utilization.unitConsumed!.toString(),
                        duration: timeUsed(
                            _utilization.startDate!, _utilization.endDate!),
                      );
                    },
                    itemCount: utilizationList.value.length,
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        imageUrl,
                      ),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String getTime(String date) {
    DateTime statTime = DateTime.parse(date);
    String formattedTime = DateFormat('h:mm:ss a').format(statTime);
    return formattedTime;
  }

  String timeUsed(String startTimeString, String endTimeString) {
    DateTime startTime = DateTime.parse(startTimeString);
    DateTime endTime = DateTime.parse(endTimeString);

    Duration difference = endTime.difference(startTime);

    int hours = difference.inHours;
    int minutes = difference.inMinutes.remainder(60);
    int seconds = difference.inSeconds.remainder(60);

    String formattedTime = '';

    if (hours > 0) {
      formattedTime += '${hours} hours';
    }

    if (minutes > 0) {
      if (formattedTime.isNotEmpty) {
        formattedTime += ', ';
      }
      formattedTime += '${minutes} minutes';
    }

    if (seconds > 0) {
      if (formattedTime.isNotEmpty) {
        formattedTime += ', ';
      }
      formattedTime += '${seconds} seconds';
    }

    return formattedTime;
  }

  void fetchData(DateTime date) async {
    isLoading.value = true;
    selectedDate.value = date;
    utilizationList.value.clear();
    final _data = await UtilizationDB().history(
      selectedDate.value.toString(),
      selectedDate.value.toString(),
      deviceList.value[_selectedDeviceIndex.value].deviceId ?? -1,
    );

    if (_data.statusCode == 200) {
      imageUrl = "assets/images/no_data.png";
      message = "Excellent! Today's usage is nil,\nsaving energy effectively.";

      utilizationList.value = _data.utilization;
    } else {
      imageUrl = "assets/images/network_error.png";
      message = "Could not send request";
    }

    isLoading.value = false;
  }
}
