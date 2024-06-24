import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScrollableDate extends StatelessWidget {
  final Function(DateTime) onDateChange;
  final ValueNotifier<DateTime> selectedDate;

  ScrollableDate({
    Key? key,
    required this.onDateChange,
    required this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime firstDayOfMonth = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      1,
    );

    DateTime lastDayOfMonth = DateTime(
      selectedDate.value.year,
      selectedDate.value.month + 1,
      0,
    );

    int daysInMonth = lastDayOfMonth.day;
    double screenWidth = MediaQuery.of(context).size.width;
    double initialScrollOffset;
    if (selectedDate.value.day < 3) {
      initialScrollOffset = screenWidth * 0;
    } else if (selectedDate.value.day <= 6) {
      initialScrollOffset = screenWidth * 0.5;
    } else if (selectedDate.value.day <= 9) {
      initialScrollOffset = screenWidth * 1;
    } else if (selectedDate.value.day <= 12) {
      initialScrollOffset = screenWidth * 1.5;
    } else if (selectedDate.value.day <= 15) {
      initialScrollOffset = screenWidth * 2;
    } else if (selectedDate.value.day <= 18) {
      initialScrollOffset = screenWidth * 2.5;
    } else if (selectedDate.value.day <= 21) {
      initialScrollOffset = screenWidth * 3;
    } else if (selectedDate.value.day <= 24) {
      initialScrollOffset = screenWidth * 3.5;
    } else if (selectedDate.value.day <= 27) {
      initialScrollOffset = screenWidth * 4;
    } else {
      initialScrollOffset = screenWidth * 4.5;
    }

    return Container(
      height: 160,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => _changeYear(false),
                  icon: const Icon(
                    Icons.keyboard_double_arrow_left,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                IconButton(
                  onPressed: () => _changeMonth(false),
                  icon: const Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: selectedDate,
                  builder: (context, value, child) {
                    return Text(
                      DateFormat('MMMM yyyy').format(value),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    );
                  },
                ),
                IconButton(
                  onPressed: () => _changeMonth(true),
                  icon: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                IconButton(
                  onPressed: () => _changeYear(true),
                  icon: const Icon(
                    Icons.keyboard_double_arrow_right,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                controller: ScrollController(
                  initialScrollOffset: initialScrollOffset,
                ),
                itemBuilder: (context, index) {
                  DateTime currentDate = firstDayOfMonth.add(
                    Duration(days: index),
                  );

                  String formattedDate =
                      DateFormat('dd\nEEE').format(currentDate);

                  formattedDate = formattedDate.replaceRange(
                      3, 6, formattedDate.substring(3, 6).toUpperCase());
                  Color containerColor =
                      currentDate.day == selectedDate.value.day
                          ? Color.fromRGBO(27, 94, 32, 1)
                          : Colors.black;

                  return GestureDetector(
                    onTap: () {
                      DateTime newSelectedDate = DateTime(
                        selectedDate.value.year,
                        selectedDate.value.month,
                        currentDate.day,
                      );

                      selectedDate.value = newSelectedDate;
                      onDateChange(selectedDate.value);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: containerColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            formattedDate,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(width: 10);
                },
                itemCount: daysInMonth,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _changeMonth(bool forward) {
    int monthOffset = forward ? 1 : -1;
    DateTime newMonth = DateTime(
      selectedDate.value.year,
      selectedDate.value.month + monthOffset,
      1,
    );
    selectedDate.value = newMonth;
  }

  void _changeYear(bool forward) {
    int yearOffset = forward ? 1 : -1;
    DateTime newYear = DateTime(
      selectedDate.value.year + yearOffset,
      selectedDate.value.month,
      1,
    );
    selectedDate.value = newYear;
  }
}
