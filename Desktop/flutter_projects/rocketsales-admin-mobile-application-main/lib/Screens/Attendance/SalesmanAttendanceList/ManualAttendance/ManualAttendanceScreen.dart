import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../resources/my_colors.dart';
import '../../../SalesmanListScreen/SalesmanCard.dart';
import 'ManualAttendanceCard.dart';
import 'ManualAttendanceController.dart';
import 'ManualAttendanceFiltrationSystem.dart';

class ManualAttendanceScreen extends StatefulWidget {
  const ManualAttendanceScreen({super.key});

  @override
  State<ManualAttendanceScreen> createState() => _ManualAttendanceScreenState();
}

class _ManualAttendanceScreenState extends State<ManualAttendanceScreen> {
  final ManualAttendanceController controller = Get.find();

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print('reached end');
        controller.isMoreCardsAvailable.value = true;
        controller.getMoreManualAttendanceCards();
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
            child: ManualAttendanceFiltrationSystem(),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(
                      color: MyColor.dashbord,
                    ));
              } else if (controller.manualAttendance.isEmpty) {
                return const Center(child: Text("No Salesmen found."));
              } else {
                return RefreshIndicator(
                  backgroundColor: Colors.white,
                  color: MyColor.dashbord,
                  onRefresh: () async {
                    controller.getManualAttendances();
                  },
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: controller.manualAttendance.length + 1,
                    itemBuilder: (context, index) {
                      if (index < controller.manualAttendance.length) {
                        final item = controller.manualAttendance[index];
                        return ManualAttendanceCard(salesman: item);
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
