import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rocketsales_admin/Screens/Manage%20QR/Q&A%20Set/QRQuestionSetController.dart';
import 'package:rocketsales_admin/Screens/Manage%20QR/QRBySalesman/QRBySalesmanScreen.dart';
import '../../../resources/my_colors.dart';
import '../SalesmanListScreen/SalesmanListController.dart';
import '../SalesmanListScreen/SalesmanListScreen.dart';
import 'Q&A Set/QRQuestionSetsHistoryScreen.dart';
import 'QR/QRController.dart';
import 'QR/QRHistoryScreen.dart';

class QRTabs extends StatefulWidget {
  const QRTabs({super.key});

  @override
  State<QRTabs> createState() => _QRTabsState();
}

class _QRTabsState extends State<QRTabs> with TickerProviderStateMixin {

  final QRController controller = Get.put(QRController(), permanent: true);
  final QRQuestionSetController questionSetController = Get.put(QRQuestionSetController(), permanent: true);
  final SalesmanListController salesmanController = Get.put(SalesmanListController());

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getQRs();
      questionSetController.getQRSets();
    });
    salesmanController.targetScreen.value = () => QRBySalesmanScreen();
    int initialIndex = Get.arguments ?? 0;
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: initialIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    // Get.delete<SalesmanListController>(force: true);
    Get.delete<QRController>(force: true);
    Get.delete<QRQuestionSetController>(force: true);
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
          'Manage QR',
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
                'By Salesmen',
                textAlign: TextAlign.center,
                style:
                TextStyle(fontSize: getResponsiveFontSize(context, 12.0)),
              ),
            ),
            Tab(
              child: Text(
                'All QR',
                textAlign: TextAlign.center,
                style:
                TextStyle(fontSize: getResponsiveFontSize(context, 12.0)),
              ),
            ),
            Tab(
              child: Text(
                'Q/A set',
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
          SalesmanListScreen(),
          QRHistoryScreen(),
          QRQuestionSetHistoryScreen(),
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
