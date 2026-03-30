import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsales_admin/Screens/SalesmanListScreen/SalesmanListController.dart';
import 'package:rocketsales_admin/Screens/UserManagement/CreateEditUserScreen.dart';
import 'package:rocketsales_admin/Screens/chat/chat_screen_sales_man.dart';

import '../../resources/my_colors.dart';
import 'SalesmanCard.dart';
import 'SalesmanModel.dart';
import 'SearchSalesmanList.dart';

class SalesmanListScreen extends StatefulWidget {
  final Function(SalesmanModel)? onSalesmanSelected;
  const SalesmanListScreen({super.key, this.onSalesmanSelected});

  @override
  State<SalesmanListScreen> createState() => _SalesmanListScreenState();
}

class _SalesmanListScreenState extends State<SalesmanListScreen> {
  final SalesmanListController controller = Get.put(SalesmanListController());

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print('reached end');
        controller.isMoreCardsAvailable.value = true;
        controller.getMoreSalesmenCards();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: [
              SearchSalesmanList(),
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
                        controller.getSalesmen();
                      },
                      child: ListView(
                        controller: scrollController,
                        children: [
                          //Changed this recently
                         /* if (controller.admin.value != null)
                            controller.targetScreen.value!().runtimeType == ChatScreen ?*/
                          if (controller.admin.value != null && controller.targetScreen.value != null)
                            controller.targetScreen.value!().runtimeType == ChatScreen ?
                            GestureDetector(
                                onTap: () {

                                    if (controller.targetScreen.value != null) {
                                    Get.to(controller.targetScreen.value!, arguments: {
                                      'isEdit': true,
                                      "salesmanId": controller.admin.value!.id,
                                      "salesmanName": controller.admin.value!.salesmanName,
                                      'salesmanEmail': controller.admin.value!.salesmanEmail,
                                      'salesmanPhone': controller.admin.value!.salesmanPhone,
                                      'username': controller.admin.value!.username,
                                      'password': controller.admin.value!.password
                                    });
                                  }
                                },
                                child: SalesmanCard(salesman: controller.admin.value!, admin: "Admin",)
                            ) : SizedBox(),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.salesmen.length + 1,
                            itemBuilder: (context, index) {

                              if (index < controller.salesmen.length) {
                                final SalesmanModel item = controller.salesmen[index];
                                return GestureDetector(
                                  onTap: () {
                                    if(widget.onSalesmanSelected != null){
                                      widget.onSalesmanSelected!(item);
                                      Get.back();
                                    }
                                    else if (controller.targetScreen.value != null) {
                                      print("===========>>>> salesman tapped <<<<==========");
                                      Get.to(controller.targetScreen.value!, arguments: {
                                        'isEdit': true,
                                        "salesmanId": item.id,
                                        "salesmanName": item.salesmanName,
                                        'salesmanEmail': item.salesmanEmail,
                                        'salesmanPhone': item.salesmanPhone,
                                        'username': item.username,
                                        'password': item.password
                                      });
                                    }
                                  },
                                  child: SalesmanCard(salesman: item),
                                );
                              } else {
                                if (controller.isMoreCardsAvailable.value) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 32),
                                    child: Center(
                                      child: CircularProgressIndicator(color: MyColor.dashbord),
                                    ),
                                  );
                                } else {
                                  return const SizedBox(height: 5);
                                }
                              }
                            },
                          ),
                        ],
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
