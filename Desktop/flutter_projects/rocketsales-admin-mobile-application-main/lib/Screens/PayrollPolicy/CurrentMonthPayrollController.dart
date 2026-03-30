import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;

import '../../TokenManager.dart';
import 'MonthPayrollDetailModel.dart';
import 'PayrollModelOfWarkingDay.dart';

class CurrentMonthPayrollController extends GetxController{

  Rx<PayrollWorkingDayModel?> payrollDataWorkingDay = Rx<PayrollWorkingDayModel?>(null);
  var loading = false.obs;
  Rx<MonthPayrollDetailModel?> monthPayroll = Rx<MonthPayrollDetailModel?>(null);
  var loading1 = false.obs;
  var selectedMonthYear = "Month".obs;       // reactive value


  void setDate(DateTime date) {
    final formatted = "${date.year}-${date.month.toString().padLeft(2, '0')}";
    selectedMonthYear.value = formatted;
  }

  Future<void> getPayrollOfWorkingDay(String id, String branchId) async {
    try {
      loading.value = true;

      final token = await TokenManager.getToken();

      final now = DateTime.now();
      final month = now.month;
      final year = now.year;

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/payrollTrackTillNow'
              '?branchId=$branchId&employeeType=salesman'
              '&employeeId=$id&month=$month&year=$year'
      );

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        payrollDataWorkingDay.value = PayrollWorkingDayModel.fromJson(decoded);
      } else {
        payrollDataWorkingDay.value = null;
      }

    } catch (e) {
      payrollDataWorkingDay.value = null;
      print("Payroll API Error: $e");
    } finally {
      loading.value = false;
    }
  }

  Future<void> fetchSelectedMonthPayroll(String monthYear, String id) async {
    loading1.value = true;
    try {
      // final id = await TokenManager.getSupervisorId();
      final token = await TokenManager.getToken();

      final url = Uri.parse("${dotenv.env['BASE_URL']}/api/api/payrollTrack/$id?monthYear=$monthYear");

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        monthPayroll.value = MonthPayrollDetailModel.fromJson(jsonDecode(response.body));
        print("Payroll Month Api Data: ${monthPayroll.value?.data}");
      } else {
        monthPayroll.value = null;
      }
    } catch (e) {
      print("Payroll Month api Error: $e");
    } finally {
      loading1.value = false;
    }
  }


}