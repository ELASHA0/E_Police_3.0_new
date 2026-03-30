import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rocketsales_admin/Screens/ManageShop/ManageShopController.dart';

import '../../resources/my_colors.dart';

class CreateShopScreen extends StatefulWidget {
  const CreateShopScreen({super.key});

  @override
  State<CreateShopScreen> createState() => _CreateShopScreenState();
}

class _CreateShopScreenState extends State<CreateShopScreen> {
  GoogleMapController? mapController;

  final ManageShopController controller = Get.put(ManageShopController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getCurrentLocation();
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Shop"),
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        return
        controller.isGettingLocation.value ? Center(child: CircularProgressIndicator(color: MyColor.dashbord,),) :
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(controller.latitude.value, controller.longitude.value),
            zoom: 17,
          ),
          onMapCreated: (controller) {
            mapController = controller;
          },
          onTap: (LatLng position) {
            controller.selectedPosition.value = position;
            debugPrint("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
          },
          markers: controller.selectedPosition.value != null
              ? {
            Marker(
              markerId: const MarkerId("selected"),
              position: controller.selectedPosition.value!,
            )
          }
              : {},
          circles: controller.selectedPosition.value != null
              ? {
            Circle(
              circleId: const CircleId("shop_radius"),
              center: controller.selectedPosition.value!,
              radius: controller.radius.value, // in meters
              fillColor: MyColor.dashbord.withOpacity(0.2),
              strokeColor: MyColor.dashbord,
              strokeWidth: 2,
            ),
          }
              : {},
        );
      }),

      floatingActionButton: Obx(() {
        if (!controller.isGettingLocation.value) {
          return controller.selectedPosition.value != null
              ? FloatingActionButton.extended(
            onPressed: () {
              controller.showShopCreateSheet(context);
            },
            icon: const Icon(Icons.add),
            label: const Text('Save shop'),
            backgroundColor: MyColor.dashbord,
            foregroundColor: Colors.white,
          )
              : FloatingActionButton.extended(
            onPressed: () {
              null;
            },
            icon: const Icon(Icons.add),
            label: const Text('Click anywhere to save'),
            backgroundColor:
            const Color.fromRGBO(28, 80, 140, 0.59),
            foregroundColor: Colors.white,
          );
        } else {
          return Container();
        }
      })

    );
  }
}
