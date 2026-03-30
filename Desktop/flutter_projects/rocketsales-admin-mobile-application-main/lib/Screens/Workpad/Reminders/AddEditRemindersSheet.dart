import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:rocketsales_admin/Screens/Workpad/Reminders/ReminderModelDate.dart';

import '../../../resources/my_colors.dart';
import 'RemindersController.dart';

class AddEditRemindersSheet extends StatefulWidget {
  final bool isEdit;
  final ReminderModelDate? reminder;

  AddEditRemindersSheet({
    super.key,
    this.isEdit = false,
    this.reminder,
  });

  @override
  State<AddEditRemindersSheet> createState() => _AddEditRemindersSheetState();
}

class _AddEditRemindersSheetState extends State<AddEditRemindersSheet> {
  final RemindersController controller = Get.find<RemindersController>();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.titleController = TextEditingController(text: widget.reminder?.title ?? '');
    controller.bodyController = TextEditingController(text: widget.reminder?.description ?? '');
    // controller.reminderDateTime.value = widget.reminder?.reminderAt ?? DateTime.now();
  }

  @override
  void dispose() {
    controller.titleController.dispose();
    controller.bodyController.dispose();
    super.dispose();
  }

  void saveReminder() {
    if (widget.isEdit) {
      controller.updateReminder(context, widget.reminder!.id);
    } else {
      controller.uploadReminder(context);
    }
  }

  Future<void> setReminderDateTime(BuildContext context) async {
    // Step 1: Pick the date
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.reminderDateTime.value,
      firstDate: controller.reminderDateTime.value,
      lastDate: DateTime(2090),
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

    if (pickedDate == null) return; // user cancelled date picker

    // Step 2: Pick the time
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(controller.reminderDateTime.value),
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

    if (pickedTime == null) return; // user cancelled time picker

    // Step 3: Combine date + time
    final combinedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    controller.reminderDateTime.value = combinedDateTime;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: MyColor.dashbord
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")
                ),
                Text("Create reminder", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                FilledButton(
                    style: FilledButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: MyColor.dashbord
                    ),
                    onPressed: () {
                      saveReminder();
                      // print(controller.reminderDateTime);
                    },
                    child: Text("Submit")
                ),
              ],
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: controller.titleController,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Title is required";
                }
                return null;
              },
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: controller.bodyController,
              decoration: InputDecoration(
                labelText: "Short description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Short description is required";
                }
                return null;
              },
            ),
            SizedBox(height: 20,),
            Obx(() {
              return SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    side: const BorderSide(color: Colors.black54),
                  ),
                  onPressed: () => setReminderDateTime(context),
                  icon: const Icon(
                    Icons.date_range,
                    color: Colors.black,
                  ),
                  label: Text(DateFormat('dd/MM/yyyy hh:mm a')
                      .format(controller.reminderDateTime.value),
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }),
            SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }
}
