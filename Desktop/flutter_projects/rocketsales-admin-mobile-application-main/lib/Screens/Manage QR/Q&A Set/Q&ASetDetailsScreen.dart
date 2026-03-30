import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsales_admin/resources/my_colors.dart';

import 'Q&ACreateEdit/Q&ACreateEditController.dart';
import 'Q&ACreateEdit/Q&ACreateScreen.dart';
import 'QRQuestionSetController.dart';
import 'QuestionSetModel.dart';

class QandADetailScreen extends StatelessWidget {
  final QuestionSetModel questionSetModel;

  QandADetailScreen({super.key, required this.questionSetModel});

  final QRQuestionSetController controller = Get.find<QRQuestionSetController>();
  final CreateEditQuestionSetController QAcontroller = Get.put(CreateEditQuestionSetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Q/A Detail"),
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(QACreateScreen(questionSet: questionSetModel,));
        },
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
        child: const Icon(Icons.edit),
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
                  questionSetModel.title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: questionSetModel.questions.map((question) {
                    return buildQuestionWidget(context, question);
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  Widget buildQuestionWidget(BuildContext context, Question question) {
    return Padding(
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${question.questionNo} : ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              // 👈 ensures long text wraps
              child: Text(
                question.text,
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(onPressed: () {
              QAcontroller.editQuestion(context, question, questionSetModel.id);
            },
                child: Icon(Icons.edit),
                // style: FilledButton.styleFrom(
                //   backgroundColor: MyColor.dashbord,
                //   foregroundColor: Colors.white,
                // )
            ),
            IconButton(
                onPressed: () {
                  controller.deleteQuestionDialog(context, questionSetModel.id, question.questionNo);
                },
                color: Colors.red,
                icon: Icon(Icons.delete_outline_outlined))
          ],
        ),
      ),
    );
  }
}
