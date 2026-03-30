import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:rocketsales_admin/Screens/Manage%20QR/Q&A%20Set/QRQuestionSetController.dart';
import 'package:rocketsales_admin/Screens/Manage%20QR/Q&A%20Set/QRSetCard.dart';
import 'package:rocketsales_admin/Screens/Manage%20QR/QR/QRController.dart';
import '../../../resources/my_colors.dart';
import 'Q&ACreateEdit/Q&ACreateScreen.dart';
import 'Q&ASetDetailsScreen.dart';

class QRQuestionSetHistoryScreen extends StatefulWidget {
  const QRQuestionSetHistoryScreen({super.key});

  @override
  State<QRQuestionSetHistoryScreen> createState() => _QRQuestionSetHistoryScreenState();
}

class _QRQuestionSetHistoryScreenState extends State<QRQuestionSetHistoryScreen> {
  final QRQuestionSetController controller = Get.find<QRQuestionSetController>();
  late QRController qrController;

  final scrollController = ScrollController();
  final Debouncer _debouncer = Debouncer();
  late String targetScreen;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      targetScreen = args["targetScreen"] ?? "";
    } else {
      targetScreen = "";
    }
    if (targetScreen == "selectQuestionSet") {
      qrController = Get.find<QRController>();
    }
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print('reached end');
        controller.isMoreCardsAvailable.value = true;
        controller.getMoreQRSetCards();
      }
    });
  }

  void _handleTextFieldChange(String value) {
    const duration = Duration(milliseconds: 500);
    _debouncer.debounce(
      duration: duration,
      onDebounce: () {
        controller.searchString.value = value;
        controller.getQRSets();
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    // Get.delete<QRController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: targetScreen == "selectQuestionSet" ? AppBar(title: Text("Question sets"), backgroundColor: MyColor.dashbord, foregroundColor: Colors.white,) : null,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(QACreateScreen());
        },
        icon: const Icon(Icons.add),
        label: const Text('Create Q/A Set'),
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: SearchqrSets(),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(
                        color: MyColor.dashbord,
                      ));
                } else if (controller.qrSets.isEmpty) {
                  return const Center(child: Text("No Question set found."));
                } else {
                  return RefreshIndicator(
                    backgroundColor: Colors.white,
                    color: MyColor.dashbord,
                    onRefresh: () async {
                      await controller.getQRSets();
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      itemCount: controller.qrSets.length + 1,
                      itemBuilder: (context, index) {
                        if (index < controller.qrSets.length) {
                          final item = controller.qrSets[index];
                          return GestureDetector(
                            onTap: () {
                              if (targetScreen == "") {
                                Get.to(() => QandADetailScreen(questionSetModel: item,));
                              } else {
                                qrController.selectedQuestionSet.value = item;
                                Navigator.pop(context);
                              }
                              // Get.to(() => QandADetailScreen(questionSetModel: item,));
                            },
                            child: QuestionSetCard(
                              questionSet: item,
                            ),
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

  Widget SearchqrSets() {
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
                hintText: 'Search Question Set',
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
