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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../../resources/my_colors.dart';
import '../../../AdminLocationController.dart';
import '../../../TokenManager.dart';
import '../SalesmanAttendanceList/TodayAttendance/TodayAttendanceModel.dart';
import 'AttendanceModel.dart';

class NewAttendanceController extends GetxController {

  // final addressString = 'Loading...'.obs;
  RxBool isGettingLocation = false.obs;
  RxBool isLoading = false.obs;
  var attendanceForTheMonth = Rxn<Attendance>();
  RxnBool isAttendanceMarkedToday = RxnBool();
  var salesManSelfie = Rxn<File?>();

  var bytes = Rxn<Uint8List>();
  var focusedDay = DateTime.now().obs;

  Rxn<DateTime> checkInDateTime = Rxn<DateTime>();
  Rxn<DateTime> checkOutDateTime = Rxn<DateTime>();

  final checkInAddressString = 'N/A'.obs;
  final checkOutAddressString = 'N/A'.obs;


  // final Rx<TodayAttendance> salesman;
  final RxString? salesmanId;
  final RxString salesmanName = "".obs;
  final RxString attendanceDetailId = "".obs;
  final RxString? salesmanSelfieBase64;

  NewAttendanceController({String? salesmanId, String? salesmanSelfieBase64}) : salesmanId = salesmanId?.obs, salesmanSelfieBase64 = salesmanSelfieBase64?.obs;

  // final RxList<Attendance> orders = <A>[].obs;

  AdminLocationController controller = AdminLocationController();
  ManualAttendanceController manualAttendanceController = ManualAttendanceController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAttendanceOfMonth(DateFormat("yyyy-MM").format(DateTime.now()))
        .then((_) {
      final attendance = attendanceForTheMonth.value;


      if (attendance == null) {
        isAttendanceMarkedToday.value = false;
      } else {
        checkInfoOfDay(attendance.attendanceDetails, DateTime.now());
        if (hasAttendance(attendance.attendanceDetails, DateTime.now()) ==
            "noData") {
          isAttendanceMarkedToday.value = false;
        } else if (hasAttendance(
                    attendance.attendanceDetails, DateTime.now()) ==
                "Present" ||
            hasAttendance(attendance.attendanceDetails, DateTime.now()) ==
                "Absent") {
          isAttendanceMarkedToday.value = true;
        }
      }

      if (salesmanSelfieBase64?.value.isNotEmpty ?? false) {
        bytes.value = base64Decode(salesmanSelfieBase64!.value);
      } else {
        bytes.value = null;
      }
    });

