import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:rocketsales_admin/Screens/SalesmanListScreen/SalesmanListScreen.dart';

import '../../SalesmanListScreen/SalesmanListController.dart';
import '../../SalesmanListScreen/SalesmanModel.dart';

class selectsalesmen extends StatefulWidget {
  final Function(SalesmanModel)? onSalesmanSelected;
  const selectsalesmen({super.key, this.onSalesmanSelected});

  @override
  State<selectsalesmen> createState() => _selectsalesmenState();
}

class _selectsalesmenState extends State<selectsalesmen> {
  final SalesmanListController salesmanController = Get.find<SalesmanListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text("Select Salesmen "),
    backgroundColor: const Color(0xFF1E4DB7),
    foregroundColor: Colors.white,
    ),
      body:
      SalesmanListScreen(
      onSalesmanSelected: widget.onSalesmanSelected,
      ),
    );
  }
}
