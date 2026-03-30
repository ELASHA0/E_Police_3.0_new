import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rocketsales_admin/Screens/AdminDashboard/RaiseTicket/RaiseTicketHistoryScreen.dart';
import 'package:rocketsales_admin/Screens/AdminDashboard/update%20password/Update_Password_Screen.dart';
import '../../resources/my_colors.dart';
import '../Login/AuthController.dart';
import 'AdminDashboardController.dart';
import 'dart:typed_data';

import 'feedback/Feedback_Screen.dart';
import 'help support/Help_Support_Screen.dart';

class AdminCustomDrawer extends StatelessWidget {
  AdminCustomDrawer({super.key});

  final adminDashboardController controller = Get.find();
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [MyColor.dashbord, Color.fromRGBO(1, 29, 74, 1)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                accountName: Obx(() => Text(
                  'Hello, ${controller.username.value}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                )),
                accountEmail: null,
                currentAccountPicture: Obx(() {
                  Uint8List? profileImage = controller.bytes.value;
                  if (controller.loadingProfile.value) {
                    return const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: CircularProgressIndicator(color: MyColor.dashbord),
                    );
                  } else if (profileImage == null) {
                    return const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 30, color: Colors.white),
                    );
                  } else {
                    return CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: MemoryImage(profileImage),
                    );
                  }
                }),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(55.0),
                      bottomRight: Radius.circular(55.0),
                    ),
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.home),
                        title: const Text('Home'),
                        onTap: () {
                          // Navigate to Home screen
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text('About us'),
                        onTap: () {
                          // Get.back(); // Equivalent to Navigator.pop(context)
                          // Get.to(() => AboutUsPage());
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.lock_outline),
                        title: const Text('Privacy'),
                        onTap: () {
                          // Get.back(); // Equivalent to Navigator.pop(context)
                          // Get.to(() => const PrivacyPolicy());
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.password_outlined),
                        title: const Text('Change Password'),
                        onTap: () {
                          Get.to(() => const UpdatePasswordScreen());
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.feedback_outlined),
                        title: const Text('Feedback'),
                        onTap: () {
                          Get.back(); // Equivalent to Navigator.pop(context)
                          Get.to(() => FeedbackScreen());
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.help_outline),
                        title: const Text('Help'),
                        onTap: () {
                          Get.back();
                          Get.to(() => const HelpSupportScreen());
                        },
                      ),
                      ListTile(
                        leading: const Icon(CupertinoIcons.ticket),
                        title: const Text('Raise Ticket'),
                        onTap: () {
                          Get.back();
                          Get.to(() => TicketHistoryScreen());
                        },
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Obx(() => ElevatedButton.icon(
                            icon: const Icon(
                              Icons.logout,
                              size: 24.0,
                              color: Colors.white,
                            ),
                            label: (controller.isLoading.value ||
                                authController.isLoading.value)
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              minimumSize: const Size(100, 40),
                            ),
                            onPressed: (controller.isLoading.value ||
                                authController.isLoading.value)
                                ? null
                                : () async {
                              controller.isLoading.value = true;
                              await controller.logout();
                              controller.isLoading.value = false;
                            },
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}