import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../resources/my_colors.dart';
import 'RemindersController.dart';

class RemindersTableCalendar extends StatefulWidget {
  const RemindersTableCalendar({super.key});

  @override
  State<RemindersTableCalendar> createState() => _RemindersTableCalendarState();
}

class _RemindersTableCalendarState extends State<RemindersTableCalendar> {
  final RemindersController controller = Get.find<RemindersController>();

  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return TableCalendar(
        headerStyle: HeaderStyle(
          formatButtonVisible : false,
        ),
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2090, 1, 1),
        focusedDay: controller.focusedDay.value ?? DateTime.now(),
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            controller.focusedDay.value = focusedDay;
          });
          controller.getRemindersOnDate(DateFormat("yyyy-MM-dd").format(selectedDay)).then((_) {
            // controller.getRenderOfMonth(DateFormat("yyyy-MM").format(controller.reminderDateTime.value));
          });
        },
        onPageChanged: (focusedDay) {
          setState(() {
            controller.focusedDay.value = focusedDay;
            controller
                .getRenderOfMonth(DateFormat("yyyy-MM").format(focusedDay));
          });
        },
        calendarBuilders:
        CalendarBuilders(defaultBuilder: (context, day, focusedDay) {
          if (controller.isDateHasReminder(day)) {
            return Container(
              margin: const EdgeInsets.all(6.0),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                "${day.day}",
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else {
            return null;
          }
        }, todayBuilder: (context, day, focusedDay) {
          if (controller.isDateHasReminder(day)) {
            return Container(
              margin: const EdgeInsets.all(6.0),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                "${day.day}",
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else {
            return null;
          }
        }, markerBuilder: (context, date, events) {
          final count = controller.getCountForDate(date);
          if (count > 0) {
            return Positioned(
              right: 1,
              bottom: 1,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          } else {
            return null;
          }
        },
        ),
      );
    });
  }
}
