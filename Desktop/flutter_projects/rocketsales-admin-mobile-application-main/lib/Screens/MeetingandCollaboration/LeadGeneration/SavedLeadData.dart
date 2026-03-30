import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';
import 'package:rocketsales_admin/Screens/MeetingandCollaboration/LeadGeneration/CreateLead.dart';
import 'package:rocketsales_admin/Screens/MeetingandCollaboration/LeadGeneration/leadgenerationmodel.dart';

import '../../../resources/my_colors.dart';
import '../../Attendance/SalesmanAttendanceList/TodayAttendance/TodayAttendanceModel.dart';
import '../../SalesmanListScreen/SalesmanModel.dart';
import 'LeadCard.dart';
import 'LeadgenerationController.dart';

class Savedleaddata extends StatefulWidget {
  final LeadManagement lead;
  //Changed this recently
  //final SalesmanModel  onSalesmanSelected;
  // maybe we have to put this
  //  chnaged this 2
  // even this won't work
  //final SalesmanModel salesman;



  const Savedleaddata({super.key, required this.lead});

  @override
  State<Savedleaddata> createState() => _SavedleaddataState();
}

class _SavedleaddataState extends State<Savedleaddata> {
  late LeadManagement currentLead;
 // late SalesmanModel currentSalesmen;



  @override
  void initState() {
    super.initState();
    currentLead = widget.lead;
    //currentSalesmen = widget.salesman;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentLead.leadTitle ?? "Lead Details"),
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Get.to(() => CreateEditLeadScreen(lead: currentLead));

          final controller = Get.find<LeadGenerationController>();
          final updated = controller.leadList.firstWhereOrNull(
            (l) => l.id == currentLead.id,

          );
          if (updated != null) {
            setState(() {
              currentLead = updated;
            });
          }
        },
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit),
        label: const Text('Edit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildDetailCard("Lead Title", currentLead.leadTitle),
            buildDetailCard("Client Name", currentLead.clientName),
            buildDetailCard("Client Email", currentLead.clientEmail),
            buildDetailCard("Client Phone", currentLead.clientPhone),
            buildDetailCard("Address", currentLead.clientAdd),
            buildDetailCard("Shop Name", currentLead.shopName),
            buildDetailCard("Notes", currentLead.notes),
          // changed this recently
            buildDetailCard("Salesman",     currentLead.salesman?.salesmanName ?? "Not Assigned"), // ← add this

            buildDetailCard("Date", formatDate(currentLead.createdAt)),
          ],
        ),
      ),
    );
  }

  Widget buildDetailCard(String label, String? value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12, width: 1.5),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$label : ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 14,
              ),
            ),

            TextSpan(
              text: value ?? "N/A",
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
