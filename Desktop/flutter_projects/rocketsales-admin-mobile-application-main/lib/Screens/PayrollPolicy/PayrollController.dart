import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../TokenManager.dart';
// import 'PayrollModelOfWarkingDay.dart';
import 'PayrollTrackModel.dart';

class PayrollController extends GetxController {
  var loading = false.obs;
  var loadingMore = false.obs;

  var errorMessage = "".obs;
  var salesmen = <SalesmanData>[].obs;
  // Rx<PayrollWorkingDayModel?> payrollDataWorkingDay = Rx<PayrollWorkingDayModel?>(null);

  int page = 1;
  int limit = 5;
  String search = "";

  bool hasMoreData = true;

  final String baseUrl = "${dotenv.env['BASE_URL']}/api/api/with-payroll-track";

  Future<void> fetchSalesmen({bool isLoadMore = false}) async {
    try {
      if (isLoadMore) {
        loadingMore.value = true;
      } else {
        loading.value = true;
        salesmen.clear();
        page = 1;
        hasMoreData = true;
      }

      final token = await TokenManager.getToken();
      final url = "$baseUrl?page=$page&limit=$limit&search=$search";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final data = PayrollTrackModel.fromJson(jsonData);

        if (isLoadMore) {
          if (data.data!.isEmpty) {
            hasMoreData = false;
          } else {
            salesmen.addAll(data.data!);
          }
        } else {
          salesmen.value = data.data ?? [];
        }
      } else {
        errorMessage.value = "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      loading.value = false;
      loadingMore.value = false;
    }
  }

  // Future<void> getPayrollOfWorkingDay(String id, String branchId) async {
  //   try {
  //     loading.value = true;
  //
  //     final token = await TokenManager.getToken();
  //     // final id = await TokenManager.getSupervisorId();
  //     // final branchId = await TokenManager.getBranchId();
  //
  //     final now = DateTime.now();
  //     final month = now.month;
  //     final year = now.year;
  //
  //     final url = Uri.parse(
  //         '${dotenv.env['BASE_URL']}/api/api/payrollTrackTillNow'
  //             '?branchId=$branchId&employeeType=salesman'
  //             '&employeeId=$id&month=$month&year=$year'
  //     );
  //
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final decoded = json.decode(response.body);
  //       payrollDataWorkingDay.value = PayrollWorkingDayModel.fromJson(decoded);
  //     } else {
  //       payrollDataWorkingDay.value = null;
  //     }
  //
  //   } catch (e) {
  //     payrollDataWorkingDay.value = null;
  //     print("Payroll API Error: $e");
  //   } finally {
  //     loading.value = false;
  //   }
  // }

  /// Search refresh
  void setSearch(String value) {
    search = value;
    fetchSalesmen();
  }

  /// Increase page number on scroll
  void loadMore() {
    if (!hasMoreData || loadingMore.value) return;
    page++;
    fetchSalesmen(isLoadMore: true);
  }

  @override
  void onInit() {
    super.onInit();
    fetchSalesmen();
  }
}


// import 'dart:convert';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../../TokenManager.dart';
// import 'PayrollTrackModel.dart';
//
//
// class PayrollController extends GetxController {
//   // Observables
//   var loading = false.obs;
//   var errorMessage = "".obs;
//   var salesmen = <SalesmanData>[].obs;
//
//   // Pagination & search
//   int page = 1;
//   int limit = 2;
//   String search = "";
//
//   // API URL
//   final String baseUrl = "${dotenv.env['BASE_URL']}/api/api/with-payroll-track";
//
//   // Fetch data
//   Future<void> fetchSalesmen() async {
//     try {
//       loading.value = true;
//       errorMessage.value = "";
//       final token = await TokenManager.getToken();
//
//
//       final url =
//           "$baseUrl?page=$page&limit=$limit&search=$search"; // build URL
//
//       final response = await http.get(
//           Uri.parse(url),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//
//         final data = PayrollTrackModel.fromJson(jsonData);
//         salesmen.value = data.data ?? [];
//       } else {
//         errorMessage.value = "Server Error: ${response.statusCode}";
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//
//     } finally {
//       loading.value = false;
//     }
//   }
//
//   // Set Search text and reload
//   void setSearch(String value) {
//     search = value;
//     page = 1;
//     fetchSalesmen();
//   }
//
//   // Move to next page
//   void nextPage() {
//     page++;
//     fetchSalesmen();
//   }
//
//   // Move to previous page
//   void previousPage() {
//     if (page > 1) {
//       page--;
//       fetchSalesmen();
//     }
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchSalesmen();
//   }
// }
