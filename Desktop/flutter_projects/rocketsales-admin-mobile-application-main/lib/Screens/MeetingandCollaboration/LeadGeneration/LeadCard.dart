import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:rocketsales_admin/Screens/MeetingandCollaboration/LeadGeneration/LeadgenerationController.dart';
import 'package:rocketsales_admin/Screens/MeetingandCollaboration/LeadGeneration/leadgenerationmodel.dart';
import 'package:rocketsales_admin/Screens/MeetingandCollaboration/LeadGeneration/LeadgenerationController.dart';

import 'CreateLead.dart';
import 'SavedLeadData.dart';

class LeadCard extends StatefulWidget {
  final LeadManagement lead;

  const LeadCard({super.key, required this.lead});

  @override
  State<LeadCard> createState() => _LeadCardState();
}

String formatDate(String? date) {
  if (date == null) return "";

  DateTime dt = DateTime.parse(date);

  return DateFormat('dd MMM yyyy').format(dt);
}

String capitalize(String? text) {
  if (text == null || text.isEmpty) return "";
  return text[0].toUpperCase() + text.substring(1);
}

class _LeadCardState extends State<LeadCard> {
  // connects to the controller of the lead genration
  final LeadGenerationController leadGenerationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // changed this 2
        Get.to(() => Savedleaddata(lead: widget.lead));
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12, width: 2),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E4DB7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  capitalize(widget.lead.leadTitle ?? ""),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 6),
              Wrap(
                spacing: 6,
                children: [
                  GlowIcon(icon: Icons.calendar_today),
                  Text(formatDate(widget.lead.createdAt)),
                ],
              ),
              SizedBox(height: 6),
              Wrap(
                spacing: 6,
                children: [
                  GlowIcon(icon: Icons.person),
                  Text(widget.lead.clientName ?? ""),
                ],
              ),
              SizedBox(height: 6),
              Wrap(
                spacing: 6,
                children: [
                  GlowIcon(icon: Icons.phone),
                  Text(widget.lead.clientPhone ?? ""),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlowIcon extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color color;
  final double padding;

  const GlowIcon({
    super.key,
    required this.icon,
    this.iconSize = 20.0,
    this.color = const Color(0xFF1E4DB7),
    this.padding = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0x807FDEEA),
        // Background of the icon
      ),
      child: Icon(icon, size: iconSize, color: color),
    );
  }
}
