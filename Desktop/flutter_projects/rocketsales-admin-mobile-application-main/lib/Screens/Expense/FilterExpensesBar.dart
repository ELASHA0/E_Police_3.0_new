import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import 'package:flutter_debouncer/flutter_debouncer.dart';

import '../../../resources/my_colors.dart';
import 'ExpensesController.dart';

class FiltrationsystemExpenses extends StatefulWidget {
  const FiltrationsystemExpenses({super.key});

  @override
  State<FiltrationsystemExpenses> createState() =>
      _FiltrationsystemExpensesState();
}

class _FiltrationsystemExpensesState extends State<FiltrationsystemExpenses> {
  // new varibles made ,
  // DateTime - class
  // fromDate - varible
  // fromDate = will store all from which date it will start
  DateTime? fromDate;
  // tillDate will store till Date and different oprations can be applied on it .
  DateTime? tillDate;
  // not used
  DateTime? toDate;
 // DateTime class
  //  now() - Constructs a DateTime object with current date and time in the local time zone.
  DateTime Today = DateTime.now();
  // TimeofDay - Class , A value representing a time during the day, independent of the date that day might fall on or the time zone.

  TimeOfDay selectedTime = TimeOfDay.now();

  // setting hr - 0 and min - 0
  TimeOfDay twelveAM = const TimeOfDay(hour: 00, minute: 00);

  // late String dateTimeFilter = '';

  // Debouncer - class
  final Debouncer _debouncer = Debouncer() ;
      //- // The debounce() method
     // Every time it's called, it cancels any existing timer and starts a fresh one.;

  // _debouncer = A nullable Timer? that holds the currently scheduled timer.
  //       // Storing it as an instance variable is what allows cancellation —
  //       // without it, you couldn't stop the previous timer when a new call comes in.



  //  _varible private member variables to keep them separated from methods and public properties.
  // In Flutter, debouncing is a technique used to ensure that a
  // function is executed only after a specific period of inactivity,
  // no matter how many times the associated event (like a button tap or text input)
  // is triggered during that period. The previous function call is canceled if a new one occurs within the delay, and the timer is reset
 // Reduces API calls
  // what i understand is that the fuction is only called once so that api call goes only once ,
  // as multiple api call will be gone if the data keep changing .
  // not used
  // like if the button is pressed multiple times , the api won't be called that many times
  // the api will be called once , and till a specific time the Api will not be called
  //  in order to enhance the user experience and avoid unintended actions, unnecessary logic execution or frequent updates.
  final TextEditingController searchController = TextEditingController();

  // can also do find
  final ExpensesController controller = Get.put(ExpensesController());

  void _handleTextFieldChange(String value) {
    const duration = Duration(milliseconds: 500);
    _debouncer.debounce(
      // The core idea: Imagine you're searching as a user types.
      // Instead of firing an API call on every keystroke, you wait until they
      // stop typing for a moment. That's debouncing.

      duration: duration,
      onDebounce: () {
        // The onDebounce callback only runs based on the type:
        //trailingEdge (default) — waits for the quiet period to end, then fires. Classic debounce.
        // leadingEdge — fires immediately on the first call, then ignores further calls until the timer expires.
        // leadingAndTrailing — fires on both the first call and after the quiet period ends.
       // this is in expense controller
        controller.searchString.value = value;

        // get is put in it so that it is not called multiple times
        controller.getExpenses();
      },
    );
  }

  // Custom function .

  String formatTimeOfDayFull(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    // Without it, single-digit hours would display as "9" instead of "09",
    // which looks off in a time display like 9:05 vs 09:05.
    //padLeft(2, '0') ensures the hour is always 2 digits wide
    // by padding with '0' on the left if needed.
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

  String filterString(DateTime? fromDate, DateTime tillDate) {
    String filterString1 =
        "&startDate=${formatDate(fromDate)}&endDate=${formatDate(tillDate)}";
    return filterString1;
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      // initialDate: fromDate ?? DateTime.now(),
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
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
      // This sets the earliest selectable date in a Flutter date picker to January 1st, 2000.
      lastDate: DateTime.now(),
      // todays time
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
                          : '...',
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
                        fromDate, tillDate ?? DateTime.now());
                    controller.getExpenses();
                  },
                  label: const Icon(
                    Icons.check,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            /*Search */
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
                        hintText: 'Search Expenses',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Icon(Icons.search),
                ],
              ),
            ),
            /*other elements*/
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
                      controller.getExpenses();
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
                        print("Approved clicked");
                        controller.selectedTag.value = "Approved";
                      });

                      controller.getExpenses();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                      child: Container(
                          decoration: BoxDecoration(
                            color: controller.selectedTag.value == "Approved"
                                ? MyColor.dashbord
                                : Colors.green,
                            borderRadius: BorderRadius.circular(
                                10), // optional: rounded corners
                          ),
                          child: const Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                            child: Text(
                              "Approved",
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
                        print("pending clicked");
                        controller.selectedTag.value = "Pending";
                      });

                      controller.getExpenses();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                      child: Container(
                          decoration: BoxDecoration(
                            color: controller.selectedTag.value == "Pending"
                                ? MyColor.dashbord
                                : Colors.yellow,
                            borderRadius: BorderRadius.circular(
                                10), // optional: rounded corners
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                            child: Text(
                              "Pending",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      controller.selectedTag.value == "Pending"
                                          ? Colors.white
                                          : Colors.black87),
                            ),
                          )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        print("Rejected clicked");
                        controller.selectedTag.value = "Rejected";
                      });

                      controller.getExpenses();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                      child: Container(
                          decoration: BoxDecoration(
                            color: controller.selectedTag.value == "Rejected"
                                ? MyColor.dashbord
                                : Colors.red,
                            borderRadius: BorderRadius.circular(
                                10), // optional: rounded corners
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                            child: Text(
                              "Rejected",
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
