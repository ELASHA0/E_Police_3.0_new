import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rocketsales_admin/Screens/Attendance/SalesmanAttendanceList/AttendanceTabs.dart';
import 'package:rocketsales_admin/Screens/Manage%20QR/QRTabs.dart';
import 'package:rocketsales_admin/Screens/MeetingandCollaboration/LeadGeneration/leadScreen.dart';
import 'package:rocketsales_admin/Screens/Opportunities/OpportunitiesTabs.dart';
import 'package:rocketsales_admin/Screens/Orders/OrderTabs.dart';
import 'package:rocketsales_admin/Screens/PayrollPolicy/PayrollTrakingScreen.dart';
import 'package:rocketsales_admin/Screens/SalesmanListScreen/SalesmanListScreen.dart';
import 'package:rocketsales_admin/Screens/Workpad/WorkpadTabs.dart';
import 'package:rocketsales_admin/Screens/task%20sales%20man/TaskSalesmanListScreen.dart';
import '../../../resources/my_assets.dart';
import '../../../resources/my_colors.dart';
import '../Analytics/AnalyticsScreen.dart';
import '../AttendancePayrollCombineScreen/AttendancePayrollCombineScreen.dart';
import '../AttendanceTrakingOfSalesman/AttendanceTrackingScreen.dart';
import '../Expense/ExpensesHistoryBySalesman.dart';
import '../Expense/ExpensesTabs.dart';
import '../LeaveApplication/LeaveHistoryScreen.dart';
import '../Login/AuthController.dart';
import '../ManageShop/ManageShopsScreen.dart';
import '../MeetingandCollaboration/LeadGeneration/CreateLead.dart';
import '../MeetingandCollaboration/LeadGeneration/LeadSalesmenAssignment.dart';
import '../MeetingandCollaboration/MeetingAndCollaboration.dart';
import '../UserManagement/UserManagementScreen.dart';
import '../chat/ChatSalesmanListScreen.dart';
import '../live trackings/Live_Tracking_Screen.dart';
import 'AdminCustomDrawer.dart';
import 'AdminDashboardController.dart';

import 'ImagePreviewScreen.dart';
import 'package:rocketsales_admin/Screens/MeetingandCollaboration/LeadGeneration/leadScreen.dart';

class DashboardAdmin extends StatelessWidget {
  DashboardAdmin({super.key});

