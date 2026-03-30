import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../TokenManager.dart';
import '../../../resources/my_colors.dart';
import '../Q&A Set/QRQuestionSetsHistoryScreen.dart';
import 'QRModel.dart';
import '../Q&A Set/QuestionSetModel.dart';

class QRController extends GetxController {
  final RxList<QRModel> qrs = <QRModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final dateTimeFilter = ''.obs;
  final searchString = ''.obs;
  final salesmanId = ''.obs;
  final RxString selectedTag = "".obs;
  final _formKey = GlobalKey<FormState>();
  final RxBool didntSelectQuestionSet = false.obs;
  final Rxn<QRModel> qrCode = Rxn<QRModel>();

  RxInt page = 2.obs;
  RxBool isMoreCardsAvailable = false.obs;

  Rxn<QuestionSetModel> selectedQuestionSet = Rxn<QuestionSetModel>();

  final TextEditingController boxName = TextEditingController();

  @override
  void onInit() {
    getQRs();
    // getAddress();
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

  Future<void> getQRs() async {
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
          '${dotenv.env['BASE_URL']}/api/api/get/qrcode?&limit=20$dateTimeFilter&search=$searchString');
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
        // print("dataList ========>>>>>> $dataList");
        final qrList = dataList.map((item) => QRModel.fromJson(item)).toList();
        qrs.assignAll(qrList);
        if (jsonData['pagination']['page'] < jsonData['pagination']['totalPages']) {
          isMoreCardsAvailable.value = true;
        } else {
          isMoreCardsAvailable.value = false;
        }
      } else {
        qrs.clear();
        Get.snackbar("Error connect",
            "Couldn't get QRs (Code: ${response.statusCode})");
        print("Error =======>>>>>>> ${response.body}");
      }
    } catch (e) {
      qrs.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get QRs");
      print("Error ======>>>>>>> ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }



  void getMoreQRCards() async {
    print('fetching more');
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/get/qrcode?page=$page&limit=10$dateTimeFilter&search=$searchString');
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
        final qrList = dataList.map((item) => QRModel.fromJson(item)).toList();
        // page.value++;
        if (qrList.length < 1) {
          isMoreCardsAvailable.value = false;
          // page.value = 1;
        } else {
          page.value++;
        }
        qrs.addAll(qrList);
      } else {
        qrs.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      qrs.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get QRs");
    }
  }

  Future<void> uploadQR(BuildContext context) async {
    showLoading(context);
    try {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/qrcode/generate');

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
          'boxNo': boxName.text,
          'questionSetId': selectedQuestionSet.value!.id
        }),
      );

      print("boxName =====>>>> ${boxName.text}");

      if (response.statusCode == 201) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        boxName.clear();
        selectedQuestionSet.value = null;
        didntSelectQuestionSet.value = false;
        getQRs();
        Get.snackbar("Success", "QR info submitted");
      } else {
        Navigator.of(context).pop();
        print("❌ QR submission Failed: ${response.body}");
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      // isLoading.value = false;
      Navigator.of(context).pop();
      print("⚠️ Exception in posting QR: $e");
      Get.snackbar("Exception", e.toString());
    }
  }

  Future<void> deleteQR(BuildContext context, String qrId) async {
    showLoading(context);
    try {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/qrcode/delete/$qrId');

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
        Navigator.of(context).pop();
        boxName.clear();
        selectedQuestionSet.value = null;
        didntSelectQuestionSet.value = false;
        getQRs();
        Get.snackbar("Success", "QR deleted");
      } else {
        Navigator.of(context).pop();
        print("❌ QR deletion Failed: ${response.body}");
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      // isLoading.value = false;
      Navigator.of(context).pop();
      print("⚠️ Exception in deleting QR: $e");
      Get.snackbar("Exception", e.toString());
    }
  }

  void createNewQR(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Enter Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey, // 👈 form key
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ✅ Box Name field with validator
                  TextFormField(
                    controller: boxName,
                    decoration: const InputDecoration(
                      labelText: "Box Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Box Name is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 7),

                  // ✅ Question Set button
                  Obx(() => Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            side: const BorderSide(color: Colors.black54),
                          ),
                          onPressed: () {
                            didntSelectQuestionSet.value = false;
                            Get.to(QRQuestionSetHistoryScreen(), arguments: {
                              "targetScreen": "selectQuestionSet"
                            });
                          },
                          icon: const Icon(
                            Icons.description_outlined,
                            color: Colors.black,
                          ),
                          label: Text(
                            selectedQuestionSet.value != null
                                ? selectedQuestionSet.value!.title
                                : "Select Question set",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      didntSelectQuestionSet.value ?
                      Text("Select Question set", style: TextStyle(color: Colors.red),)
                          : SizedBox()
                    ],
                  )
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                boxName.clear();
                didntSelectQuestionSet.value = false;
                selectedQuestionSet.value = null;
                Navigator.pop(context);
                },
              child: const Text(
                "Cancel",
                style: TextStyle(color: MyColor.dashbord),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: MyColor.dashbord,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (selectedQuestionSet.value == null) {
                    didntSelectQuestionSet.value = true;
                    return;
                  }
                  uploadQR(context);
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  void deleteQRdialog(BuildContext context, String qrId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Delete QR",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Are you sure you want to delete this QR?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: MyColor.dashbord),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: MyColor.dashbord,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                deleteQR(context, qrId);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
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
}
