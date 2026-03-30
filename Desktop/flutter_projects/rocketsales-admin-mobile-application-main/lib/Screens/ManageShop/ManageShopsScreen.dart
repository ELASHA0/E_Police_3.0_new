import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsales_admin/Screens/ManageShop/ManageShopController.dart';
import 'package:rocketsales_admin/Screens/ManageShop/ShopDetailScreen.dart';
import 'package:rocketsales_admin/resources/my_colors.dart';

import '../task sales man/CreateAndEditTask/CreateEditTaskController.dart';
import 'CreateShopScreen.dart';
import 'ShopCard.dart';

class ManageShopsScreen extends StatefulWidget {
  const ManageShopsScreen({super.key});

  @override
  State<ManageShopsScreen> createState() => _ManageShopsScreenState();
}

class _ManageShopsScreenState extends State<ManageShopsScreen> {
  final ManageShopController controller = Get.put(ManageShopController());
  final Debouncer _debouncer = Debouncer();

  final TextEditingController searchController = TextEditingController();

  late String targetScreen;

  late CreateEditTaskController taskController;

  final scrollController = ScrollController();

  // final CreateEditTaskController taskController = Get.find<CreateEditTaskController>();

  @override
  void initState() {
    final args = Get.arguments as Map<String, dynamic>;
    targetScreen = args["targetScreen"];
    if (targetScreen == "selectGeofence") {
      taskController = Get.find<CreateEditTaskController>();
    }
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print('reached end');
        controller.isMoreCardsAvailable.value = true;
        controller.getMoreShopsCards();
      }
    });
  }

  void _handleTextFieldChange(String value) {
    const duration = Duration(milliseconds: 500);
    _debouncer.debounce(
      duration: duration,
      onDebounce: () {
        controller.searchString.value = value;
        controller.getShops();
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Shops"),
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
        leading: BackButton(),
      ),
      floatingActionButton: targetScreen == "selectGeofence" ? null :
      FloatingActionButton.extended(
        onPressed: () {
          Get.to(CreateShopScreen());
        },
        icon: const Icon(Icons.add),
        // Optional icon
        label: const Text('Shop Geofence'),
        // The text label
        backgroundColor: MyColor.dashbord,
        // Optional background color
        foregroundColor: Colors.white, // Optional text and icon color
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            SearchShops(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(
                        color: MyColor.dashbord,
                      ));
                } else if (controller.shops.isEmpty) {
                  return const Center(child: Text("No Shops found."));
                } else {
                  return RefreshIndicator(
                    backgroundColor: Colors.white,
                    color: MyColor.dashbord,
                    onRefresh: () async {
                      controller.getShops();
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: controller.shops.length + 1,
                      itemBuilder: (context, index) {
                        if (index < controller.shops.length) {
                          final item = controller.shops[index];
                          return GestureDetector(
                              onTap: () {
                                // Get.to(controller.targetScreen.value!, arguments: {
                                //   "salesmanId": item.id,
                                //   "salesmanName": item.salesmanName
                                // });
                                if (targetScreen == "shopDetail") {
                                  Get.to(ShopDetailScreen(shop: item));
                                } else {
                                  taskController.selectedShop.value = item;
                                  Navigator.pop(context);
                                }
                                controller.latitude.value = item.latitude;
                                controller.longitude.value = item.longitude;
                              },
                              child: ShopCard(shop: item,)
                          );
                        } else {
                          if (controller.isMoreCardsAvailable.value) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: MyColor.dashbord,
                                ),
                              ),
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Center(child: Text('')),
                            );
                          }
                        }
                      },
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget SearchShops() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        // color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black54)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: _handleTextFieldChange,
              decoration: const InputDecoration(
                hintText: 'Search Shops',
                border: InputBorder.none,
              ),
            ),
          ),
          const Icon(Icons.search),
        ],
      ),
    );
  }
}
