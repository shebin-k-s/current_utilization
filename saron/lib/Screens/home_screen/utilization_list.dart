import 'package:flutter/material.dart';
import 'package:saron/Screens/usage_screen/widgets/usage_card/usage_card.dart';
import 'package:saron/api/data/utilization.dart';
import 'package:saron/api/utilization_model/utilization_model.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class UtilizationList extends StatelessWidget {
  final ValueNotifier<List<UtilizationModel>> utilizationList =
      ValueNotifier([]);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final DateTime date;
  final int deviceId;
  String imageUrl = "assets/images/no_data.png";
  String message =
      "Excellent! Today's usage is nil,\nsaving energy effectively.";

  UtilizationList({
    super.key,
    required this.date,
    required this.deviceId,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd-MM-yyyy').format(date);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        utilizationList.value.clear();
        _isLoading.value = true;
        final _data = await UtilizationDB().history(
          date.toString(),
          date.toString(),
          deviceId,
        );

        if (_data.statusCode == 200) {
          utilizationList.value = _data.utilization;
        } else {
          imageUrl = "assets/images/network_error.png";
          message = "Could not send request";
        }
        _isLoading.value = false;
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          formattedDate.toString(),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder(
          valueListenable: _isLoading,
          builder: (context, value, child) {
            if (!value && utilizationList.value.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final _utilization = utilizationList.value[index];

                  return UsageCard(
                    deviceName: _utilization.deviceName!,
                    startTime: getTime(_utilization.startDate!),
                    endTime: getTime(_utilization.endDate!),
                    unitConsumed: _utilization.unitConsumed!.toString(),
                    duration: timeUsed(
                        _utilization.startDate!, _utilization.endDate!),
                  );
                },
                itemCount: utilizationList.value.length,
              );
            } else if (value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Container(
                width: double.infinity,
                child: Column(
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
                ),
              );
            }
          },
        ),
      )),
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
}
