import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:intl/intl.dart';

import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:rocketsales_admin/Screens/MeetingandCollaboration/LeadGeneration/LeadCard.dart';
import 'package:rocketsales_admin/Screens/MeetingandCollaboration/LeadGeneration/LeadgenerationController.dart';

import '../../../resources/my_colors.dart';

class Datefilterlead extends StatefulWidget {
  const Datefilterlead({super.key});

  @override
  State<Datefilterlead> createState() => _DatefilterleadState();
}

class _DatefilterleadState extends State<Datefilterlead> {
  DateTime? firstDate;
  DateTime? lastDate;

  DateTime todayDateTimeEntry = DateTime.now();
  TimeOfDay todayTime = TimeOfDay.now();

  TimeOfDay hrMin = const TimeOfDay(hour: 00, minute: 00);

  final Debouncer _debouncerlead = Debouncer();

  final LeadGenerationController leadGenerationController =
      Get.find<LeadGenerationController>();

  void _handleleadTextFieldChange(String value) {
    const duration = Duration(milliseconds: 500);
    _debouncerlead.debounce(
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
        leadGenerationController.findString.value = value;

        // get is put in it so that it is not called multiple times
        leadGenerationController.getLeads();
      },
    );
  }

  String changeTimeOfDayFull(TimeOfDay todayTime) {
    final hours = todayTime.hour.toString().padLeft(2, '0');
    final minutes = todayTime.minute.toString().padLeft(2, '0');
    return "$hours:$minutes:00.000";
  }

  String changeTimeOfDay(BuildContext context, TimeOfDay time) {
    return time.format(context);
  }

  String changeDate(DateTime? date) {
    if (date == null) return "";
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String filterleadString(DateTime? firstDate, DateTime? lastDate) {
    String filterDate =
        "&startDate=${changeDate(firstDate)}&endDate=${formatDate(lastDate.toString())}";
    return filterDate;
  }

  Future<void> _selectStartDate(BuildContext) async {
    final pickeds = await showDatePicker(
      context: context,
      initialDate: firstDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickeds != null) {
      setState(() {
        firstDate = pickeds;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final pickeds = await showDatePicker(
      context: context,
      initialDate: lastDate ?? DateTime.now(),
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
    if (pickeds != null) {
      setState(() {
        lastDate = pickeds;
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
                  onPressed: () => _selectStartDate(BuildContext),
                  icon: const Icon(Icons.date_range, color: Colors.black),
                  label: Text(
                    firstDate != null
                        ? DateFormat('dd/MM/yyyy').format(firstDate!)
                        : '...',
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis, // prevent overflow
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.all(2.0),
                child: Icon(Icons.arrow_forward_outlined, size: 15),
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
                  onPressed: () => _selectEndDate(context),
                  icon: const Icon(Icons.date_range, color: Colors.black),
                  label: Text(
                    lastDate != null
                        ? DateFormat('dd/MM/yyyy').format(lastDate!)
                        : DateFormat('dd/MM/yyyy').format(todayDateTimeEntry),
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
                  leadGenerationController.dateTimeLeadFilter.value =
                      filterleadString(firstDate, lastDate ?? DateTime.now());
                  leadGenerationController.getLeads();
                },
                label: const Icon(Icons.check, color: Colors.black),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 7, bottom: 7),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              // color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black54),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: leadGenerationController.searchTextController,
                    onChanged: _handleleadTextFieldChange,
                    decoration: const InputDecoration(
                      hintText: 'Search Leads',
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
                      print("Pending");
                      leadGenerationController.choosenTag.value = "Pending";
                    });
                    leadGenerationController.getLeads();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: MyColor.dashbord, width: 1),
                        color:
                            leadGenerationController.choosenTag.value ==
                                "Pending"
                            ? MyColor.dashbord
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 20,
                          right: 20,
                        ),
                        child: Text(
                          "Pending",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                leadGenerationController.choosenTag.value ==
                                    "Pending"
                                ? Colors.white
                                : MyColor.dashbord,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      print("In-progress clicked");
                      leadGenerationController.choosenTag.value = "In-progress";
                    });

                    leadGenerationController.getLeads();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            leadGenerationController.choosenTag.value ==
                                "In-progress"
                            ? MyColor.dashbord
                            : Colors.green,
                        borderRadius: BorderRadius.circular(
                          10,
                        ), // optional: rounded corners
                      ),
                      child: const Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 20,
                          right: 20,
                        ),
                        child: Text(
                          "In-progress",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      print("Completed clicked");
                      leadGenerationController.choosenTag.value = "Completed";
                    });

                    leadGenerationController.getLeads();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            leadGenerationController.choosenTag.value ==
                                "Completed"
                            ? MyColor.dashbord
                            : Colors.yellow,
                        borderRadius: BorderRadius.circular(
                          10,
                        ), // optional: rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 20,
                          right: 20,
                        ),
                        child: Text(
                          "Completed",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                leadGenerationController.choosenTag.value ==
                                    "Completed"
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      print("Canceled clicked");
                      leadGenerationController.choosenTag.value = "Canceled";
                    });

                    leadGenerationController.getLeads();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            leadGenerationController.choosenTag.value ==
                                "Canceled"
                            ? MyColor.dashbord
                            : Colors.red,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 20,
                          right: 20,
                        ),
                        child: Text(
                          "Canceled",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
