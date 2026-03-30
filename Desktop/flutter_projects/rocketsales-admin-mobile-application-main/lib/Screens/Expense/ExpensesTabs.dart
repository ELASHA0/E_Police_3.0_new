import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rocketsales_admin/Screens/Expense/ExpensesHistoryBySalesman.dart';
import 'package:rocketsales_admin/Screens/SalesmanListScreen/SalesmanListScreen.dart';

import '../../../resources/my_colors.dart';
import '../SalesmanListScreen/SalesmanListController.dart';
import 'CreateAndEditExpense/CreateAndEditExpenseScreen.dart';
import 'ExpensesController.dart';
import 'ExpensesHistoryScreen.dart';

class ExpenseTabs extends StatefulWidget {
  const ExpenseTabs({super.key});

  @override
  State<ExpenseTabs> createState() => _ExpenseTabsState();
}

class _ExpenseTabsState extends State<ExpenseTabs> with TickerProviderStateMixin {

  final ExpensesController controller = Get.put(ExpensesController(), permanent: true);

  final SalesmanListController salesmanController = Get.put(SalesmanListController());

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getExpenses();
    });
    int initialIndex = Get.arguments ?? 0;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: initialIndex,
    );
    salesmanController.targetScreen.value = () => ExpensesHistoryBySalesman();
  }

  @override
  void dispose() {
    _tabController.dispose();
    Get.delete<ExpensesController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.dashbord,
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text(
          'Expense',
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
                'All Expenses',
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
          ExpensesHistoryScreen(),
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
