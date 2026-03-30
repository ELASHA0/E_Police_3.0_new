import 'dart:ffi';

import 'package:based_battery_indicator/based_battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:rocketsales_admin/Screens/live%20trackings/LiveTrackSalesman/MapsScreen.dart';
import 'package:rocketsales_admin/Screens/live%20trackings/SalesmanLiveTrack.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../resources/my_colors.dart';
import 'LiveTrackSalesman/TrackSalesmanController.dart';

class LiveTrackCard extends StatelessWidget {
  final SalesmanLiveTrack salesman;

  LiveTrackCard({super.key, required this.salesman});

  late TrackSalesmanController controller;

  Future<void> _launchPhone(String? phoneNumber, BuildContext context) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number not found')),
      );
      return;
    }

    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(launchUri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number not found')),
      );
    }
  }

  bool isOlderThan30Seconds(DateTime givenTime) {
    final now = DateTime.now();
    final difference = now.difference(givenTime).inSeconds;
    return difference >= 30;
  }


  String formatDateTime(DateTime dateTime) {
    // Day with suffix (st, nd, rd, th)
    String day = DateFormat('d').format(dateTime);
    String suffix = 'th';
    if (!(day.endsWith('11') || day.endsWith('12') || day.endsWith('13'))) {
      if (day.endsWith('1')) suffix = 'st';
      else if (day.endsWith('2')) suffix = 'nd';
      else if (day.endsWith('3')) suffix = 'rd';
    }

    String formattedDate = DateFormat("d'$suffix' MMM yyyy, hh:mm a").format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left section: Avatar + Name + Status
            Expanded(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 30, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // 👈 align children to the left
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start, // 👈 align text to the top
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible( // 👈 ensures text takes available space
                              child: Text(
                                salesman.salesmanName ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 5,),
                            if (salesman.timestamp != null && !isOlderThan30Seconds(salesman.timestamp!))
                              const Icon(Icons.online_prediction_outlined, color: Colors.green),
                          ],
                        ),
                        buildLastUpdated(salesman.timestamp),
                        if (salesman.timestamp != null && !isOlderThan30Seconds(salesman.timestamp!))
                          Row(
                            children: [
                              BasedBatteryIndicator(
                                status: BasedBatteryStatus(
                                  value: 80,
                                  type: double.tryParse(salesman.batteryLevel ?? '0')! > 70
                                      ? BasedBatteryStatusType.normal
                                      : double.tryParse(salesman.batteryLevel ?? '0')! > 30
                                      ? BasedBatteryStatusType.low
                                      : BasedBatteryStatusType.error,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text("${salesman.batteryLevel}%"),
                            ],
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            // Right section: Phone button
            GestureDetector(
              onTap: () => _launchPhone(salesman.salesmanPhone, context),
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
      ),
    );
  }

  Widget buildLastUpdated(DateTime? datetime) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.update,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 6),
          Expanded( // 👈 ensures the text doesn’t overflow
            child: Text(
              "Last updated: ${datetime != null ? formatDateTime(datetime) : 'N/A'}",
              maxLines: 3, // 👈 now applied correctly
              overflow: TextOverflow.ellipsis, // 👈 add ellipsis
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
