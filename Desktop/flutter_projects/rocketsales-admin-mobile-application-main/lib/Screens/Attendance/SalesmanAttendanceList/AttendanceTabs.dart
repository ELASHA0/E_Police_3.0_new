import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rocketsales_admin/Screens/Attendance/SalesmanAttendanceList/ManualAttendance/ManualAttendanceScreen.dart';
import 'package:rocketsales_admin/Screens/Attendance/SalesmanAttendanceList/TodayAttendance/TodayAttendanceController.dart';
import 'package:rocketsales_admin/Screens/Attendance/SalesmanAttendanceList/TodayAttendance/TodayAttendanceScreen.dart';

import '../../../resources/my_colors.dart';
import 'ManualAttendance/ManualAttendanceController.dart';

class AttendanceTabs extends StatefulWidget {
  const AttendanceTabs({super.key});

  @override
  State<AttendanceTabs> createState() => _AttendanceTabsState();
}

class _AttendanceTabsState extends State<AttendanceTabs> with TickerProviderStateMixin {
  final TodayAttendanceController controller = Get.put(TodayAttendanceController());
  final ManualAttendanceController manualAttendanceController = Get.put(ManualAttendanceController());

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    int initialIndex = Get.arguments ?? 0;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: initialIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    // Get.delete<QRCardsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.dashbord,
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text(
          'Attendance',
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: Colors.white),
          tabs: <Widget>[
            Tab(
              child: Text(
                'Today Attendance',
                textAlign: TextAlign.center,
                style:
                TextStyle(fontSize: getResponsiveFontSize(context, 12.0)),
              ),
            ),
            Tab(
              child: Text(
                'Manual Attendance',
                textAlign: TextAlign.center,
                style:
                TextStyle(fontSize: getResponsiveFontSize(context, 12.0)),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TodayAttendanceScreen(),
          ManualAttendanceScreen(),
        ],
      ),
    );
  }

  double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double referenceWidth = 375.0; // iPhone 8 width
    return baseFontSize * (screenWidth / referenceWidth);
  }
}
