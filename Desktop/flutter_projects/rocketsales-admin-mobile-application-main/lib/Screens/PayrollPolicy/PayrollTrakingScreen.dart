import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../resources/my_colors.dart';
import 'CurrentMonthPayrollScreen.dart';
import 'PayrollController.dart';

class Payrolltrakingscreen extends StatefulWidget {
  const Payrolltrakingscreen({super.key});

  @override
  State<Payrolltrakingscreen> createState() => _PayrolltrakingscreenState();
}

class _PayrolltrakingscreenState extends State<Payrolltrakingscreen> {
  final PayrollController controller = Get.put(PayrollController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   foregroundColor: Colors.white,
      //   backgroundColor: MyColor.dashbord,
      //   title: const Text(
      //     "Payroll of Salesman",
      //     style: TextStyle(fontWeight: FontWeight.w600),
      //   ),
      // ),
      // backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            /// 🔍 SEARCH BAR
            TextField(
              onChanged: (value) => controller.setSearch(value),
              decoration: InputDecoration(
                hintText: "Search Salesman...",
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// LIST + PAGINATION
            Expanded(
              child: Obx(() {
                if (controller.loading.value && controller.salesmen.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.salesmen.isEmpty) {
                  return const Center(child: Text("No Data Found"));
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (!controller.loadingMore.value &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      controller.loadMore();
                    }
                    return true;
                  },
                  child: ListView.builder(
                    itemCount:
                        controller.salesmen.length +
                        (controller.loadingMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      /// Loader item at bottom
                      if (index == controller.salesmen.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final item = controller.salesmen[index];

                      return Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border(
                            left: BorderSide(
                              color: MyColor.dashbord,
                              width: 4, // thickness of left line
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),


                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// NAME + ACTION
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.salesmanName ?? "N/A",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                // Row(
                                //   children: [
                                //     // Icon(Icons.account_circle),
                                //     CircleAvatar(
                                //       radius: 14,
                                //       backgroundColor: MyColor.dashbord.withOpacity(0.15),
                                //       child: Icon(Icons.account_circle,
                                //           size: 18, color: MyColor.dashbord),
                                //     ),
                                //     const SizedBox(width: 10),
                                //     Text(
                                //       item.salesmanName ?? "N/A",
                                //       style: const TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 16,
                                //       ),
                                //     ),
                                //   ],
                                // ),

                                ElevatedButton(
                                  onPressed: () {
                                    // here navigate to next page Current month payroll
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context)=> Currentmonthpayrollscreen(
                                          id: item.salesmanId!, branchId: item.branchId!,
                                        )));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MyColor.dashbord,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape:
                                        const CircleBorder(), // makes it round
                                  ),
                                  child: Icon(
                                    Icons.remove_red_eye,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            /// BANK
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: MyColor.dashbord.withOpacity(
                                    0.15,
                                  ),
                                  child: Icon(
                                    Icons.account_balance,
                                    size: 18,
                                    color: MyColor.dashbord,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Bank Name",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      item.bankDetails?.bankName ?? "N/A",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            /// SALARY
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: MyColor.dashbord.withOpacity(
                                    0.15,
                                  ),
                                  child: Icon(
                                    Icons.currency_rupee,
                                    size: 18,
                                    color: MyColor.dashbord,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Salary",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "${item.grossSalary ?? 0}",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
