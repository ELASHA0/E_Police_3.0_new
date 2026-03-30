import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../TokenManager.dart';
import '../../../resources/my_colors.dart';
import '../../ManageShop/ShopModel.dart';
import '../saleTask_controller.dart';

class CreateEditTaskController extends GetxController {
  var taskControllers = <TextEditingController>[TextEditingController()].obs;

  final tillDate = DateTime.now().obs;

  TextEditingController addressController = TextEditingController();
  TextEditingController editTaskController = TextEditingController();

  final TaskController controller = Get.find<TaskController>();

  Rxn<Shop> selectedShop = Rxn<Shop>();

  void addTaskField() {
    taskControllers.add(TextEditingController());
  }

  void removeTaskField(int index) {
    if (taskControllers.length > 1) {
      taskControllers.removeAt(index);
    }
  }

  Future<void> uploadTask(BuildContext context) async {
    showLoading(context);
    try {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/task');

      final token = await TokenManager.getToken();

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      final companyId = decodedToken['companyId'];
      final branchId = decodedToken['branchId'];
      final supervisorId = decodedToken['id'];

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: selectedShop.value == null ?
        jsonEncode(<String, dynamic>{
          'companyId': companyId,
          'branchId': branchId,
          'supervisorId': supervisorId,
          "taskDescription":
          taskControllers.map((controller) => controller.text).toList(),
          "deadline": tillDate.value.toIso8601String(),
          "address": addressController.text,
          "assignedTo": [controller.salesmanId.value]
        })
        :
        jsonEncode(<String, dynamic>{
          'companyId': companyId,
          'branchId': branchId,
          'supervisorId': supervisorId,
          "taskDescription":
          taskControllers.map((controller) => controller.text).toList(),
          "deadline": tillDate.value.toIso8601String(),
          "address": addressController.text,
          "shopGeofenceId": selectedShop.value!.id,
          "assignedTo": [controller.salesmanId.value]
        }),
      );

      if (response.statusCode == 201) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        controller.getTasks();
        Get.delete<CreateEditTaskController>(force: true);
        Get.snackbar("Success", "Task info submitted");
      } else {
        Navigator.of(context).pop();
        print("❌ Task submission Failed: ${response.body}");
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      // isLoading.value = false;
      Navigator.of(context).pop();
      print("⚠️ Exception in posting task: $e");
      Get.snackbar("Exception", e.toString());
    }
  }

  void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: MyColor.dashbord),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> updateTask(BuildContext context, String taskId) async {
    if (editTaskController.text.trim().isEmpty) {
      Get.snackbar("Validation Error", "Task description cannot be empty");
      return;
    }

    // if (addressController.text.trim().isEmpty) {
    //   Get.snackbar("Validation Error", "Address cannot be empty");
    //   return;
    // }

    // if (selectedShop.value == null) {
    //   Get.snackbar("Validation Error", "Please select a geofence");
    //   return;
    // }
    showLoading(context);
    try {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/task/$taskId');
      final token = await TokenManager.getToken();

      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body:
        selectedShop.value == null ?
        jsonEncode({
          "taskDescription": editTaskController.text,
          "deadline": tillDate.value.toIso8601String(),
          "address": addressController.text,
        })
        :
        jsonEncode({
          "taskDescription": editTaskController.text,
          "deadline": tillDate.value.toIso8601String(),
          "address": addressController.text,
          "shopGeofenceId": selectedShop.value!.id,
        })
      );

      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        controller.getTasks();
        Get.delete<CreateEditTaskController>(force: true);
        Get.snackbar("Success", "Task updated successfully");
      } else {
        Get.snackbar("Error", response.body);
        print("Error =======>>>>> ${response.body}");
      }
    } catch (e) {
      Navigator.of(context).pop();
      Get.snackbar("Exception", e.toString());
    }
  }

  @override
  void onClose() {
    for (var c in taskControllers) {
      c.dispose();
    }
    addressController.dispose();
    super.onClose();
  }
}
