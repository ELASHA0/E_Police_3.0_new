import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:rich_editor/rich_editor.dart';
import 'LeadGeneration/LeadCard.dart';
import 'LeadGeneration/LeadgenerationController.dart';
import 'LeadGeneration/leadScreen.dart';

class Meetingandcollaboration extends StatefulWidget {
  const Meetingandcollaboration({super.key});

  @override
  State<Meetingandcollaboration> createState() =>
      _MeetingandcollaborationState();
}

class _MeetingandcollaborationState extends State<Meetingandcollaboration> {
  final LeadGenerationController leadGenerationController = Get.put(
    LeadGenerationController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meeting & Collaboration"),
        backgroundColor: const Color(0xFF1E4DB7),
        foregroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () {
          Get.to(() => LeadGenerationScreen());
        },
        child: Container(
          height: 300,
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
                  width: double.infinity,padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Use standard Icon if you don't have flutter_glow package
                      const GlowIcon(icon: Icons.person_add, color: Color(0xFF1E4DB7) ),
                      const SizedBox(width:10),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black, fontSize: 16),
                          children: [
                            const TextSpan(
                              text: 'Lead Generation ',
                              style: TextStyle(fontWeight: FontWeight.bold),),
                            WidgetSpan(
                              child: Transform.translate(
                                offset: const Offset(2, -4),
                                child: const Text(
                                  'Last 5 month',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10, // Replaces textScaleFactor
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
