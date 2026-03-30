import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:rocketsales_admin/Screens/Manage%20QR/QRBySalesman/QRBySalesmanModel.dart';

import '../../../resources/my_colors.dart';

class QrBySalesmanDetailScreen extends StatelessWidget {

  final QRBySalesmanModel qrBySalesman;

  QrBySalesmanDetailScreen({super.key, required this.qrBySalesman});


  String formattedDate(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);
    return DateFormat('dd/MM/yy').format(dateTime);
  }

  String formattedTime(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);

    // Format to hh:mm a (12-hour format with AM/PM)
    return DateFormat('hh:mm a').format(dateTime);
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
            'QR Information',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    textAlign: TextAlign.start,
                    qrBySalesman.salesman?.salesmanName ?? "",
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
                                '${qrBySalesman.supervisor!.supervisorName}',
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
                                qrBySalesman.company?.companyName ?? "",
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
                                qrBySalesman.branch?.branchName ?? "",
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
                                qrBySalesman.qrcode!.id,
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
                                qrBySalesman.boxNo ?? "",
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
                              child: Text(
                                qrBySalesman.address ?? "",
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
                                  formattedDate(qrBySalesman.createdAt.toString()),
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
                                  formattedTime(qrBySalesman.createdAt.toString()),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: qrBySalesman.questionAnswers.map((ans) {
                        return ListTile(
                          title: Text(ans.question),
                          subtitle: Text(ans.answer),
                        );
                      }).toList(),
                    )
                  ],
                )
              ],
            ),
          ),
        )
    );
  }
}
