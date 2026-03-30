import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../TokenManager.dart';
import '../../resources/my_colors.dart';
import '../SalesmanListScreen/SalesmanListController.dart';

class UserManagementController extends GetxController {
  final salesmanId = ''.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final SalesmanListController controller = Get.put(SalesmanListController());

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> uploadUser(BuildContext context) async {
    print("salesmanId =========>>> ${salesmanId.value}");
    showLoading(context);
    try {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/salesman');

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
        body: jsonEncode(<String, dynamic>{
          'companyId': companyId,
          'branchId': branchId,
          'supervisorId': supervisorId,
          "password": passwordController.text,
          "salesmanEmail": emailController.text,
          "salesmanName": nameController.text,
          "salesmanPhone": phoneController.text,
          "username": userNameController.text,
        }),
      );

      if (response.statusCode == 201) {
        passwordController.text = "";
        emailController.text = "";
        nameController.text = "";
        phoneController.text = "";
        userNameController.text = "";
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        controller.getSalesmen();
        Get.snackbar("Success", "user info submitted");
      } else {
        Navigator.of(context).pop();
        print("❌ user submission Failed: ${response.body}");
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      // isLoading.value = false;
      Navigator.of(context).pop();
      print("⚠️ Exception in posting user: $e");
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

  Future<void> updateUser(BuildContext context) async {
    showLoading(context);
    try {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/salesman/${salesmanId.value}');
      final token = await TokenManager.getToken();

      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "password": passwordController.text,
          "salesmanEmail": emailController.text,
          "salesmanName": nameController.text,
          "salesmanPhone": phoneController.text,
          "username": userNameController.text,
        }),
      );

      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        passwordController.text = "";
        emailController.text = "";
        nameController.text = "";
        phoneController.text = "";
        userNameController.text = "";
        Navigator.of(context).pop();
        controller.getSalesmen();
        Get.snackbar("Success", "user updated successfully");
      } else {
        Get.snackbar("Error", response.body);
        print("Error =======>>>>> ${response.body}");
      }
    } catch (e) {
      Navigator.of(context).pop();
      Get.snackbar("Exception", e.toString());
    }
  }

  void deleteConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: MyColor.dashbord,
        title: Text("Confirm Deletion"),
        content: Text("All data associated with this user will be permanently deleted."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => deleteUser(context),
            child: Text("Delete user", style: TextStyle(color: Colors.red),),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> deleteUser(BuildContext context) async {
    showLoading(context);
    try {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/salesman/${salesmanId.value}');
      final token = await TokenManager.getToken();

      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        passwordController.text = "";
        emailController.text = "";
        nameController.text = "";
        phoneController.text = "";
        userNameController.text = "";
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        controller.getSalesmen();
        Get.snackbar("Success", "user deleted successfully");
      } else {
        Get.snackbar("Error", response.body);
        print("Error =======>>>>> ${response.body}");
      }
    } catch (e) {
      Navigator.of(context).pop();
      Get.snackbar("Exception", e.toString());
    }
  }
}