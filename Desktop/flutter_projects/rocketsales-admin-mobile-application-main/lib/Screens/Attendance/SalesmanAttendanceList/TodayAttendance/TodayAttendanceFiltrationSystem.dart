import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:intl/intl.dart';

import '../../../../resources/my_colors.dart';
import 'TodayAttendanceController.dart';

class TodayAttendanceFiltrationSystem extends StatefulWidget {
  const TodayAttendanceFiltrationSystem({super.key});

  @override
  State<TodayAttendanceFiltrationSystem> createState() => _TodayAttendanceFiltrationSystemState();
}

class _TodayAttendanceFiltrationSystemState extends State<TodayAttendanceFiltrationSystem> {
  DateTime? fromDate;
  DateTime? tillDate;

  DateTime? toDate;

  DateTime Today = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay.now();

  TimeOfDay twelveAM = const TimeOfDay(hour: 00, minute: 00);

  // late String dateTimeFilter = '';

  final Debouncer _debouncer = Debouncer();

  final TextEditingController searchController = TextEditingController();

  final TodayAttendanceController controller = Get.find();

  void _handleTextFieldChange(String value) {
    const duration = Duration(milliseconds: 1000);
    _debouncer.debounce(
      duration: duration,
      onDebounce: () {
        controller.searchString.value = value;
        controller.getAttendances();
      },
    );
  }

  String formatTimeOfDayFull(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute:00.000";
  }

  String formatTimeOfDay(BuildContext context, TimeOfDay time) {
    return time.format(context); // returns something like "1:45 PM"
  }

  String formatDate(DateTime? date) {
    if (date == null) return "";
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String filterString(DateTime? fromDate, DateTime? tillDate) {
    String filterString1 =
        "&fromDate=${formatDate(fromDate)}&toDate=${formatDate(tillDate)}";
    return filterString1;
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      // initialDate: fromDate ?? DateTime.now(),
      initialDate: fromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: MyColor.dashbord,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        fromDate = picked;
        // String date = formatDate(fromDate!);

        // _pickTime(date);
      });
    }
  }

  Future<void> _selectTillDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      // initialDate: fromDate ?? DateTime.now(),
      initialDate: tillDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: MyColor.dashbord,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        tillDate = picked;
        // String date = formatDate(fromDate!);

        // _pickTime(date);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
        child: Column(
          children: [
            Row(
              children: [
                // From date button
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      side: const BorderSide(color: Colors.black54),
                    ),
                    onPressed: () => _selectFromDate(context),
                    icon: const Icon(
                      Icons.date_range,
                      color: Colors.black,
                    ),
                    label: Text(
                      fromDate != null
                          ? DateFormat('dd/MM/yyyy').format(fromDate!)
                          : DateFormat('dd/MM/yyyy').format(DateTime.now()),
                      style: const TextStyle(color: Colors.black),
                      overflow: TextOverflow.ellipsis, // prevent overflow
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.arrow_forward_outlined,
                    size: 15,
                  ),
                ),

                // Till date button
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      side: const BorderSide(color: Colors.black54),
                    ),
                    onPressed: () => _selectTillDate(context),
                    icon: const Icon(
                      Icons.date_range,
                      color: Colors.black,
                    ),
                    label: Text(
                      tillDate != null
                          ? DateFormat('dd/MM/yyyy').format(tillDate!)
                          : DateFormat('dd/MM/yyyy').format(Today),
                      style: const TextStyle(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Apply button
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    side: const BorderSide(color: Colors.black),
                  ),
                  onPressed: () {
                    controller.dateTimeFilter.value = filterString(
                        fromDate, tillDate);
                    controller.getAttendances();
                  },
                  label: const Icon(
                    Icons.check,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 7, bottom: 7),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                // color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black54)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: _handleTextFieldChange,
                      decoration: const InputDecoration(
                        hintText: 'Search Salesmen',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Icon(Icons.search),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        print("show all clicked");
                        controller.selectedTag.value = "";
                      });
                      controller.getAttendances();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: MyColor.dashbord, // border color
                              width: 1, // border thickness
                            ),
                            color: controller.selectedTag.value == ""
                                ? MyColor.dashbord
                                : Colors.white,
                            borderRadius: BorderRadius.circular(
                                10), // optional: rounded corners
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                            child: Text(
                              "Show all",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: controller.selectedTag.value == ""
                                      ? Colors.white
                                      : MyColor.dashbord),
                            ),
                          )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        print("present clicked");
                        controller.selectedTag.value = "Present";
                      });

                      controller.getAttendances();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                      child: Container(
                          decoration: BoxDecoration(
                            color: controller.selectedTag.value == "Present"
                                ? MyColor.dashbord
                                : Colors.green,
                            borderRadius: BorderRadius.circular(
                                10), // optional: rounded corners
                          ),
                          child: const Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                            child: Text(
                              "Present",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        print("absent clicked");
                        controller.selectedTag.value = "Absent";
                      });

                      controller.getAttendances();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                      child: Container(
                          decoration: BoxDecoration(
                            color: controller.selectedTag.value == "Absent"
                                ? MyColor.dashbord
                                : Colors.red,
                            borderRadius: BorderRadius.circular(
                                10), // optional: rounded corners
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                            child: Text(
                              "Absent",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