  final AuthController authController = Get.put(AuthController());
  final adminDashboardController controller = Get.put(
    adminDashboardController(),
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text("Rocketsales", style: TextStyle(color: Colors.white)),
        backgroundColor: MyColor.dashbord,
      ),
      drawer: AdminCustomDrawer(),
      body: Obx(() {
        return Stack(
          children: [
            /// Top Gradient Header
            Container(child: Image(image: dashBoardImage)),
            Container(
              height: 220,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    // Color.fromRGBO(10, 42, 139, 1),
                    MyColor.dashbord,
                    Color.fromRGBO(0, 0, 0, 0.27),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() {
                          Uint8List? profileImage = controller.bytes.value;
                          if (controller.loadingProfile.value) {
                            return const CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 40,
                              child: CircularProgressIndicator(
                                color: MyColor.dashbord,
                              ),
                            );
                          } else if (profileImage == null ||
                              controller.bytes.value == null) {
                            return GestureDetector(
                              onTap: controller.postImage,
                              child: Stack(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 40,
                                    child: Icon(
                                      Icons.person,
                                      size: 30,
                                      color: Colors.white,
                                    ), // default avatar
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .blue, // background for the plus icon
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(
                                        Icons.add,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                Get.to(
                                  ImagePreviewScreen(imageFile: profileImage),
                                );
                              },
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 40,
                                    backgroundImage: MemoryImage(profileImage),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .blue, // background for the plus icon
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(
                                        Icons.add,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Welcome!",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${controller.username.value}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Grid Menu
                  controller.checkingForInternet.value
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: MyColor.dashbord,
                            ),
                          ),
                        )
                      : controller.isConnectedToInternet.value == false
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Center(
                            child: Column(
                              mainAxisSize:
                                  MainAxisSize.min, // <-- shrink to contents
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // <-- center children vertically
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Check for internet connection",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    controller.getPermissions();
                                  },
                                  child: const Text("Retry"),
                                ),
                              ],
                            ),
                          ),
                        )
                      : controller.permissions.value == null
                      ? Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GridView.count(
                              childAspectRatio: 1.1,
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              children: [
                                _buildMenuCard(
                                  Icons.location_on_outlined,
                                  "Live Tracking",
                                  LiveTrackingScreen(),
                                  context,
                                ),

                                _buildMenuCard(
                                  Icons.supervisor_account_outlined,
                                  "Manage Users",
                                  UserManagementScreen(),
                                  context,
                                ),
                                _buildMenuCard(
                                  Icons.calendar_today,
                                  "Attendance",
                                  AttendanceTabs(),
                                  context,
                                ),
                                _buildMenuCard(
                                  Icons.checklist,
                                  "Task",
                                  TaskSalesmanListScreen(),
                                  context,
                                ),
                                _buildMenuCard(
                                  Icons.shopping_cart_outlined,
                                  "Order",
                                  OrderTabs(),
                                  context,
                                ),
                                _buildMenuCard(
                                  Icons.chat_bubble_outline,
                                  "Chat",
                                  ChatSalesmanListScreen(),
                                  context,
                                ),
                                _buildMenuCard(
                                  Icons.currency_rupee,
                                  "Expenses",
                                  ExpenseTabs(),
                                  context,
                                ),
                                _buildMenuCard(
                                  Icons.exit_to_app,
                                  "Leave Application",
                                  LeaveHistoryScreen(),
                                  context,
                                ),
                                _buildMenuCard(
                                  Icons.analytics_outlined,
                                  "Analytics",
                                  AnalyticsScreen(),
                                  context,
                                ),
                                _buildMenuCard(
                                  Icons.warehouse_outlined,
                                  "Manage Shops",
                                  ManageShopsScreen(),
                                  context,
                                ),
                                _buildMenuCard(
                                  Icons.qr_code,
                                  "Manage QR",
                                  QRTabs(),
                                  context,
                                ),
                                _buildMenuCard(
                                  Icons.post_add,
                                  "Workpad",
                                  WorkpadTabs(),
                                  context,
                                ),
                                // _buildMenuCard(Icons.account_circle,"Attendance Track", AttendanceTrakingScreen(), context),
                                // _buildMenuCard(Icons.payment, "Payroll", Payrolltrakingscreen(), context),
                                _buildMenuCard(
                                  Icons.payment,
                                  "Payroll",
                                  AttendancePayrollCombineScreen(),
                                  context,
                                ),
                                _buildMenuCard(
                                  Icons.person_add,
                                  "Leads and Clients",
                                  Meetingandcollaboration(),
                                  context,
                                ),


                                // _buildMenuCard(Icons.handshake_outlined, "Opportunities",
                                //     OpportunitiesTabs(),
                                //     context)
                              ],
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GridView.count(
                              childAspectRatio: 1.1,
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              children: [
                                _buildMenuCard(
                                  Icons.location_on_outlined,
                                  "Live Tracking",
                                  LiveTrackingScreen(),
                                  context,
                                ),

                                _buildMenuCard(
                                  Icons.supervisor_account_outlined,
                                  "Manage Users",
                                  UserManagementScreen(),
                                  context,
                                ),

                                if (controller
                                        .permissions
                                        .value
                                        ?.modules
                                        .attendance !=
                                    null)
                                  _buildMenuCard(
                                    Icons.calendar_today,
                                    "Attendance",
                                    AttendanceTabs(),
                                    context,
                                  ),

                                if (controller
                                        .permissions
                                        .value
                                        ?.modules
                                        .management
                                        .taskManagement !=
                                    null)
                                  _buildMenuCard(
                                    Icons.checklist,
                                    "Task",
                                    TaskSalesmanListScreen(),
                                    context,
                                  ),

                                if (controller
                                        .permissions
                                        .value
                                        ?.modules
                                        .orders !=
                                    null)
                                  _buildMenuCard(
                                    Icons.shopping_cart_outlined,
                                    "Order",
                                    OrderTabs(),
                                    context,
                                  ),

                                _buildMenuCard(
                                  Icons.chat_bubble_outline,
                                  "Chat",
                                  ChatSalesmanListScreen(),
                                  context,
                                ),

                                _buildMenuCard(
                                  Icons.currency_rupee,
                                  "Expenses",
                                  ExpenseTabs(),
                                  context,
                                ),
                                _buildMenuCard(
                                  Icons.exit_to_app,
                                  "Leave Application",
                                  LeaveHistoryScreen(),
                                  context,
                                ),
                                _buildMenuCard(
                                  Icons.analytics_outlined,
                                  "Analytics",
                                  AnalyticsScreen(),
                                  context,
                                ),
                                _buildMenuCard(
                                  Icons.warehouse_outlined,
                                  "Manage Shops",
                                  ManageShopsScreen(),
                                  context,
                                ),
                                _buildMenuCard(
                                  Icons.qr_code,
                                  "Manage QR",
                                  QRTabs(),
                                  context,
                                ),
                                _buildMenuCard(
                                  Icons.post_add,
                                  "Workpad",
                                  WorkpadTabs(),
                                  context,
                                ),

                                if (controller
                                        .permissions
                                        .value
                                        ?.modules
                                        .payroll !=
                                    null)
                                  _buildMenuCard(
                                    Icons.payment,
                                    "Payroll",
                                    AttendancePayrollCombineScreen(),
                                    context,
                                  ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
            if (controller.isLoading.value)
              Positioned.fill(
                child: Container(
                  color: Color.fromRGBO(0, 0, 0, 0.35),
                  child: const Center(
                    child: CircularProgressIndicator(color: MyColor.dashbord),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildMenuCard(
    IconData icon,
    String title,
    Widget path,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          if (title == "Manage Shops") {
            Get.to(path, arguments: {"targetScreen": "shopDetail"});
          } else {
            Get.to(path);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(
              color: Colors.black12, // border color
              width: 2, // border thickness
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    icon,
                    // color: Colors.blue[800],
                    color: MyColor.dashbord,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
