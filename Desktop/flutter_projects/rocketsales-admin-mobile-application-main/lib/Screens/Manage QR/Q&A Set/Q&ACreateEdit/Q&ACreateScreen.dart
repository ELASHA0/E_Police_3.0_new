import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:rocketsales_admin/Screens/ManageShop/ManageShopsScreen.dart';

import '../../../../resources/my_colors.dart';
import '../QuestionSetModel.dart';
import 'Q&ACreateEditController.dart';

class QACreateScreen extends StatelessWidget {
  final QuestionSetModel? questionSet; // optional, null for "add", non-null for "edit"

  QACreateScreen({super.key, this.questionSet});

  final CreateEditQuestionSetController controller = Get.put(CreateEditQuestionSetController(), permanent: true);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Pre-fill controller if editing
    if (questionSet != null && controller.title.text.isEmpty) {
      controller.title.text = questionSet!.title;
      controller.questionsControllers.clear();
      for (var q in questionSet!.questions) {
        controller.addQuestionSetField(text: q.text, id: q.id);
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(questionSet == null ? "Add Question Set" : "Edit Question Set"),
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildLabel("Title:"),
                TextFormField(
                  controller: controller.title,
                  decoration: const InputDecoration(
                    hint: Text(
                      "Set Title",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Title is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                buildLabel("Questions:"),
                Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.questionsControllers.length,
                  itemBuilder: (context, index) {
                    final qField = controller.questionsControllers[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: qField.controller,
                              decoration: InputDecoration(
                                hint: Text(
                                  "Question ${index + 1}",
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Question is required";
                                }
                                return null;
                              },
                            ),
                          ),
                          if (controller.questionsControllers.length > 1 && qField.id == null)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => controller.removeQuestionSetField(index),
                            ),
                        ],
                      ),
                    );
                  },
                )),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: controller.addQuestionSetField,
                    icon: const Icon(Icons.add),
                    label: const Text("Add Another Question"),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (questionSet == null) {
                          controller.uploadQuestionSet(context);
                        } else {
                          controller.updateQuestionSet(context, questionSet!.id);
                        }
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 5),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}
