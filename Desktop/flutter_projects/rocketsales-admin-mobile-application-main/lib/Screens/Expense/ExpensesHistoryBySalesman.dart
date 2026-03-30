import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsales_admin/Screens/Expense/FilterExpensesBar.dart';

import '../../../resources/my_colors.dart';
import 'CreateAndEditExpense/CreateAndEditExpenseScreen.dart';
import 'ExpenseCard/ExpensesCard.dart';
import 'ExpensesController.dart';

class ExpensesHistoryBySalesman extends StatefulWidget {
  const ExpensesHistoryBySalesman({super.key});

  @override
  State<ExpensesHistoryBySalesman> createState() => _ExpensesHistoryBySalesmanState();
}

class _ExpensesHistoryBySalesmanState extends State<ExpensesHistoryBySalesman> {
  final ExpensesController controller = Get.put(ExpensesController());

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    String salesmanId = args["salesmanId"];
    controller.searchString.value = "";
    controller.selectedTag.value = "";
    controller.page.value = 2;
    controller.salesmanId.value = salesmanId;
    controller.isMoreCardsAvailable.value = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.expenses.clear();
      controller.getExpensesBySalesmanId();
    });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print('reached end');
        controller.isMoreCardsAvailable.value = true;
        controller.getMoreExpensesCardsBySalesmanId();
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
    controller.getExpenses();
    // Get.delete<ExpensesController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(CreateAndEditExpenseScreen(), arguments: {
            "screenType": "edit",
          });
        },
        icon: const Icon(Icons.add),
        // Optional icon
        label: const Text('Create Expense'),
        // The text label
        backgroundColor: MyColor.dashbord,
        // Optional background color
        foregroundColor: Colors.white, // Optional text and icon color
      ),
      appBar: AppBar(
        title: const Text(
          "Expenses by Salesman",
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
              child: FiltrationsystemExpenses(),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(
                        color: MyColor.dashbord,
                      ));
                } else if (controller.expenses.isEmpty) {
                  return const Center(child: Text("No Expenses found."));
                } else {
                  return RefreshIndicator(
                    backgroundColor: Colors.white,
                    color: MyColor.dashbord,
                    onRefresh: () async {
                      controller.getExpensesBySalesmanId();
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: controller.expenses.length + 1,
                      itemBuilder: (context, index) {
                        if (index < controller.expenses.length) {
                          final item = controller.expenses[index];
                          return ExpenseCard(
                            expense: item,
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
