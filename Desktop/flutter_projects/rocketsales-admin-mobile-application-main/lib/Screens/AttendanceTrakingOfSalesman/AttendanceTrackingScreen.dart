import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../resources/my_colors.dart';
import 'AttendanceController.dart';
import 'AttendanceOverviewScreen.dart';

class AttendanceTrakingScreen extends StatelessWidget {
  AttendanceTrakingScreen({super.key});

  final AttendanceTrakController controller =
  Get.put(AttendanceTrakController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.salesmans.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // ======================= FIXED SEARCH BAR =======================
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (value) => controller.filterSearch(value),
                decoration: InputDecoration(
                  hintText: "Search Salesman...",
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),


            const SizedBox(height: 10),

            // ======================= SCROLLABLE LIST =======================
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (!controller.isLoadingMore.value &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                    controller.fetchSalesman(loadMore: true);
                  }
                  return true;
                },
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    ...controller.filteredSalesmans.map((item) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border:
                          Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: MyColor.dashbord,
                              offset: const Offset(-4, 0),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // NAME + ACTION ICON BUTTON
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.salesmanName ?? "",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Attendanceoverviewscreen(
                                              salesmanId: item.id ?? "",
                                            ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MyColor.dashbord,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: const CircleBorder(),
                                  ),
                                  child: const Icon(
                                    Icons.remove_red_eye,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // PHONE ROW
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor:
                                  MyColor.dashbord.withOpacity(0.15),
                                  child: Icon(
                                    Icons.call,
                                    size: 18,
                                    color: MyColor.dashbord,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Phone",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      item.salesmanPhone ?? "N/A",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),

                            const SizedBox(height: 5),

                            // EMAIL ROW
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor:
                                  MyColor.dashbord.withOpacity(0.15),
                                  child: Icon(
                                    Icons.email_outlined,
                                    size: 18,
                                    color: MyColor.dashbord,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Email",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      item.salesmanEmail ?? "N/A",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    }),

                    // PAGINATION LOADER
                    if (controller.isLoadingMore.value)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
