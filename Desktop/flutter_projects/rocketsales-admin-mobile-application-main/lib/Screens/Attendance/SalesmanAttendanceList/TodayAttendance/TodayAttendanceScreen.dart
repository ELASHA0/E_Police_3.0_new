import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsales_admin/Screens/Attendance/SalesmanAttendanceList/TodayAttendance/TodayAttendanceController.dart';

import '../../../../resources/my_colors.dart';
import 'TodayAttendanceCard.dart';
import 'TodayAttendanceFiltrationSystem.dart';

class TodayAttendanceScreen extends StatefulWidget {
  const TodayAttendanceScreen({super.key});

  @override
  State<TodayAttendanceScreen> createState() => _TodayAttendanceScreenState();
}

class _TodayAttendanceScreenState extends State<TodayAttendanceScreen> {
  final TodayAttendanceController controller = Get.find();

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print('reached end');
        controller.isMoreCardsAvailable.value = true;
        controller.getMoreAttendanceCards();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
            child: TodayAttendanceFiltrationSystem(),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(
                      color: MyColor.dashbord,
                    ));
              } else if (controller.todayAttendance.isEmpty) {
                return const Center(child: Text("No Salesmen found."));
              } else {
                return RefreshIndicator(
                  backgroundColor: Colors.white,
                  color: MyColor.dashbord,
                  onRefresh: () async {
                    controller.getAttendances();
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    itemCount: controller.todayAttendance.length + 1,
                    itemBuilder: (context, index) {
                      if (index < controller.todayAttendance.length) {
                        final item = controller.todayAttendance[index];
                        return TodayAttendanceCard(salesman: item);
                      } else {
                        if (controller.isMoreCardsAvailable.value) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: MyColor.dashbord,
                              ),
                            ),
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Center(child: Text('')),
                          );
                        }
                      }
                    },
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
