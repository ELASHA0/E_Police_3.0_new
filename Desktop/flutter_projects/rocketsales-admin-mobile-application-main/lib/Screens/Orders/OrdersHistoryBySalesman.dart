import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../resources/my_colors.dart';
import 'Create/CreateOrderScreen.dart';
import 'FiltrationSystemOrder.dart';
import 'OrderCard.dart';
import 'OrdersController.dart';

class OrdersHistoryBySalesman extends StatefulWidget {
  const OrdersHistoryBySalesman({super.key});

  @override
  State<OrdersHistoryBySalesman> createState() => _OrdersHistoryBySalesmanState();
}

class _OrdersHistoryBySalesmanState extends State<OrdersHistoryBySalesman> {
  final OrdersController controller = Get.put(OrdersController());

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    String salesmanId = args["salesmanId"];
    controller.searchString.value = "";
    controller.selectedTag.value = "";
    controller.page.value = 2;
    controller.isMoreCardsAvailable.value = false;
    controller.salesmanId.value = salesmanId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.orders.clear();
      controller.getOrders();
    });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print('reached end');
        controller.isMoreCardsAvailable.value = true;
        controller.getMoreOrderCards();
      }
    });
  }

  @override
  void dispose() {
    controller.salesmanId.value = "";
    controller.searchString.value = "";
    controller.selectedTag.value = "";
    controller.page.value = 2;
    controller.isMoreCardsAvailable.value = false;
    controller.getOrders();
    // Get.delete<OrdersController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Orders by Salesman",
          style: TextStyle(color: Colors.white),
        ),
        leading: BackButton(
          color: Colors.white,
        ),
        backgroundColor: MyColor.dashbord,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Filtrationsystemorder(),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(
                        color: MyColor.dashbord,
                      ));
                } else if (controller.orders.isEmpty) {
                  return const Center(child: Text("No Orders found."));
                } else {
                  return RefreshIndicator(
                    backgroundColor: Colors.white,
                    color: MyColor.dashbord,
                    onRefresh: () async {
                      controller.getOrders();
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: controller.orders.length + 1,
                      itemBuilder: (context, index) {
                        if (index < controller.orders.length) {
                          final item = controller.orders[index];
                          return OrderCard(
                            order: item,
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
}
