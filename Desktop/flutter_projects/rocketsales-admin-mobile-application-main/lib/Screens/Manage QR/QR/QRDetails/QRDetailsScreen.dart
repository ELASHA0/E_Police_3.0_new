import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rocketsales_admin/Screens/Manage%20QR/QR/QRDetails/QRDetailsController.dart';

import 'package:rocketsales_admin/Screens/Manage%20QR/QRBySalesman/QRBySalesmanModel.dart';

import '../../../../resources/my_colors.dart';
import '../QRController.dart';
import '../QRModel.dart';
import 'SaveQRScreen.dart';

class QrDetailScreen extends StatelessWidget {

  final QRModel qrCode;

  QrDetailScreen({super.key, required this.qrCode});

  final QRDetailsController controller = Get.put(QRDetailsController());

  String formattedDate(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);
    return DateFormat('dd/MM/yy').format(dateTime);
  }

  String formattedTime(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);

    // Format to hh:mm a (12-hour format with AM/PM)
    return DateFormat('hh:mm a').format(dateTime);
  }

  Uint8List decodeBase64Image(String base64String) {
    final cleanedBase64 = base64String.contains(",")
        ? base64String.split(",")[1]
        : base64String;

    return base64Decode(cleanedBase64);
  }

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = decodeBase64Image(qrCode.qrImage);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.dashbord,
          leading: const BackButton(
            color: Colors.white,
          ),
          title: const Text(
            'QR Information',
            style: TextStyle(color: Colors.white),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            controller.editQR(qrCode, context);
          },
          backgroundColor: MyColor.dashbord,
          foregroundColor: Colors.white,
          label: Text("Edit"),
          icon: const Icon(Icons.edit),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      width: 160,
                      // height: 160,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              child: Image.memory(
                                bytes,
                                fit: BoxFit.cover,
                              ),
                            ),
                            FilledButton(
                                onPressed: () {
                                  Get.to(SaveQRScreen(qrCode: qrCode,));
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: MyColor.dashbord,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.save_alt),
                                    SizedBox(width: 5,),
                                    Text("Save"),
                                  ],
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    textAlign: TextAlign.start,
                    qrCode.boxNo,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(12), // inner spacing
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // background color
                          borderRadius: BorderRadius.circular(12),
                          // rounded corners
                          border:
                          Border.all(color: Colors.black12, width: 1.5),
                          // border
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Supervisor : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              // 👈 ensures long text wraps
                              child: Text(
                                '${qrCode.supervisor!.supervisorName}',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(12), // inner spacing
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // background color
                          borderRadius: BorderRadius.circular(12),
                          // rounded corners
                          border:
                          Border.all(color: Colors.black12, width: 1.5),
                          // border
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Company : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              // 👈 ensures long text wraps
                              child: Text(
                                qrCode.company.companyName ?? "",
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(12), // inner spacing
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // background color
                          borderRadius: BorderRadius.circular(12),
                          // rounded corners
                          border:
                          Border.all(color: Colors.black12, width: 1.5),
                          // border
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Branch : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              // 👈 ensures long text wraps
                              child: Text(
                                qrCode.branch.branchName ?? "",
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(12), // inner spacing
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // background color
                          borderRadius: BorderRadius.circular(12),
                          // rounded corners
                          border:
                          Border.all(color: Colors.black12, width: 1.5),
                          // border
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "QR id : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              // 👈 ensures long text wraps
                              child: Text(
                                qrCode.id,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(12), // inner spacing
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // background color
                          borderRadius: BorderRadius.circular(12),
                          // rounded corners
                          border:
                          Border.all(color: Colors.black12, width: 1.5),
                          // border
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Commodity no: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              // 👈 ensures long text wraps
                              child: Text(
                                qrCode.boxNo ?? "",
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(12), // inner spacing
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // background color
                          borderRadius: BorderRadius.circular(12),
                          // rounded corners
                          border:
                          Border.all(color: Colors.black12, width: 1.5),
                          // border
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Address : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              // 👈 ensures long text wraps
                              child: Obx(() {
                                return controller.isGettingLocation.value == true ?
                                  Text(
                                    "Loading...",
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ) :
                                  Text(
                                    controller.addressString.value,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                              })
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            // inner spacing
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // background color
                              borderRadius: BorderRadius.circular(12),
                              // rounded corners
                              border: Border.all(
                                  color: Colors.black12, width: 1.5),
                              // border
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Date:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  formattedDate(qrCode.createdAt.toString()),
                                  style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            // inner spacing
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // background color
                              borderRadius: BorderRadius.circular(12),
                              // rounded corners
                              border: Border.all(
                                  color: Colors.black12, width: 1.5),
                              // border
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Time:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  formattedTime(qrCode.createdAt.toString()),
                                  style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(12), // inner spacing
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // background color
                          borderRadius: BorderRadius.circular(12),
                          // rounded corners
                          border:
                          Border.all(color: Colors.black12, width: 1.5),
                          // border
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Question set: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  // 👈 ensures long text wraps
                                  child: Text(
                                    qrCode.questionSet.title,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: qrCode.questionSet.questions.map((question) {
                                  return Text(
                                    "${question.questionNo}. ${question.text}",
                                    style: const TextStyle(fontSize: 14),
                                  );
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                  ],
                )
              ],
            ),
          ),
        )
    );
  }
}
