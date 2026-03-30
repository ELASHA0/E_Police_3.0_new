import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../TokenManager.dart';
import '../../../resources/my_colors.dart';

class ExpenseCardController extends GetxController {

  @override
  void onInit() {
    super.onInit();
  }

  Future<bool> toggleExpenseStatus(
      String expenseId,
      String newStatus,
      BuildContext context,
      ) async {
    showLoading(context);
    final url = '${dotenv.env['BASE_URL']}/api/api/expence/status/$expenseId';

    final id = await TokenManager.getSupervisorId();
    if (id == null) {
      final err = "User ID not found from token";
      showSnackbar(err);
      throw err; // for catchError
    }

    final token = await TokenManager.getToken();
    if (token == null) {
      final err = "Auth token not found";
      showSnackbar(err);
      throw err;
    }

    print("new status ========>>>>>$newStatus");

    try {
      final response = await GetConnect().put(
        url,
        {'status': newStatus},
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        showSnackbar("Expense marked as $newStatus");

        return true;                           // 🔥 will go to `.then((value){})`
      } else {
        final err =
            "Failed to update status: ${response.statusText}";
        showSnackbar(err);
        throw err;                              // 🔥 will go to `.catchError((err){})`
      }
    } catch (e) {
      final err = "Error updating status: $e";
      print(err);
      showSnackbar(err);
      throw err;                                // 🔥 sends to catchError
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

  void showSnackbar(String message) {
    Get.snackbar('Message', message);
  }
}