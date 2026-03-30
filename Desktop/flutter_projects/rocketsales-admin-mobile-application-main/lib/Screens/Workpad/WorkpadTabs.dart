import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsales_admin/Screens/Workpad/Notes/NoteAddEditScreen.dart';
import 'package:rocketsales_admin/Screens/Workpad/Notes/NotesScreen.dart';
import 'package:rocketsales_admin/Screens/Workpad/Reminders/RemindersScreen.dart';
import 'package:rocketsales_admin/Screens/Workpad/ToDos/ToDosController.dart';
import 'package:rocketsales_admin/Screens/Workpad/ToDos/ToDosScreen.dart';

import '../../resources/my_colors.dart';
import 'Notes/NotesController.dart';
import 'Reminders/RemindersController.dart';

class WorkpadTabs extends StatefulWidget {
  const WorkpadTabs({super.key});

  @override
  State<WorkpadTabs> createState() => _WorkpadTabsState();
}

class _WorkpadTabsState extends State<WorkpadTabs> {

  final NotesController notesController = Get.put(NotesController(), permanent: true);
  final ToDosController toDoController = Get.put(ToDosController(), permanent: true);
  final RemindersController remindersController = Get.put(RemindersController(), permanent: true);

  int currentPageIndex = 0;
  var selectedIconColor = Colors.white;

  @override
  void dispose() {
    Get.delete<NotesController>(force: true);
    Get.delete<ToDosController>(force: true);
    Get.delete<RemindersController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color.fromRGBO(227, 239, 255, 1.0),
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
            selectedIconColor = Colors.white;
          });
        },
        indicatorColor: MyColor.dashbord,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.note_alt_outlined, color: selectedIconColor),
            icon: const Icon(Icons.note_alt_outlined),
            label: 'Notes',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.checklist, color: selectedIconColor),
            icon: Icon(Icons.checklist),
            label: "To Do's",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.edit_calendar, color: selectedIconColor),
            icon: Icon(Icons.edit_calendar),
            label: 'Reminder',
          ),
        ],
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: MyColor.dashbord, // blue top bar
        title: const Text("Workpad", style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: <Widget>[
        NotesScreen(),
        ToDosScreen(),
        RemindersScreen()
      ][currentPageIndex],
    );
  }
}