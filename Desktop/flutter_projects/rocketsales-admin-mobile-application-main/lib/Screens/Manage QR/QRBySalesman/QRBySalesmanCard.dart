import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:rocketsales_admin/Screens/Manage%20QR/QRBySalesman/QRBySalesmanController.dart';
import 'package:rocketsales_admin/Screens/Manage%20QR/QRBySalesman/QRBySalesmanModel.dart';

import '../../../resources/my_colors.dart';
import 'QrBySalesmanDetailScreen.dart';

class QRBySalesmanCard extends StatelessWidget {
  final QRBySalesmanModel qrBySalesman;

  QRBySalesmanCard(
      {super.key,
        required this.qrBySalesman,});

  // final QRCardsController controller = QRCardsController();
  final QRBySalesmanController controller = Get.find<QRBySalesmanController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8, top: 4),
      child: Card(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          onTap: () {
            Get.to(() => QrBySalesmanDetailScreen(qrBySalesman: qrBySalesman),);
          },
          leading: const Icon(
            Icons.qr_code_2,
            size: 60,
          ),
          title: Row(
            children: [
              Text(
                  qrBySalesman.boxNo ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                controller.formattedDate(qrBySalesman.createdAt.toString()),
                style: const TextStyle(
                    fontFamily: 'NataSans-Regular', fontSize: 14),
              )
            ],
          ),
          subtitle: Text(qrBySalesman.address ?? ""),
          trailing: const Icon(
            size: 15,
            Icons.arrow_forward_ios,
            color: MyColor.dashbord,
          ),
          titleAlignment: ListTileTitleAlignment.threeLine,
        ),
      ),
    );
  }
}
