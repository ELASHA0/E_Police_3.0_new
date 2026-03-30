import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:rocketsales_admin/Screens/Attendance/SalesmanAttendanceList/TodayAttendance/TodayAttendanceModel.dart';

import '../../../../TokenManager.dart';
import '../../../../resources/my_colors.dart';

class TodayAttendanceController extends GetxController {
  final RxList<TodayAttendance> todayAttendance = <TodayAttendance>[].obs;
  final RxBool isLoading = true.obs;

  // final RxBool areProductsLoading = false.obs;
  final RxString error = ''.obs;
  final dateTimeFilter = ''.obs;
  final searchString = ''.obs;
  final RxString selectedTag = "".obs;
  final RxBool isLoadingInDetails = false.obs;

  RxInt page = 2.obs;
  RxBool isMoreCardsAvailable = false.obs;

  @override
  void onInit() {
    getAttendances();
    super.onInit();
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

  Future<void> getAttendances() async {
    isLoading.value = true;
    // isMoreCardsAvailable.value = false;
    page.value = 2;
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/attendence?&limit=10$dateTimeFilter&search=$searchString&status=$selectedTag');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        final List<dynamic> dataList = jsonData['data'];
        print("todayAttendanceList ========>>>>>> $dataList");
        final todayAttendanceList = dataList.map((item) => TodayAttendance.fromJson(item)).toList();
        todayAttendance.assignAll(todayAttendanceList);
        if (jsonData['page'] < jsonData['totalPages']) {
          isMoreCardsAvailable.value = true;
        } else {
          isMoreCardsAvailable.value = false;
        }
      } else {
        todayAttendance.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      todayAttendance.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get Attendances");
    } finally {
      isLoading.value = false;
    }
  }

  void getMoreAttendanceCards() async {
    print('fetching more');
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/attendence?page=$page&limit=10$dateTimeFilter&search=$searchString&status=$selectedTag');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // print(jsonData);
        final List<dynamic> dataList = jsonData['data'];
        // final List<dynamic> dataList = jsonData;
        final todayAttendanceList = dataList.map((item) => TodayAttendance.fromJson(item)).toList();
        // page.value++;
        if (todayAttendanceList.length < 1) {
          isMoreCardsAvailable.value = false;
          // page.value = 1;
        } else {
          page.value++;
        }
        todayAttendance.addAll(todayAttendanceList);
      } else {
        todayAttendance.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      todayAttendance.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get Attendances");
    }
  }
}
