import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rocketsales_admin/Screens/Orders/OrdersHistoryScreen.dart';
import 'package:rocketsales_admin/Screens/SalesmanListScreen/SalesmanListScreen.dart';

import '../../../resources/my_colors.dart';
import '../SalesmanListScreen/SalesmanListController.dart';
import 'Create/CreateOrderScreen.dart';
import 'OrdersController.dart';
import 'OrdersHistoryBySalesman.dart';

class OrderTabs extends StatefulWidget {
  const OrderTabs({super.key});

  @override
  State<OrderTabs> createState() => _OrderTabsState();
}

class _OrderTabsState extends State<OrderTabs> with TickerProviderStateMixin {

  final OrdersController controller = Get.put(OrdersController(), permanent: true);

  final SalesmanListController salesmanController = Get.put(SalesmanListController());

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getOrders();
    });
    int initialIndex = Get.arguments ?? 0;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: initialIndex,
    );
    salesmanController.targetScreen.value = () => OrdersHistoryBySalesman();
  }

  @override
  void dispose() {
    _tabController.dispose();
    Get.delete<OrdersController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(CreateOrderScreen(), arguments: {
            "screenType": "edit",
          });
        },
        icon: const Icon(Icons.add),
        // Optional icon
        label: const Text('Create Order'),
        // The text label
        backgroundColor: MyColor.dashbord,
        // Optional background color
        foregroundColor: Colors.white, // Optional text and icon color
      ),
      appBar: AppBar(
        backgroundColor: MyColor.dashbord,
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text(
          'Order',
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: Colors.white),
          tabs: <Widget>[
            Tab(
              child: Text(
                'All Orders',
                textAlign: TextAlign.center,
                style:
                TextStyle(fontSize: getResponsiveFontSize(context, 12.0)),
              ),
            ),
            Tab(
              child: Text(
                'By Salesman',
                textAlign: TextAlign.center,
                style:
                TextStyle(fontSize: getResponsiveFontSize(context, 12.0)),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OrdersHistoryScreen(),
          SalesmanListScreen(),
        ],
      ),
    );
  }

  double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double referenceWidth = 375.0; // iPhone 8 width
    return baseFontSize * (screenWidth / referenceWidth);
  }
}
