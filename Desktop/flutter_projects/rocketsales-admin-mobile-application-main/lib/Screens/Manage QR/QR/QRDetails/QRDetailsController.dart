import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../TokenManager.dart';
import '../../../../resources/my_colors.dart';
import '../../Q&A Set/QRQuestionSetsHistoryScreen.dart';
import '../QRController.dart';
import '../QRModel.dart';

class QRDetailsController extends GetxController {
  RxBool isGettingLocation = false.obs;
  final addressString = ''.obs;
  final _formKey = GlobalKey<FormState>();

  final QRController controller = Get.find<QRController>();
  final TextEditingController boxName = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAddress();
    print(controller.qrCode.value!.lat);
  }



  void getAddress() async {
    isGettingLocation.value = true;
    print("getting address.............");
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          controller.qrCode.value!.lat ?? 0, controller.qrCode.value!.long ?? 0);
      Placemark place = placemarks[0];
      addressString.value =
      "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";
      // print(placemarks);
    } catch (e) {
      isGettingLocation.value = false;
      addressString.value = "Not scanned yet";
    } finally {
      isGettingLocation.value = false;
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

  Future<void> updateQR(BuildContext context, String qrId) async {
    showLoading(context);
    try {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/qrcode/update/$qrId');

      final token = await TokenManager.getToken();

      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body:
        controller.selectedQuestionSet.value != null ?
        jsonEncode(<String, dynamic>{
          'boxNo': boxName.text,
          'questionSetId': controller.selectedQuestionSet.value!.id
        }) :
        jsonEncode(<String, dynamic>{
          'boxNo': boxName.text,
        }),
      );

      print("boxName =====>>>> ${boxName.text}");

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        boxName.clear();
        controller.selectedQuestionSet.value = null;
        controller.getQRs();
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

  void editQR(QRModel qrCode, BuildContext context) {
    boxName.text = qrCode.boxNo;
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
                            Get.to(QRQuestionSetHistoryScreen(), arguments: {
                              "targetScreen": "selectQuestionSet"
                            });
                          },
                          icon: const Icon(
                            Icons.description_outlined,
                            color: Colors.black,
                          ),
                          label: Text(
                            controller.selectedQuestionSet.value == null
                                ? qrCode.questionSet.title   // fallback to QR’s question set
                                : controller.selectedQuestionSet.value!.title,
                            style: TextStyle(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
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
                controller.selectedQuestionSet.value = null;
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
                  updateQR(context, controller.qrCode.value!.id);
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}