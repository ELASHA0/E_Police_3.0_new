import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import '../../AttendanceDetails/AttendanceScreen.dart';
import 'TodayAttendanceModel.dart';

class TodayAttendanceCard extends StatelessWidget {
  final TodayAttendance salesman;

  const TodayAttendanceCard({super.key, required this.salesman});

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
    Uint8List profileImage = base64Decode(salesman.profileImgUrl!);
    return GestureDetector(
      onTap: () {
        Get.to(() => AttendanceScreen(salesmanId: salesman.salesmanId?.id ?? "", salesmanName: salesman.salesmanId?.salesmanName ?? "", salesmanSelfieBase64: salesman.profileImgUrl,));
      },
      child: Container(
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
              Row(
                children: [
                  salesman.profileImgUrl == "" ? CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 20,
                    child: Icon(Icons.person, size: 30, color: Colors.white), // default avatar
                  ) : CircleAvatar(
                      radius: 20,
                      backgroundImage: MemoryImage(profileImage)
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      salesman.salesmanId?.salesmanName ?? "N/A",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  salesman.attendenceStatus == "Present" ? Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(
                            224, 247, 210, 1), // background color
                        border: Border.all(
                          color: Colors.green, // border color
                          width: 1, // border thickness
                        ),
                        borderRadius:
                        BorderRadius.circular(6), // optional: rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 1, left: 8, right: 8, bottom: 1),
                        child: Text(
                          "Present",
                          style: const TextStyle(
                              color: Color.fromRGBO(37, 87, 9, 1)),
                        ),
                      )) : Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(
                            247, 210, 210, 1), // background color
                        border: Border.all(
                          color: Colors.red, // border color
                          width: 1, // border thickness
                        ),
                        borderRadius:
                        BorderRadius.circular(6), // optional: rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 1, left: 8, right: 8, bottom: 1),
                        child: Text(
                          "Absent",
                          style: const TextStyle(color: Colors.red),
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 12),

              // Phone Number
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.arrow_forward_ios, color: Colors.green),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Check in",
                        style: TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                      SizedBox(height: 2),
                      Text(
                        formatDateTime(salesman.createdAt?.toLocal() ?? DateTime.now()),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Address
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.arrow_back_ios, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Check out",
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                        SizedBox(height: 2),
                        Text(
                          salesman.checkOutTime == null ? "N/A" :
                          formatDateTime(salesman.checkOutTime!.toLocal()),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
