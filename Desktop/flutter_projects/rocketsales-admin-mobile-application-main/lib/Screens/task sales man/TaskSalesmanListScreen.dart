import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsales_admin/Screens/SalesmanListScreen/SalesmanListScreen.dart';

import '../../resources/my_colors.dart';
import '../SalesmanListScreen/SalesmanListController.dart';
import 'Task_Management_Sales_Man.dart';

class TaskSalesmanListScreen extends StatelessWidget {
  TaskSalesmanListScreen({super.key});

  final SalesmanListController controller = Get.put(SalesmanListController());

  @override
  Widget build(BuildContext context) {
    controller.targetScreen.value = () => TaskManagementSalesMan();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.dashbord,
        title: const Text("Task"),
        foregroundColor: Colors.white,
      ),
      body: const SalesmanListScreen(),
    );
  }
}
