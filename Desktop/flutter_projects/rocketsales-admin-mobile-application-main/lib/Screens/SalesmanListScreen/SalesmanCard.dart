import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsales_admin/Screens/SalesmanListScreen/SalesmanModel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../resources/my_colors.dart';
import '../Attendance/AttendanceDetails/AttendanceScreen.dart';

class SalesmanCard extends StatelessWidget {
  final SalesmanModel salesman;
  final String admin;

  const SalesmanCard({super.key, required this.salesman, this.admin = ""});

  Future<void> _launchPhone(String phoneNumber, BuildContext context) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      const snackBar = SnackBar(content: Text('Phone number not found'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (!await launchUrl(launchUri)) {
      const snackBar = SnackBar(content: Text('Phone number not found'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black12, // border color
          width: 2, // border thickness
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Avatar + Name + Online dot
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 22,
                  child: Icon(Icons.person, size: 30, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    admin == "Admin" ? "Admin" :
                    salesman.salesmanName ?? "",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Spacer(),
                admin == "Admin" ? Container() :
                GestureDetector(
                  onTap: () => _launchPhone(salesman.salesmanPhone ?? "", context),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.phone, color: MyColor.dashbord),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
