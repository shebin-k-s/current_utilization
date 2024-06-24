import 'package:flutter/material.dart';
import 'package:saron/api/data/utilization.dart';
import 'package:saron/widgets/custom_button/custom_button.dart';
import 'package:saron/widgets/snackbar_message/snackbar_message.dart';

class CalendarPicker extends StatefulWidget {
  final Function(double, DateTime, DateTime) onDateChange;
  final Function(bool) isLoading;
  final Function(bool) onError;
  final int deviceId;

  const CalendarPicker({
    super.key,
    required this.onDateChange,
    required this.isLoading,
    required this.deviceId,
    required this.onError,
  });

  @override
  _CalendarPickerState createState() => _CalendarPickerState();
}

class _CalendarPickerState extends State<CalendarPicker> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = null;
    _endDate = null;

    // _startDate = DateTime.parse("2024-05-01 00:00:00.000");
    // _endDate = DateTime.parse("2024-05-17 00:00:00.000");
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                btnColor: Colors.transparent,
                text: _startDate != null
                    ? '${_startDate?.day}/${_startDate?.month}/${_startDate?.year}'
                    : 'Start Date',
                onClick: () => _selectStartDate(context),
              ),
              CustomButton(
                btnColor: Colors.transparent,
                text: _endDate != null
                    ? '${_endDate?.day}/${_endDate?.month}/${_endDate?.year}'
                    : 'End Date',
                onClick: () => _selectEndDate(context),
              ),
              CustomButton(
                btnColor: Colors.transparent,
                text: "Submit",
                onClick: () => fetchData(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void fetchData(BuildContext ctx) async {
    if (_startDate != null &&
        _endDate != null &&
        (_startDate!.isBefore(_endDate!) ||
            _startDate!.isAtSameMomentAs(_endDate!))) {
      widget.isLoading(true);
      UtilizationDB utilizationDB = UtilizationDB();
      try {
        double unitConsumed = await utilizationDB.unitConsumed(
            _startDate.toString(), _endDate.toString(), widget.deviceId);

        if (unitConsumed < 0) {
          widget.onError(true);
        } else {
          widget.onDateChange(unitConsumed, _startDate!, _endDate!);
        }
      } catch (e) {
          widget.onError(true);
      } finally {
        widget.isLoading(false);
      }
    } else {
      snackbarMessage(ctx, 'Select Proper Date');
    }
  }
}
