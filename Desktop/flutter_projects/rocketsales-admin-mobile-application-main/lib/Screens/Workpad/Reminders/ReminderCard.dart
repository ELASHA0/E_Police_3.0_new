import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:rocketsales_admin/Screens/Workpad/Reminders/ReminderModelDate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../resources/my_colors.dart';
import 'AddEditRemindersSheet.dart';
import 'RemindersController.dart';

class ReminderCard extends StatefulWidget {
  final ReminderModelDate reminder;

  ReminderCard({super.key, required this.reminder});

  @override
  State<ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {
  final RemindersController controller = Get.find<RemindersController>();

  final ExpansibleController expansionController = ExpansibleController();
  bool _isExpanded = false;

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  late String reminderStatus;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: Colors.black12, // border color
          width: 2, // border thickness
        ),
      ),
      child: GestureDetector(
        onTap: () {
          if (expansionController.isExpanded) {
            expansionController.collapse();
          } else {
            expansionController.expand();
          }
        },
        child: ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
          tilePadding:
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          controller: expansionController,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd/MM/yyyy hh:mm a')
                    .format(widget.reminder.reminderAt),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54
                )
              ),
              SizedBox(height: 5,),
              Text(widget.reminder.title,
                  maxLines: _isExpanded ? 20 : 1,
                  softWrap: _isExpanded ? true : false,
                  overflow: TextOverflow.fade),
            ],
          ),
          subtitle: Text(widget.reminder.description,
              maxLines: _isExpanded ? 20 : 1,
              softWrap: _isExpanded ? true : false,
              overflow: TextOverflow.fade),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  child: OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColor.dashbord,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Adjust radius as needed
                        ),
                      ),
                      onPressed: () {
                        Get.bottomSheet(
                            isScrollControlled: true,
                            AddEditRemindersSheet(isEdit: true, reminder: widget.reminder)
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          SizedBox(width: 2),
                          Text(
                            "Edit Reminder",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(right: 15, left: 15, bottom: 8),
                  child: OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.red,
                          width: 1.5, // thickness of border
                        ),
                        backgroundColor: const Color.fromRGBO(247, 210, 210, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Adjust radius as needed
                        ),
                      ),
                      onPressed: () {
                        controller.deleteReminder(context, widget.reminder.id);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete_outline_outlined,
                            color: Colors.red,
                          ),
                          Text(
                            "Delete Reminder",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
