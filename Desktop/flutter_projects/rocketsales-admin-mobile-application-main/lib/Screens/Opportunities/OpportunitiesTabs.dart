import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsales_admin/Screens/Opportunities/Appointments/AppointmentsHistoryScreen.dart';
import 'package:rocketsales_admin/Screens/Workpad/ToDos/ToDosScreen.dart';

import '../../resources/my_colors.dart';
import 'Leads/LeadsController.dart';
import 'Leads/LeadsHistoryScreen.dart';

class OpportunitiesTabs extends StatefulWidget {
  const OpportunitiesTabs({super.key});

  @override
  State<OpportunitiesTabs> createState() => _OpportunitiesTabsState();
}

class _OpportunitiesTabsState extends State<OpportunitiesTabs> {

  final LeadsController notesController = Get.put(LeadsController(), permanent: true);
  // final ToDosController toDoController = Get.put(ToDosController(), permanent: true);

  int currentPageIndex = 0;
  var selectedIconColor = Colors.white;

  @override
  void dispose() {
    Get.delete<LeadsController>(force: true);
    // Get.delete<ToDosController>(force: true);
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
            selectedIcon: Icon(Icons.contact_page_outlined, color: selectedIconColor),
            icon: const Icon(Icons.contact_page_outlined),
            label: 'Leads',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month, color: selectedIconColor),
            icon: Icon(Icons.calendar_month),
            label: "Appointments",
          ),
        ],
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: MyColor.dashbord, // blue top bar
        title: const Text("Opportunities", style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: <Widget>[
        LeadHistoryScreen(),
        AppointmentsHistoryScreen(),
      ][currentPageIndex],
    );
  }
}