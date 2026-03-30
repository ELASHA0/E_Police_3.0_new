import 'package:epolicemarch/resources/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UIComponents {
  static void showLoading() {
    Get.dialog(
        Dialog(
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
                CircularProgressIndicator(color: MyColor.dashboard),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          ),
        )
    );
  }

  static void showNumberError() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: MyColor.dashboard,
        title: Text("Error"),
        content: Text("Something went wrong, please try again!"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("OK"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  static void showInternetError() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: MyColor.dashboard,
        title: Text("Couldn't connect"),
        content: Text("Please check your internet connection and try again!"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("OK"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  static void showCustomDialog(String title, String content) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: MyColor.dashboard,
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("OK"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  static void showCustomActionDialog(
      String title,
      String content,
      String buttonText,
      Color buttonColor,
      VoidCallback onConfirm,
      ) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: MyColor.dashboard,
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
            },
            child: Text(buttonText, style: TextStyle(color: buttonColor),),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}