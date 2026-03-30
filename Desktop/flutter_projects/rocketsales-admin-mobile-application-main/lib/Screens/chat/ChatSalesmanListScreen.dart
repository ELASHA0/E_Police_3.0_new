import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsales_admin/Screens/SalesmanListScreen/SalesmanListScreen.dart';

import '../../resources/my_colors.dart';
import '../SalesmanListScreen/SalesmanCard.dart';
import '../SalesmanListScreen/SalesmanListController.dart';
import 'chat_screen_sales_man.dart';

class ChatSalesmanListScreen extends StatelessWidget {
  ChatSalesmanListScreen({super.key});

  final SalesmanListController controller = Get.put(SalesmanListController());

  @override
  Widget build(BuildContext context) {
    controller.targetScreen.value = () => ChatScreen();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.dashbord,
        title: const Text("Chat"),
        foregroundColor: Colors.white,
      ),
      body: const SalesmanListScreen(),
    );
  }
}
