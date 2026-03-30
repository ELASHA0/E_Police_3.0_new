import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rocketsales_admin/Screens/Orders/OrdersHistoryBySalesman.dart';
import 'package:rocketsales_admin/Screens/SalesmanListScreen/SalesmanModel.dart';

import '../../TokenManager.dart';

class SalesmanListController extends GetxController {
  var salesmen = <SalesmanModel>[].obs;
  final isLoading = false.obs;
  RxInt page = 2.obs;
  RxBool isMoreCardsAvailable = false.obs;
  final searchString = ''.obs;
  final RxString selectedTag = "".obs;
  final RxString token = "".obs;
  final Rxn<SalesmanModel> admin = Rxn<SalesmanModel>();

  // Rx<Widget> targetScreen = OrdersHistoryBySalesman().obs;
  Rxn<Widget Function()> targetScreen = Rxn<Widget Function()>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAdmin();
    getSalesmen();
  }

  void getAdmin() async {
    token.value = (await TokenManager.getToken())!;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token.value);
    final companyId = decodedToken['companyId'];
    final branchId = decodedToken['branchId'];
    final supervisorId = decodedToken['id'];
    final adminName = decodedToken['chatusername'];
    admin.value = SalesmanModel(id: supervisorId, salesmanName: adminName, salesmanEmail: "", salesmanPhone: "", username: adminName, password: "", role: 4, companyId: companyId, branchId: branchId, supervisorId: supervisorId, createdAt: DateTime.now(), updatedAt: DateTime.now(), companyName: "", branchName: "branchName", supervisorName: "supervisorName");
  }

  void getSalesmen() async {
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
          '${dotenv.env['BASE_URL']}/api/api/salesman?&limit=20&search=$searchString');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("url to get salesman ========>>>>>> $url");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        final List<dynamic> dataList = jsonData['data'];
        final salesmenList =
        dataList.map((item) => SalesmanModel.fromJson(item)).toList();
        salesmen.assignAll(salesmenList);
        if (jsonData['page'] < jsonData['totalPages']) {
          isMoreCardsAvailable.value = true;
        } else {
          isMoreCardsAvailable.value = false;
        }
      } else {
        salesmen.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      salesmen.clear();
      // Get.snackbar("Exception", e.toString());
      print("errorr =======>>>>>> ${e.toString()}");
      Get.snackbar("Exception", "Couldn't get salesmen");
    } finally {
      isLoading.value = false;
    }
  }

  void getMoreSalesmenCards() async {
    print('fetching more');
    // if (isMoreCardsAvailable.value) {
    //   page.value++;
    // }
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/salesman?page=$page&limit=20&search=$searchString');
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
        final salesmenList =
        dataList.map((item) => SalesmanModel.fromJson(item)).toList();
        // page.value++;
        if (salesmenList.length < 1) {
          isMoreCardsAvailable.value = false;
          // page.value = 1;
        } else {
          page.value++;
        }
        salesmen.addAll(salesmenList);
        if (jsonData['page'] < jsonData['totalPages']) {
          isMoreCardsAvailable.value = true;
        } else {
          isMoreCardsAvailable.value = false;
        }
      } else {
        salesmen.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      salesmen.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get salesman history");
    }
  }
}