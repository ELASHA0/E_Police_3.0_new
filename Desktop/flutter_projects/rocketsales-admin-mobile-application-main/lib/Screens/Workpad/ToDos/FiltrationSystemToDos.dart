import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:intl/intl.dart';

import '../../../resources/my_colors.dart';
import 'ToDosController.dart';

class FiltrationSystemToDo extends StatefulWidget {
  const FiltrationSystemToDo({super.key});

  @override
  State<FiltrationSystemToDo> createState() => _FiltrationSystemToDoState();
}

class _FiltrationSystemToDoState extends State<FiltrationSystemToDo> {
  DateTime? fromDate;
  DateTime? tillDate;

  DateTime? toDate;

  DateTime Today = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay.now();

  TimeOfDay twelveAM = const TimeOfDay(hour: 00, minute: 00);

  // late String dateTimeFilter = '';

  final Debouncer _debouncer = Debouncer();

  final TextEditingController searchController = TextEditingController();

  final ToDosController controller = Get.find<ToDosController>();

  void _handleTextFieldChange(String value) {
    const duration = Duration(milliseconds: 500);
    _debouncer.debounce(
      duration: duration,
      onDebounce: () {
        controller.searchString.value = value;
        controller.getToDos();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
        child: Column(
          children: [
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
                        hintText: "Search to do's",
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
                        print("pending clicked");
                        controller.selectedTag.value = "Pending";
                      });

                      controller.getToDos();
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
                        print("completed clicked");
                        controller.selectedTag.value = "Completed";
                      });

                      controller.getToDos();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                      child: Container(
                          decoration: BoxDecoration(
                            color: controller.selectedTag.value == "Completed"
                                ? MyColor.dashbord
                                : Colors.green,
                            borderRadius: BorderRadius.circular(
                                10), // optional: rounded corners
                          ),
                          child: const Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                            child: Text(
                              "Completed",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                    ),
                  ),

                ],
              ),
            )
          ],
        ));
  }
}
