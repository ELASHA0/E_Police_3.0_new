import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rocketsales_admin/Screens/Manage%20QR/QR/QRModel.dart';

import '../../../resources/my_colors.dart';
import 'QRController.dart';
import 'QRDetails/QRDetailsScreen.dart';

class QrCard extends StatelessWidget {
  final QRModel qrModel;

  QrCard(
      {super.key,
        required this.qrModel});

  final QRController controller = Get.find<QRController>();

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

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
          // onTap: () {
          //   print(controller.qrCode.value!.lat);
          //   Get.to(() => QrDetailScreen(qrCode: qrModel,));
          // },
          leading: const Icon(
            Icons.qr_code_2,
            size: 60,
          ),
          title: Text(
            qrModel.boxNo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(formatDate(qrModel.createdAt)),
          trailing: IconButton(
              onPressed: () {
                controller.deleteQRdialog(context, qrModel.id);
              },
              color: Colors.red,
              icon: Icon(Icons.delete_outline_outlined)),
          titleAlignment: ListTileTitleAlignment.threeLine,
        ),
      ),
    );
  }
}
