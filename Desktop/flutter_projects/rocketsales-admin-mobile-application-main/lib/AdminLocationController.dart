import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class AdminLocationController extends GetxController {

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.dialog(
        AlertDialog(
          title: const Text("Location Service Disabled"),
          content: const Text("Please enable your location service."),
          actions: [
            TextButton(
              onPressed: () {
                Geolocator.openLocationSettings();
              },
              child: const Text("Open Settings"),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      );
      return Future.error('Location services are disabled.');
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    // 🚨 If denied forever → Show dialog to open app settings
    if (permission == LocationPermission.deniedForever) {
      Get.dialog(
        AlertDialog(
          title: const Text("Location Permission Required"),
          content: SingleChildScrollView(
            child: const Text(
              "We need location permission to confirm attendance location.\n"
                  "Please enable permission from settings.",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Geolocator.openAppSettings();
              },
              child: const Text("Open Settings"),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      );

      return Future.error('Location permissions are permanently denied.');
    }

    // If everything is fine → Get location
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
