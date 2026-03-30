import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsales_admin/Screens/live%20trackings/FiltrationSystemLiveTrack.dart';
import 'package:rocketsales_admin/Screens/live%20trackings/LiveTrackCard.dart';
import 'package:rocketsales_admin/Screens/live%20trackings/LiveTrackSalesman/MapsScreen.dart';
import 'package:rocketsales_admin/resources/my_colors.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';

import '../../TokenManager.dart';
import 'LiveTrackController.dart';
import 'LiveTrackSalesmanHistory/LiveTrackHistoryScreen.dart';
import 'SalesmanLiveTrack.dart';

class LiveTrackingScreen extends StatefulWidget {
  LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final LiveTrackController controller = Get.put(LiveTrackController());

  final Debouncer _debouncer = Debouncer();

  final TextEditingController searchController = TextEditingController();

  void _handleTextFieldChange(String value) {
    const duration = Duration(milliseconds: 500);
    _debouncer.debounce(
      duration: duration,
      onDebounce: () {
        controller.searchString.value = value;
      },
    );
  }

  void showTrackChoiceDialog(BuildContext context, SalesmanLiveTrack salesman) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: MyColor.dashbord,
        title: Text("Track Salesman"),
        content: Text("Do you want to see Live Track or Tracking History?"),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                SizedBox(width: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Get.to(MapsScreen(salesman: salesman))!.then((_) {
                      controller.initializeController();
                    });
                  },
                  child: Text("Live Track"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Get.to(LiveTrackHistoryScreen(salesman: salesman));
                  },
                  child: Text("History"),
                ),
              ],
            )
          ]

      ),
      barrierDismissible: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Tracking'),
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            FiltrationsystemLiveTrack(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(
                        color: MyColor.dashbord,
                      ));
                } else if (controller.salesmen.isEmpty) {
                  return const Center(child: Text("No Salesmen found."));
                } else {
                  return RefreshIndicator(
                    backgroundColor: Colors.white,
                    color: MyColor.dashbord,
                    onRefresh: () async {
                      controller.initSocket();
                    },
                    child: ListView.builder(
                      itemCount: controller.filteredSalesmen.length,
                      itemBuilder: (context, index) {
                        final salesman = controller.filteredSalesmen[index];
                        return GestureDetector(
                            onTap: () {
                              controller.socketService.dispose();
                              showTrackChoiceDialog(context, salesman);
                              // Get.to(MapsScreen(salesman: salesman))!.then((_) {
                              //   controller.initializeController();
                              // });
                            },
                            child: LiveTrackCard(salesman: salesman)
                        );
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

  Widget searchLiveTrackSalesman() {
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
                hintText: 'Search Salesmen',
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

