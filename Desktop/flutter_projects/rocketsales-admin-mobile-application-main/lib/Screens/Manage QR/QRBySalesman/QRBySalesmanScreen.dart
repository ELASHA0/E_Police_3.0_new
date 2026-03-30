import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:rocketsales_admin/Screens/Manage%20QR/QRBySalesman/FiltrationSystemQR.dart';
import 'package:rocketsales_admin/Screens/Manage%20QR/QRBySalesman/QRBySalesmanController.dart';
import 'package:rocketsales_admin/Screens/task%20sales%20man/CreateAndEditTask/CreateEditTaskController.dart';
import '../../../resources/my_colors.dart';
import 'QRBySalesmanCard.dart';

class QRBySalesmanScreen extends StatefulWidget {
  const QRBySalesmanScreen({super.key});

  @override
  State<QRBySalesmanScreen> createState() => _QRBySalesmanScreenState();
}

class _QRBySalesmanScreenState extends State<QRBySalesmanScreen> {
  final QRBySalesmanController controller = Get.put(QRBySalesmanController());

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    String salesmanId = args["salesmanId"];
    controller.salesmanId.value = salesmanId;
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print('reached end');
        controller.isMoreCardsAvailable.value = true;
        controller.getMoreQRBySalesman();
      }
    });
  }

  // @override
  // void dispose() {
  //   scrollController.dispose();
  //   Get.delete<CreateEditTaskController>(force: true);
  //   Get.delete<TaskController>();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "QRs by Salesmen",
          style: TextStyle(color: Colors.white),
        ),
        leading: const BackButton(
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
              child: FiltrationsystemQR(),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(
                        color: MyColor.dashbord,
                      ));
                } else if (controller.qrsBySalesman.isEmpty) {
                  return const Center(child: Text("No QR found."));
                } else {
                  return RefreshIndicator(
                    backgroundColor: Colors.white,
                    color: MyColor.dashbord,
                    onRefresh: () async {
                      controller.getQRBySalesman();
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: controller.qrsBySalesman.length + 1,
                      itemBuilder: (context, index) {
                        if (index < controller.qrsBySalesman.length) {
                          final item = controller.qrsBySalesman[index];
                          return QRBySalesmanCard(
                            qrBySalesman: item,
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
