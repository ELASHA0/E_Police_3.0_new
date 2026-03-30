import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../AdminLocationController.dart';
import '../../TokenManager.dart';
import '../../resources/my_colors.dart';
import 'ShopModel.dart';

class ManageShopController  extends GetxController {
  AdminLocationController controller = AdminLocationController();
  final TextEditingController shopNameController = TextEditingController();

  RxDouble latitude = 28.6139.obs;
  RxDouble longitude = 77.2090.obs;
  RxDouble radius = 1.0.obs;
  RxBool isGettingLocation = false.obs;
  Rxn<LatLng> selectedPosition = Rxn<LatLng>();

  var shops = <Shop>[].obs;
  final isLoading = false.obs;
  RxInt page = 2.obs;
  RxBool isMoreCardsAvailable = false.obs;
  final searchString = ''.obs;

  // final byPresets = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getShops();
  }

  void getCurrentLocation() async {
    isGettingLocation.value = true;
    print("getting location.............");
    try {
      final adminLocation = await controller.determinePosition();
      latitude.value = adminLocation.latitude;
      longitude.value = adminLocation.longitude;
    } catch (e) {
      isGettingLocation.value = false;
      Get.snackbar("Location Error", e.toString());
    } finally {
      // ✅ Always reset to false, even if error
      isGettingLocation.value = false;
    }
  }

  void getShops() async {
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
          '${dotenv.env['BASE_URL']}/api/api/get/geofence?limit=20&search=$searchString');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("url to get shop ========>>>>>> $url");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        final List<dynamic> dataList = jsonData['data'];
        final shopsList =
        dataList.map((item) => Shop.fromJson(item)).toList();
        shops.assignAll(shopsList);
      } else {
        shops.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      shops.clear();
      // Get.snackbar("Exception", e.toString());
      print("errorr =======>>>>>> ${e.toString()}");
      Get.snackbar("Exception", "Couldn't get shops");
    } finally {
      isLoading.value = false;
    }
  }

  void getMoreShopsCards() async {
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
          '${dotenv.env['BASE_URL']}/api/api/get/geofence?page=$page&limit=20&search=$searchString');
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
        final shopsList =
        dataList.map((item) => Shop.fromJson(item)).toList();
        // page.value++;
        if (shopsList.length < 1) {
          isMoreCardsAvailable.value = false;
          // page.value = 1;
        } else {
          page.value++;
        }
        shops.addAll(shopsList);
      } else {
        shops.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      shops.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get shop history");
    }
  }

  Future<void> updateShop(BuildContext context, String shopId) async {
    showLoading(context);
    try {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/geofence/$shopId');

      final token = await TokenManager.getToken();

      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'radius': radius.value,
          'shopName': shopNameController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        getShops();
        // controller.getOrders();
        Get.snackbar("Success", "Shop info submitted");
      } else {
        Navigator.of(context).pop();
        print("❌ Shop submission Failed: ${response.body}");
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      // isLoading.value = false;
      Navigator.of(context).pop();
      print("⚠️ Exception in posting Shop: $e");
      Get.snackbar("Exception", e.toString());
    }
  }

  Future<void> createShop(BuildContext context) async {
    showLoading(context);
    try {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/geofence');

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
          // 'shopId': controller.shopId.value,
          'companyId': companyId,
          'branchId': branchId,
          'supervisorId': supervisorId,
          'latitude': latitude.value,
          'longitude': longitude.value,
          'radius': radius.value,
          'shopName': shopNameController.text,
        }),
      );

      if (response.statusCode == 201) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        getShops();
        // controller.getOrders();
        Get.snackbar("Success", "Shop info submitted");
      } else {
        Navigator.of(context).pop();
        print("❌ Shop submission Failed: ${response.body}");
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      // isLoading.value = false;
      Navigator.of(context).pop();
      print("⚠️ Exception in posting Shop: $e");
      Get.snackbar("Exception", e.toString());
    }
  }

  void showShopCreateSheet(BuildContext context) {
    final byPresets = false.obs;
    final ManageShopController controller = Get.find<ManageShopController>();
    final List<int> presetValues = [50, 100, 200, 400, 500, 800, 1000];
    final _formKey = GlobalKey<FormState>();
    showModalBottomSheet<void>(
      barrierColor: Colors.transparent,
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true, // allows full height with keyboard
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Create new shop",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.shopNameController,
                    decoration: const InputDecoration(
                      labelText: "Shop Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Shop name is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  byPresets.value = false;
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: !byPresets.value
                                      ? MyColor.dashbord
                                      : Colors.grey.shade300,
                                  foregroundColor: !byPresets.value
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                child: const Text("Custom"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  byPresets.value = true;

                                  // 🧠 Snap to nearest preset
                                  double current = controller.radius.value;
                                  int nearest = presetValues.reduce((a, b) =>
                                  (a - current).abs() < (b - current).abs()
                                      ? a
                                      : b);
                                  controller.radius.value = nearest.toDouble();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: byPresets.value
                                      ? MyColor.dashbord
                                      : Colors.grey.shade300,
                                  foregroundColor: byPresets.value
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                child: const Text("Presets"),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Shop Radius: ${radius.value.toInt()} m",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 7,),
                        byPresets.value ?
                        DropdownButtonFormField<int>(
                          value: presetValues.contains(
                              controller.radius.value.round())
                              ? controller.radius.value.round()
                              : presetValues.first,
                          onChanged: (val) {
                            if (val != null) {
                              controller.radius.value = val.toDouble();
                            }
                          },
                          items: presetValues
                              .map((val) => DropdownMenuItem<int>(
                            value: val,
                            child: Text("$val m"),
                          ))
                              .toList(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                        ) :
                        Slider(
                          value: radius.value,
                          min: 1,
                          max: 1000,
                          divisions: 999,
                          label: "${radius.value.toInt()} m",
                          activeColor: MyColor.dashbord,
                          onChanged: (value) {
                            radius.value = value;
                          },
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: MyColor.dashbord,
                        ),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.createShop(context);
                          }
                        } ,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColor.dashbord,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Submit"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showShopUpdateSheet(BuildContext context, Shop shop) {
    // final ManageShopController controller = Get.find<ManageShopController>();
    final List<int> presetValues = [50, 100, 200, 400, 500, 800, 1000];
    shopNameController.text = shop.shopName;
    radius.value = shop.radius;
    final byPresets = false.obs;
    final _formKey = GlobalKey<FormState>();

    showModalBottomSheet<void>(
      barrierColor: Colors.transparent,
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Create new shop",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Shop name is required";
                      }
                      return null;
                    },
                    controller: shopNameController,
                    decoration: const InputDecoration(
                      labelText: "Shop Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  byPresets.value = false;
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: !byPresets.value
                                      ? MyColor.dashbord
                                      : Colors.grey.shade300,
                                  foregroundColor: !byPresets.value
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                child: const Text("Custom"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  byPresets.value = true;

                                  // 🧠 Snap to nearest preset
                                  double current = radius.value;
                                  int nearest = presetValues.reduce((a, b) =>
                                  (a - current).abs() < (b - current).abs()
                                      ? a
                                      : b);
                                  radius.value = nearest.toDouble();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: byPresets.value
                                      ? MyColor.dashbord
                                      : Colors.grey.shade300,
                                  foregroundColor: byPresets.value
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                child: const Text("Presets"),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Shop Radius: ${radius.value.toInt()} m",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        byPresets.value ?
                        DropdownButtonFormField<int>(
                          value: presetValues.contains(
                              radius.value.round())
                              ? radius.value.round()
                              : presetValues.first,
                          onChanged: (val) {
                            if (val != null) {
                              radius.value = val.toDouble();
                            }
                          },
                          items: presetValues
                              .map((val) => DropdownMenuItem<int>(
                            value: val,
                            child: Text("$val m"),
                          ))
                              .toList(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                        ) :
                        Slider(
                          value: radius.value,
                          min: 1,
                          max: 1000,
                          divisions: 999,
                          label: "${radius.value.toInt()} m",
                          activeColor: MyColor.dashbord,
                          onChanged: (value) {
                            radius.value = value;
                          },
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: MyColor.dashbord,
                        ),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            updateShop(context, shop.id);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColor.dashbord,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Submit"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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