    focusedDay.value = DateTime.now();
  }


  Future<String> getAddress(double latitudeArg, double longitudeArg) async {
    isGettingLocation.value = true;
    print("getting address.............");
    if(latitudeArg == 0 && longitudeArg == 0) {
      return "N/A";
    }
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          latitudeArg, longitudeArg);
      Placemark place = placemarks[0];
      return "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";
      // print(placemarks);
    } catch (e) {
      isGettingLocation.value = false;
      Get.snackbar("Location Error", e.toString());
      return "N/A";
    } finally {
      // ✅ Always reset to false, even if error
      isGettingLocation.value = false;
    }
  }

  Future<void> getAttendanceOfMonth(String month) async {
    isLoading.value = true;
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/attendence-by-id?month=$month&salesmanId=${salesmanId!.value}');
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
        print("json data of attendance ========>>> $jsonData");
        attendanceForTheMonth.value = Attendance.fromJson(jsonData);
        print("is present today =====>>>> ${isAttendanceMarkedToday.value}");
        print(
            "attendance data from model after modeling =======>>>> ${attendanceForTheMonth.value!.presentCount}");
        // final List<dynamic> dataList = jsonData['data'];
        // print("attendanceData ========>>>>>> $dataList");
        // final orderList =
        //     dataList.map((item) => Attendance.fromJson(item)).toList();
        // orders.assignAll(orderList);
        isLoading.value = false;
      } else {
        isLoading.value = false;
        Get.snackbar("Error connect",
            "Failed to Connect (Code: ${response.statusCode})");
      }
    } catch (e) {
      isLoading.value = false;
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get attendance");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkInfoOfDay(List<AttendanceDetail> details, DateTime day) async {
    isLoading.value = true;

    // Reset first
    checkInDateTime.value = null;
    checkOutDateTime.value = null;
    checkInAddressString.value = "N/A";
    checkOutAddressString.value = "N/A";

    for (var detail in details) {
      if (detail.checkInTime != null &&
          detail.checkInTime!.year == day.year &&
          detail.checkInTime!.month == day.month &&
          detail.checkInTime!.day == day.day) {
        attendanceDetailId.value = detail.id;
        checkInDateTime.value = detail.checkInTime!;
        checkInAddressString.value = await getAddress(detail.startLat, detail.startLong);
      }

      if (detail.checkOutTime != null &&
          detail.checkOutTime!.year == day.year &&
          detail.checkOutTime!.month == day.month &&
          detail.checkOutTime!.day == day.day) {

        checkOutDateTime.value = detail.checkOutTime!;
        checkOutAddressString.value = await getAddress(detail.endLat, detail.endLong);
      }

      // ✅ If both found, stop looping early
      if (checkInDateTime.value != null && checkOutDateTime.value != null) {
        break;
      }
    }

    isLoading.value = false;
  }



  String hasAttendance(List<AttendanceDetail> attendanceDetails, DateTime day) {
    if (attendanceDetails.isEmpty) {
      return "noData";
    }

    // Look for the first matching record
    final match = attendanceDetails.firstWhere(
      (detail) =>
          detail.checkInTime != null &&
          detail.checkInTime!.year == day.year &&
          detail.checkInTime!.month == day.month &&
          detail.checkInTime!.day == day.day,
      orElse: () => AttendanceDetail(
        status: "noData",
        checkInTime: null,
        startLat: 0,
        startLong: 0,
        salesmanName: "",
        checkOutTime: null,
        endLat: 0,
        endLong: 0, id: '',
      ),
    );

    return match.status;
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

  Future<void> markPresent(BuildContext context) async {
    showLoading(context);
    final url = '${dotenv.env['BASE_URL']}/api/api/attendence/${attendanceDetailId.value}';
    final token = await TokenManager.getToken();

    if (token == null) {
      Get.snackbar("Error", "User token not found");
      return;
    }
    try {
      final response = await GetConnect().put(
        url,
        {
          'attendenceStatus': "Present",
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Debug: Print response status and body
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print("Attendance Submitted Successfully: ${response.body}");
        getAttendanceOfMonth(DateFormat("yyyy-MM").format(DateTime.now()))
            .then((_) {
          final attendance = attendanceForTheMonth.value;

          if (attendance == null) {
            isAttendanceMarkedToday.value = false;
          } else {
            if (hasAttendance(attendance.attendanceDetails, DateTime.now()) ==
                "noData") {
              isAttendanceMarkedToday.value = false;
            } else if (hasAttendance(
                attendance.attendanceDetails, DateTime.now()) ==
                "Present" ||
                hasAttendance(attendance.attendanceDetails, DateTime.now()) ==
                    "Absent") {
              isAttendanceMarkedToday.value = true;
            }
          }
        });

        focusedDay.value = DateTime.now();
        Navigator.pop(context);
        Get.snackbar('Success', 'Attendance submitted successfully.');
      } else {
        Navigator.pop(context);
        Get.snackbar(
            "Error", "Failed to update status: ${response.statusText}");
      }
    } catch (e) {
      Navigator.pop(context);
      Get.snackbar("Error", "Failed to update status: $e");
    }
  }

  Future<void> markAbsent(BuildContext context) async {
    showLoading(context);
    final url = '${dotenv.env['BASE_URL']}/api/api/attendence/${attendanceDetailId.value}';
    final token = await TokenManager.getToken();

    if (token == null) {
      Get.snackbar("Error", "User token not found");
      return;
    }
    try {
      final response = await GetConnect().put(
        url,
        {
          'attendenceStatus': "Absent",
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Debug: Print response status and body
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print("Attendance Submitted Successfully: ${response.body}");
        getAttendanceOfMonth(DateFormat("yyyy-MM").format(DateTime.now()))
            .then((_) {
          final attendance = attendanceForTheMonth.value;

          if (attendance == null) {
            isAttendanceMarkedToday.value = false;
          } else {
            if (hasAttendance(attendance.attendanceDetails, DateTime.now()) ==
                "noData") {
              isAttendanceMarkedToday.value = false;
            } else if (hasAttendance(
                attendance.attendanceDetails, DateTime.now()) ==
                "Present" ||
                hasAttendance(attendance.attendanceDetails, DateTime.now()) ==
                    "Absent") {
              isAttendanceMarkedToday.value = true;
            }
          }
        });

        focusedDay.value = DateTime.now();
        Navigator.pop(context);
        Get.snackbar('Success', 'Attendance submitted successfully.');
      } else {
        Navigator.pop(context);
        Get.snackbar(
            "Error", "Failed to update status: ${response.statusText}");
      }
    } catch (e) {
      Navigator.pop(context);
      Get.snackbar("Error", "Failed to update status: $e");
    }
  }

  Future<void> sendAttendanceData(XFile? image, BuildContext context) async {
    showLoading(context);
    String? token = await TokenManager.getToken();
    if (token == null || token.isEmpty) {
      print('No token found!');
      Get.snackbar('Error', 'No token found. Please login again.');
      return;
    }

    try {
      final adminLocation = await controller.determinePosition();
      Map<String, dynamic> tokenData = JwtDecoder.decode(token);

      String companyId = tokenData['companyId'] ?? '';
      String branchId = tokenData['branchId'] ?? '';
      String supervisorId = tokenData['id'] ?? '';
      isAttendanceMarkedToday.value = null;
      print("Processing Attendance Submission...");

      final bytes = await image!.readAsBytes();
      final base64Image = base64Encode(bytes);


      if (salesmanId!.value.isEmpty ||
          companyId.isEmpty ||
          branchId.isEmpty ||
          supervisorId.isEmpty) {
        Get.snackbar(
          'Error',
          'Token is missing required fields. Please login again.',
        );
        return;
      }

      String attendanceStatus = "Present";

      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/attendence');

      print("admin token: $token");

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'salesmanId': salesmanId!.value,
          'companyId': companyId,
          'branchId': branchId,
          'supervisorId': supervisorId,
          'attendenceStatus': attendanceStatus,
          'startLat': adminLocation.latitude.toDouble(),
          'startLong': adminLocation.longitude.toDouble(),
          'profileImgUrl': base64Image,
        }),
      );

      if (response.statusCode == 201) {
        print("Attendance Submitted Successfully: ${response.body}");
        getAttendanceOfMonth(DateFormat("yyyy-MM").format(DateTime.now()))
            .then((_) {
          final attendance = attendanceForTheMonth.value;

          if (attendance == null) {
            isAttendanceMarkedToday.value = false;
          } else {
            if (hasAttendance(attendance.attendanceDetails, DateTime.now()) ==
                "noData") {
              isAttendanceMarkedToday.value = false;
            } else if (hasAttendance(
                        attendance.attendanceDetails, DateTime.now()) ==
                    "Present" ||
                hasAttendance(attendance.attendanceDetails, DateTime.now()) ==
                    "Absent") {
              isAttendanceMarkedToday.value = true;
            }
          }
        });
        manualAttendanceController.getManualAttendances();

        focusedDay.value = DateTime.now();
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Get.snackbar('Success', 'Attendance submitted successfully.');
      } else {
        // setState(() => _isProcessingAttendance = false);
        print("Error: ${response.body}");
        // print("Attendance Already Marked: $responseData");
        getAttendanceOfMonth(DateFormat("yyyy-MM").format(DateTime.now()))
            .then((_) {
          final attendance = attendanceForTheMonth.value;

          if (attendance == null) {
            isAttendanceMarkedToday.value = false;
          } else {
            if (hasAttendance(attendance.attendanceDetails, DateTime.now()) ==
                "noData") {
              isAttendanceMarkedToday.value = false;
            } else if (hasAttendance(
                        attendance.attendanceDetails, DateTime.now()) ==
                    "Present" ||
                hasAttendance(attendance.attendanceDetails, DateTime.now()) ==
                    "Absent") {
              isAttendanceMarkedToday.value = true;
            }
          }
        });
        print("Error: ${response.body}");
        Get.snackbar('Error', '${response.body}');
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      // setState(() => _isProcessingAttendance = false);
      print(' Error submitting attendance: $e');
      Get.snackbar("Error", e.toString());
    }
  }
}
