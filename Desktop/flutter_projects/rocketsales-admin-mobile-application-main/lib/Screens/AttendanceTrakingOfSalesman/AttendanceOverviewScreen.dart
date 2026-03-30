import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../../resources/my_colors.dart';
import 'AttendanceController.dart';

class Attendanceoverviewscreen extends StatefulWidget {
  final String salesmanId;

  const Attendanceoverviewscreen({
    super.key,
    required this.salesmanId,
  });

  @override
  State<Attendanceoverviewscreen> createState() =>
      _AttendanceoverviewscreenState();
}

class _AttendanceoverviewscreenState extends State<Attendanceoverviewscreen> {
  final AttendanceTrakController controller =
  Get.find<AttendanceTrakController>();

  @override
  void initState() {
    super.initState();
    controller.setDate(DateTime.now());
    controller.getAttendanceOverview(
      controller.selectedMonthYear.value,
      widget.salesmanId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: MyColor.dashbord,
        title: const Text(
          "Attendance Overview",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            /// ─────────────────────────────────────────────
            /// FIXED MONTH PICKER ROW - ALWAYS ON TOP
            /// ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final DateTime? picked = await showMonthYearPicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime.now(),
                        );

                        if (picked != null) {
                          controller.setDate(picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => Text(
                                controller.selectedMonthYear.value)),
                            const Icon(Icons.calendar_month),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColor.dashbord,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      controller.getAttendanceOverview(
                        controller.selectedMonthYear.value,
                        widget.salesmanId,
                      );
                    },
                    child:
                    const Text("Apply", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),

            /// ─────────────────────────────────────────────
            /// MAIN DATA LOADED USING OBX
            /// ─────────────────────────────────────────────
            Obx(() {
                final data = controller.attendanceData.value;

                if (controller.loading.value && data == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (data == null ||
                    data.data == null ||
                    data.data!.isEmpty) {
                  return const Center(child: Text("No Data Found"));
                }

                final item = data.data![0];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      profileCard(item),
                      const SizedBox(height: 15),
                      statsGrid(item),
                      const SizedBox(height: 5),
                      attendanceSummaryCard(item),
                      leaveBreakDownCard(item),
                    ],
                  ),
                );

            }),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  //                    WIDGETS
  // ==========================================================

  Widget profileCard(item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationCard(),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            child: Icon(Icons.person, size: 30),
          ),
          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.salesmanId?.salesmanName ?? "Unknown",
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.business,
                      size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    item.companyId?.companyName ?? "No company",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.home, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    item.branchId?.branchName ?? "No branch",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget statsGrid(item) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        statCard("Present", item.totalPresentDays.toString(),
            "Total Present", Colors.green),
        statCard("Leaves", item.totalLeavesTaken.toString(),
            "Total Leave", Colors.red),
        statCard("Late", item.totalLateIns.toString(),
            "Late Arrivals", Colors.orange),
        statCard("Half Days", item.totalHalfDays.toString(),
            "Half Day Count", Colors.blue),
      ],
    );
  }

  Widget statCard(String title, String value, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: boxDecorationCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget attendanceSummaryCard(item) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rowTitle("Attendance Summary"),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leaveCircle("Present Days",
                  item.totalPresentDays.toString(), Colors.green),
              leaveCircle("Absent Days",
                  item.totalLeavesTaken.toString(), Colors.red),
              leaveCircle("Half Days",
                  item.totalHalfDays.toString(), Colors.orange),
              leaveCircle("Late Arrivals",
                  item.totalLateIns.toString(), Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget leaveBreakDownCard(item) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rowTitle("Leave Breakdown"),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leaveCircle("Casual", item.casualLeave.toString(), Colors.purple),
              leaveCircle("Earned", item.earnedLeave.toString(), Colors.green),
              leaveCircle("Sick", item.sickLeave.toString(), Colors.blue),
              leaveCircle("LWP", item.leaveWithoutPay.toString(), Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget leaveCircle(String title, String value, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 23,
          backgroundColor: color.withOpacity(0.1),
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget rowTitle(String title) {
    return Row(
      children: [
        const Icon(Icons.calendar_today, color: Color(0xFF1E4DB7)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  BoxDecoration boxDecorationCard() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          offset: const Offset(0, 2),
          blurRadius: 4,
        ),
      ],
    );
  }
}
