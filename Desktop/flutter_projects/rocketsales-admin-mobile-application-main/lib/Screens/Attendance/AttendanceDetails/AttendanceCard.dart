import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rocketsales_admin/Screens/Attendance/SalesmanAttendanceList/TodayAttendance/TodayAttendanceModel.dart';

import '../../../../../resources/my_colors.dart';
import '../../AdminDashboard/AdminDashboardController.dart';
import 'dart:typed_data';

import 'NewAttendanceController.dart';
import 'SelfieTakingScreenAttendance.dart';

class AttendanceCard extends StatelessWidget {
  final DateTime? date;
  final String salesmanName;

  AttendanceCard({
    super.key,
    required this.date,
    required this.salesmanName,
  });

  final NewAttendanceController controller =
      Get.find<NewAttendanceController>();

  final adminDashboardController controllerDashboard =
  Get.find<adminDashboardController>();

  String formatDateTime(DateTime dateTime) {
    // Day with suffix (st, nd, rd, th)
    String day = DateFormat('d').format(dateTime);
    String suffix = 'th';
    if (!(day.endsWith('11') || day.endsWith('12') || day.endsWith('13'))) {
      if (day.endsWith('1')) suffix = 'st';
      else if (day.endsWith('2')) suffix = 'nd';
      else if (day.endsWith('3')) suffix = 'rd';
    }

    String formattedDate = DateFormat("d'$suffix' MMM yyyy, hh:mm a").format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    controller.salesmanName.value = salesmanName;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.blue.shade200, width: 1),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Obx(() {
                    Uint8List? profileImage = controller.bytes.value;
                    if (controller.isLoading.value) {
                      return const CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 30,
                        child: CircularProgressIndicator(color: MyColor.dashbord),
                      );
                    } else if (profileImage == null || controllerDashboard.bytes.value == null) {
                      return const CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 30,
                        child: Icon(Icons.person, size: 30, color: Colors.white), // default avatar
                      );
                    } else {
                      return CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 30,
                        backgroundImage: MemoryImage(profileImage),
                      );
                    }
                  }),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          salesmanName,
                          // "jshdbfkgjsbdfgldjsfglsjdfgsdfgsdhsgfh",
                          maxLines: 3,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: MyColor.dashbord),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 16, color: Colors.black54),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat("dd/MM/yyyy").format(date!),
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(height: 24),

              Obx(() {
                return Column(children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.arrow_forward_ios, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Check in",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(Icons.watch_later_outlined, color: MyColor.dashbord, size: 17,),
                                SizedBox(width: 5,),
                                Text(
                                  controller.checkInDateTime.value != null
                                      ? formatDateTime(controller.checkInDateTime.value!)
                                      : "N/A",
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.location_on_outlined, color: MyColor.dashbord, size: 17),
                                SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    controller.checkInAddressString.value,
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            )

                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Address
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.arrow_back_ios, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Check out",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(Icons.watch_later_outlined, color: MyColor.dashbord, size: 17,),
                                SizedBox(width: 5,),
                                Text(
                                  controller.checkOutDateTime.value != null
                                      ? formatDateTime(controller.checkOutDateTime.value!)
                                      : "N/A",
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.location_on_outlined, color: MyColor.dashbord, size: 17),
                                SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    controller.checkOutAddressString.value,
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Obx(() {
                    if (controller.attendanceForTheMonth.value == null) {
                      return Container();
                    }
                    if (controller.hasAttendance(
                        controller.attendanceForTheMonth.value!.attendanceDetails,
                        controller.focusedDay.value) ==
                        "Present") {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FilledButton(onPressed: () {null;}, child: Text("Mark Present"), style: FilledButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.grey),),
                          FilledButton(onPressed: () {controller.markAbsent(context);}, child: Text("Mark Absent"), style: FilledButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.red),)
                        ],);
                    } else if (controller.hasAttendance(
                        controller.attendanceForTheMonth.value!.attendanceDetails,
                        controller.focusedDay.value) ==
                        "Absent") {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FilledButton(onPressed: () {
                            controller.markPresent(context);
                          }, child: Text("Mark Present"), style: FilledButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.green),),
                          FilledButton(onPressed: () {null;}, child: Text("Mark Absent"), style: FilledButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.grey),)
                        ],);
                    }
                    else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FilledButton(onPressed: () {
                            Get.to(() => SelfietakingscreenAttendance());
                          }, child: Text("Mark Present"), style: FilledButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.green),),
                          FilledButton(onPressed: () {null;}, child: Text("Mark Absent"), style: FilledButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.grey),)
                        ],);
                    }
                  })
                ],);
              })
            ],
          ),
        ),
      ),
    );
  }
}
