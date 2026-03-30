import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:rocketsales_admin/Screens/Workpad/Reminders/ReminderCard.dart';
import 'package:rocketsales_admin/Screens/Workpad/Reminders/RemindersController.dart';

import '../../../resources/my_colors.dart';
import 'ReminderTableCalendar.dart';
import 'AddEditRemindersSheet.dart';

class RemindersScreen extends StatelessWidget {
  RemindersScreen({super.key});

  final RemindersController controller = Get.find<RemindersController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.bottomSheet(
            isScrollControlled: true,
            AddEditRemindersSheet()
          );
        },
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
        child: const Icon(Icons.edit),
      ),
      body: Obx(() {
        return Stack(
            children: [
              Column(
                children: [
                  RemindersTableCalendar(),
                  Divider(),
                  const Text(
                    "Reminders",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  controller.reminders.isEmpty ?
                  const Expanded(
                    child: Center(
                      child: Text(
                        "No Reminders",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                  ) :
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.reminders.length,
                      itemBuilder: (context, index) {
                        final reminder = controller.reminders[index];
                        return ReminderCard(reminder: reminder);
                      },
                    ),
                  ),
                ],
              ),
              if (controller.isLoading.value)
                Positioned.fill(
                  child: Container(
                    color: Color.fromRGBO(0, 0, 0, 0.35),
                    child: const Center(
                      child: CircularProgressIndicator(
                          color: MyColor.dashbord),
                    ),
                  ),
                ),
            ]
        );
      }),
    );
  }
}
