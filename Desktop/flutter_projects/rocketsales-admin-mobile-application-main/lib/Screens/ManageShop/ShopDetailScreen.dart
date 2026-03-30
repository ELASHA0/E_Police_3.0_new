import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rocketsales_admin/Screens/ManageShop/ManageShopController.dart';

import '../../resources/my_colors.dart';
import 'ShopModel.dart';

class ShopDetailScreen extends StatefulWidget {
  final Shop shop;
  const ShopDetailScreen({super.key, required this.shop});

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  GoogleMapController? mapController;

  final ManageShopController controller = Get.find<ManageShopController>();

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.radius.value = widget.shop.radius;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Shop Details"),
          backgroundColor: MyColor.dashbord,
          foregroundColor: Colors.white,
        ),
        body: Obx(() {
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.shop.latitude, widget.shop.longitude),
              zoom: 17,
            ),
            onMapCreated: (controller) {
              mapController = controller;
            },
            onTap: (LatLng position) {
              controller.selectedPosition.value = position;
              debugPrint("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
            },
            markers: {Marker(
              markerId: const MarkerId("selected"),
              position: LatLng(widget.shop.latitude, widget.shop.longitude),
            )},
            circles: {
              Circle(
                circleId: const CircleId("shop_radius"),
                center: LatLng(widget.shop.latitude, widget.shop.longitude),
                radius: controller.radius.value,
                // in meters
                fillColor: MyColor.dashbord.withOpacity(0.2),
                strokeColor: MyColor.dashbord,
                strokeWidth: 2,
              )
            },
          );
        }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            controller.showShopUpdateSheet(context, widget.shop);
          },
          icon: const Icon(Icons.edit),
          label: const Text('Edit shop'),
          backgroundColor: MyColor.dashbord,
          foregroundColor: Colors.white,
        )

    );
  }
}
