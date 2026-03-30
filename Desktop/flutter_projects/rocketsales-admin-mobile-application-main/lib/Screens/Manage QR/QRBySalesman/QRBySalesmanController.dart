import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../TokenManager.dart';
import 'QRBySalesmanModel.dart';

class QRBySalesmanController extends GetxController {
  final RxList<QRBySalesmanModel> qrsBySalesman = <QRBySalesmanModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final dateTimeFilter = ''.obs;
  final searchString = ''.obs;
  final salesmanId = ''.obs;
  final RxString selectedTag = "".obs;

  RxInt page = 2.obs;
  RxBool isMoreCardsAvailable = false.obs;

  @override
  void onInit() {
    getQRBySalesman();
    super.onInit();
  }

  String formattedDate(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);
    return DateFormat('dd/MM/yy').format(dateTime);
  }

  String formattedTime(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);

    // Format to hh:mm a (12-hour format with AM/PM)
    return DateFormat('hh:mm a').format(dateTime);
  }

  void getQRBySalesman() async {
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
          '${dotenv.env['BASE_URL']}/api/api/scanqr/get?&limit=20$dateTimeFilter&search=$searchString&salesmanIds=$salesmanId');
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
        print("dataList ========>>>>>> $dataList");
        final qrList = dataList.map((item) => QRBySalesmanModel.fromJson(item)).toList();
        qrsBySalesman.assignAll(qrList);
        if (jsonData['pagination']['page'] < jsonData['pagination']['totalPages']) {
          isMoreCardsAvailable.value = true;
        } else {
          isMoreCardsAvailable.value = false;
        }
      } else {
        qrsBySalesman.clear();
        Get.snackbar("Error connect",
            "Couldn't get Question sets (Code: ${response.statusCode})");
      }
    } catch (e) {
      qrsBySalesman.clear();
      // Get.snackbar("Exception", e.toString());
      print("Error ======>>>> ${e.toString()}");
      Get.snackbar("Exception", "Couldn't get QRs");
    } finally {
      isLoading.value = false;
    }
  }

  void getMoreQRBySalesman() async {
    print('fetching more');
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/scanqr/get?page=$page&limit=10$dateTimeFilter&search=$searchString&salesmanIds=$salesmanId');
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
        final qrList = dataList.map((item) => QRBySalesmanModel.fromJson(item)).toList();
        // page.value++;
        if (qrList.length < 1) {
          isMoreCardsAvailable.value = false;
          // page.value = 1;
        } else {
          page.value++;
        }
        qrsBySalesman.addAll(qrList);
      } else {
        qrsBySalesman.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      qrsBySalesman.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get QRs");
    }
  }
}
