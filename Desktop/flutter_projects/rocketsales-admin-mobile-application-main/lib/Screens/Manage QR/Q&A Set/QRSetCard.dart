import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rocketsales_admin/Screens/Manage%20QR/Q&A%20Set/QRQuestionSetController.dart';

import '../../../resources/my_colors.dart';
import 'Q&ASetDetailsScreen.dart';
import 'QuestionSetModel.dart';

class QuestionSetCard extends StatelessWidget {
  final QuestionSetModel questionSet;

  QuestionSetCard(
      {super.key,
        required this.questionSet});

  final QRQuestionSetController controller = Get.find<QRQuestionSetController>();

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
          leading: const Icon(
            Icons.qr_code_2,
            size: 60,
          ),
          title: Text(
            questionSet.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("${questionSet.questions.length.toString()} Questions"),
          trailing: IconButton(
              onPressed: () {
                controller.deleteQAdialog(context, questionSet.id);
              },
              color: Colors.red,
              icon: Icon(Icons.delete_outline_outlined)),
          titleAlignment: ListTileTitleAlignment.threeLine,
        ),
      ),
    );
  }
}
