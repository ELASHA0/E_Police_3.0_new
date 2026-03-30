import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsales_admin/Screens/Attendance/SalesmanAttendanceList/TodayAttendance/TodayAttendanceModel.dart';
import 'package:rocketsales_admin/Screens/SalesmanListScreen/SalesmanModel.dart';
import '../../../../resources/my_colors.dart';
import 'AttendanceCard.dart';
import 'AttendanceReport.dart';
import 'NewAttendanceController.dart';
import 'TableCalendar.dart';

class AttendanceScreen extends StatelessWidget {
  final String salesmanId;
  final String? salesmanSelfieBase64;
  final String salesmanName;
  const AttendanceScreen({super.key, required this.salesmanId, this.salesmanSelfieBase64, required this.salesmanName});


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewAttendanceController(salesmanId: salesmanId, salesmanSelfieBase64: salesmanSelfieBase64));
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Attendance",
          style: TextStyle(color: Colors.white),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: MyColor.dashbord,
      ),
      body: SingleChildScrollView(
        child:
            Obx(() {
              return Stack(
                  children: [
                    Column(
                      children: [
                        AttendanceCard(
                          salesmanName: salesmanName,
                          date: controller.focusedDay.value,
                        ),
                        TableCalendarWidget(),
                        AttendanceReport(salesmanId: salesmanId,)
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
            })

      ),
    );
  }
}
