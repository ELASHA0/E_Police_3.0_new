import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rocketsales_admin/Screens/Attendance/SalesmanAttendanceList/ManualAttendance/ManualAttendanceController.dart';
import 'package:rocketsales_admin/Screens/Workpad/Reminders/ReminderModelDate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../../resources/my_colors.dart';
import '../../../AdminLocationController.dart';
import '../../../TokenManager.dart';

class RemindersController extends GetxController {

  // final addressString = 'Loading...'.obs;
  RxBool isGettingLocation = false.obs;
  RxBool isLoading = false.obs;
  final RxList<RenderOfMonth> renderForTheMonth = <RenderOfMonth>[].obs;
  var focusedDay = DateTime.now().obs;
  var reminderDateTime = DateTime.now().obs;
  final RxList<ReminderModelDate> reminders = <ReminderModelDate>[].obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    focusedDay.value = DateTime.now();
    getRemindersOnDate(DateFormat("yyyy-MM-dd").format(DateTime.now())).then((_) {
      titleController.clear();
      bodyController.clear();
      getRenderOfMonth(DateFormat("yyyy-MM").format(reminderDateTime.value));
    });
  }

  Future<void> getRemindersOnDate(String date) async {
    isLoading.value = true;
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/reminder-date?date=$date');
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
        final List<dynamic> dataList = jsonData['reminders'];
        print("remindersList ========>>>>>> $dataList");
        final remindersList =
        dataList.map((item) => ReminderModelDate.fromJson(item)).toList();
        reminders.assignAll(remindersList);
        isLoading.value = false;
      } else {
        isLoading.value = false;
        Get.snackbar("Error connect",
            "Failed to Connect (Code: ${response.statusCode})");
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Exception", "Couldn't get reminders");
    } finally {
      isLoading.value = false;
    }
  }

  bool isDateHasReminder(DateTime day) {
    return renderForTheMonth.any((item) {
      final date = item.date;
      return date.year == day.year && date.month == day.month && date.day == day.day;
    });
  }

  int getCountForDate(DateTime day) {
    final match = renderForTheMonth.firstWhere(
          (item) {
        final date = item.date;
        return date.year == day.year &&
            date.month == day.month &&
            date.day == day.day;
      },
      orElse: () => RenderOfMonth(date: day, remindersCount: 0),
    );
    return match.remindersCount;
  }


  Future<void> getRenderOfMonth(String month) async {
    isLoading.value = true;
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/reminder-dates?month=$month');
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
        final List<dynamic> dataList = jsonData['data'];
        print("render of month ========>>>>>> $dataList");
        final renderofDateList =
        dataList.map((item) => RenderOfMonth.fromJson(item)).toList();
        print("json data of month render ========>>> $jsonData");
        renderForTheMonth.assignAll(renderofDateList);
        isLoading.value = false;
      } else {
        isLoading.value = false;
        Get.snackbar("Error connect",
            "Failed to Connect (Code: ${response.statusCode})");
      }
    } catch (e) {
      isLoading.value = false;
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't connect");
    } finally {
      isLoading.value = false;
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
                Text("Uploading..."),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> uploadReminder(BuildContext context) async {
    showLoading(context);
    try {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/reminder');

      final token = await TokenManager.getToken();

      final response = await http.post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(<String, dynamic>{
            "title": titleController.text,
            "description": bodyController.text,
            "reminderAt": reminderDateTime.value.toIso8601String(),
          })
      );

      if (response.statusCode == 201) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        getRemindersOnDate(DateFormat("yyyy-MM-dd").format(reminderDateTime.value)).then((_) {
          titleController.clear();
          bodyController.clear();
          getRenderOfMonth(DateFormat("yyyy-MM").format(reminderDateTime.value));
        });
      } else {
        Navigator.of(context).pop();
        print("❌ Reminder submission Failed: ${response.body}");
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      // isLoading.value = false;
      Navigator.of(context).pop();
      print("⚠️ Exception in posting Reminder: $e");
      Get.snackbar("Exception", e.toString());
    }
  }

  Future<void> updateReminder(BuildContext context, String reminderId) async {
    showLoading(context);
    try {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/reminder/$reminderId');
      final token = await TokenManager.getToken();

      final response = await http.put(
          uri,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            "title": titleController.text,
            "description": bodyController.text,
            "reminderAt": reminderDateTime.value.toIso8601String(),
          })
      );

      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        getRemindersOnDate(DateFormat("yyyy-MM-dd").format(reminderDateTime.value)).then((_) {
          titleController.clear();
          bodyController.clear();
          getRenderOfMonth(DateFormat("yyyy-MM").format(reminderDateTime.value));
        });
      } else {
        Get.snackbar("Error", response.body);
        print("Error =======>>>>> ${response.body}");
      }
    } catch (e) {
      Navigator.of(context).pop();
      Get.snackbar("Exception", e.toString());
    }
  }

  Future<void> deleteReminder(BuildContext context, String reminderId) async {
    showLoading(context);
    try {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/reminder/$reminderId');

      final token = await TokenManager.getToken();

      final response = await http.delete(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        getRemindersOnDate(DateFormat("yyyy-MM-dd").format(reminderDateTime.value)).then((_) {
          titleController.clear();
          bodyController.clear();
          getRenderOfMonth(DateFormat("yyyy-MM").format(reminderDateTime.value));
        });
      } else {
        Navigator.of(context).pop();
        print("❌ Reminder deletion Failed: ${response.body}");
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      // isLoading.value = false;
      Navigator.of(context).pop();
      print("⚠️ Exception in deleting Reminder: $e");
      Get.snackbar("Exception", e.toString());
    }
  }
}
