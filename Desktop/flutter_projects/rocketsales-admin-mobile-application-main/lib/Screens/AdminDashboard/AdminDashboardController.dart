import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../TokenManager.dart';
import '../../resources/my_colors.dart';
import '../Login/AuthController.dart';
import 'dart:typed_data';

import '../Orders/OrdersController.dart';
import 'PermissionsModel.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class adminDashboardController extends GetxController {
  RxString username = ''.obs;
  RxBool isLoading = false.obs;
  var adminProfileInfo = SalesmanProfileInfo(
      name: '', userId: '', profileImage: '', objectId: '',
  )
      .obs;
  RxBool loadingProfile = false.obs;
  var bytes = Rxn<Uint8List>();

  Rxn<bool> isConnectedToInternet = Rxn();
  RxBool checkingForInternet = true.obs;
  Rxn<PermissionModel> permissions = Rxn<PermissionModel>();

  @override
  void onInit() {
    super.onInit();
    getPermissions();
    loadUsername();
    getProfileImage();
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

  Future<void> checkForInternetConnection() async {
    checkingForInternet.value = true;
    isConnectedToInternet.value = await InternetConnection().hasInternetAccess;
    checkingForInternet.value = false;
  }

  Future<void> getPermissions() async {
    loadingProfile.value = true;
    checkForInternetConnection();
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse('${dotenv.env['BASE_URL']}/api/api/permission/get');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      print("permissions =======>>>>>> ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData['data'];
        permissions.value = PermissionModel.fromJson(data);
      } else {
        permissions.value = null;
      }
    } catch (e) {
      print("Couldn't get Permissions");
    } finally {
      loadingProfile.value = false; // ✅ always reset
    }
  }

  Future<void> getProfileImage() async {
    loadingProfile.value = true;
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final adminId = decodedToken['id'];

      final url = Uri.parse('${dotenv.env['BASE_URL']}/api/api/profile/$adminId');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        adminProfileInfo.value = SalesmanProfileInfo.fromJson(jsonData);
        if (adminProfileInfo.value.profileImage?.isNotEmpty ?? false) {
          bytes.value = base64Decode(adminProfileInfo.value.profileImage!);
        } else {
          bytes.value = null;
        }
      } else {
        bytes.value = null;
      }
    } catch (e) {
      Get.snackbar("Exception", "Couldn't get Profile");
    } finally {
      loadingProfile.value = false; // ✅ always reset
    }
  }


  Future<void> deleteImage(BuildContext context) async {
    showLoading(context);
    isLoading.value = true;
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final objectId = adminProfileInfo.value.objectId;
      final response = await http.delete(
        Uri.parse('${dotenv.env['BASE_URL']}/api/api/profile/$objectId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 201) {
        isLoading.value = false;
        print("✅ Delete successful: ${response.body}");
        getProfileImage();
      } else {
        isLoading.value = false;
        print("❌ Delete failed: ${response.body}");
      }
    } catch (e) {
      isLoading.value = false;
      print("⚠️ Error uploading: $e");
    }
  }

  Future<void> postImage() async {
    isLoading.value = true;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'img'],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);

      String base64File;

      // ✅ Compress the image before encoding
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        quality: 20, // adjust quality as needed
        format: CompressFormat.jpeg,
      );

      if (compressedBytes == null) {
        print("⚠️ Compression failed, using original image");
        final fileBytes = await file.readAsBytes();
        base64File = base64Encode(fileBytes);
      } else {
        base64File = base64Encode(compressedBytes);
      }

      final token = await TokenManager.getToken();
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      final adminId = decodedToken['id'];
      final adminName = await TokenManager.getUsername();

      try {
        final response = await http.post(
          Uri.parse('${dotenv.env['BASE_URL']}/api/api/profile'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({
            "profileImage": base64File,
            "name": adminName,
            "userId": adminId,
          }),
        );

        if (response.statusCode == 201) {
          isLoading.value = false;
          print("✅ Upload successful: ${response.body}");
          getProfileImage();
        } else {
          isLoading.value = false;
          print("❌ Upload failed: ${response.body}");
        }
      } catch (e) {
        isLoading.value = false;
        print("⚠️ Error uploading: $e");
      }
    } else {
      isLoading.value = false;
    }
  }

  Future<void> updateImage(BuildContext context) async {
    isLoading.value = true;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'img'],
    );

    if (result != null && result.files.single.path != null) {
      showLoading(context);
      File file = File(result.files.single.path!);

      try {
        // ✅ Compress before upload
        final compressedBytes = await FlutterImageCompress.compressWithFile(
          file.absolute.path,
          minWidth: 800,   // adjust to your needs
          minHeight: 800,
          quality: 20,     // 0–100 (lower = smaller size)
        );

        if (compressedBytes == null) {
          throw Exception("Image compression failed");
        }

        // ✅ Convert compressed image to Base64
        String base64File = base64Encode(compressedBytes);

        final objectId = adminProfileInfo.value.objectId;
        final adminName = await TokenManager.getUsername();
        final token = await TokenManager.getToken();

        final response = await http.put(
          Uri.parse('${dotenv.env['BASE_URL']}/api/api/profile/$objectId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({
            "profileImage": base64File,
            "name": adminName,
          }),
        );

        if (response.statusCode == 200) {
          isLoading.value = false;
          print("✅ Upload successful: ${response.body}");
          getProfileImage(); // refresh profile after update
        } else {
          isLoading.value = false;
          print("❌ Upload failed: ${response.body}");
        }
      } catch (e) {
        isLoading.value = false;
        print("⚠️ Error uploading: $e");
      }
    } else {
      isLoading.value = false;
    }
  }

  Future<void> loadUsername() async {
    String? token = await TokenManager.getToken();

    if (token == null) {
      print("Error: No token found in SharedPreferences!");
      return;
    }

    print("Using Token: $token");
    String? name = await TokenManager.getUsername();
    if (name != null) {
      username.value = name;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    Get.find<AuthController>().logout();
    isLoading.value = false;
  }
}

class SalesmanProfileInfo {
  String? objectId;
  String? name;
  String? userId;
  String? profileImage;

  SalesmanProfileInfo(
      { required this.objectId,
        required this.name,
        required this.userId,
        required this.profileImage});

  SalesmanProfileInfo.fromJson(Map<String, dynamic> json) {
    objectId = json['_id'];
    name = json['name'];
    userId = json['userId'];
    profileImage = json['profileImage'];
  }
}