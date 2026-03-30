import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsales_admin/Screens/UserManagement/UserManagementController.dart';
import 'package:rocketsales_admin/resources/my_colors.dart';

import '../SalesmanListScreen/SalesmanListController.dart';
import '../SalesmanListScreen/SalesmanListScreen.dart';
import 'CreateEditUserScreen.dart';

class UserManagementScreen extends StatelessWidget {
  UserManagementScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final SalesmanListController salesmanListController = Get.find<SalesmanListController>();

    salesmanListController.targetScreen.value = () => CreateEditUserScreen();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(CreateEditUserScreen(), arguments: {
            'isEdit': false,
          });
        },
        icon: const Icon(Icons.person_add_alt_outlined),
        // Optional icon
        label: const Text('Create User'),
        // The text label
        backgroundColor: MyColor.dashbord,
        // Optional background color
        foregroundColor: Colors.white, // Optional text and icon color
      ),
      appBar: AppBar(
        title: const Text("User Management"),
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
      ),
      body: const SalesmanListScreen(),
    );
  }
}
