import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../TokenManager.dart';
import '../../../../resources/my_colors.dart';
import 'ManualAttendanceModel.dart';

class ManualAttendanceController extends GetxController {
  final RxList<ManualAttendance> manualAttendance = <ManualAttendance>[].obs;
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
    getManualAttendances();
    super.onInit();
  }

  Future<void> getManualAttendances() async {
    isLoading.value = true;
    isMoreCardsAvailable.value = false;
    page.value = 2;
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/manual/attendence?&limit=10&search=$searchString');
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
        final List<dynamic> dataList = jsonData['absentSalesmen'];
        print("manualAttendanceList ========>>>>>> $dataList");
        final manualAttendanceList = dataList.map((item) => ManualAttendance.fromJson(item)).toList();
        manualAttendance.assignAll(manualAttendanceList);
      } else {
        manualAttendance.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      manualAttendance.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get Attendances");
    } finally {
      isLoading.value = false;
    }
  }

  void getMoreManualAttendanceCards() async {
    print('fetching more');
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/manual/attendence?page=$page&limit=10&search=$searchString');
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
        final List<dynamic> dataList = jsonData['absentSalesmen'];
        // final List<dynamic> dataList = jsonData;
        final manualAttendanceList = dataList.map((item) => ManualAttendance.fromJson(item)).toList();
        // page.value++;
        if (manualAttendanceList.length < 1) {
          isMoreCardsAvailable.value = false;
          // page.value = 1;
        } else {
          page.value++;
        }
        manualAttendance.addAll(manualAttendanceList);
      } else {
        manualAttendance.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      manualAttendance.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get Attendances");
    }
  }
}
