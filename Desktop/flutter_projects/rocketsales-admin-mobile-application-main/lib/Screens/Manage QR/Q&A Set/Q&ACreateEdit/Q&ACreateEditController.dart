import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rocketsales_admin/Screens/Manage%20QR/Q&A%20Set/QRQuestionSetController.dart';

import '../../../../TokenManager.dart';
import '../../../../resources/my_colors.dart';
import '../QuestionSetModel.dart';

class CreateEditQuestionSetController extends GetxController {
  /// Dynamic QuestionSetModel Descriptions
  var questionsControllers = <QuestionField>[].obs;
  final TextEditingController title = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final tillDate = DateTime.now().obs;

  /// Address
  TextEditingController questionTextController = TextEditingController();
  TextEditingController editQuestionSetModelController = TextEditingController();

  final QRQuestionSetController controller = Get.find<QRQuestionSetController>();

  void addQuestionSetField({String? text, String? id}) {
    questionsControllers.add(
      QuestionField(controller: TextEditingController(text: text), id: id),
    );
  }

  void removeQuestionSetField(int index) {
    if (questionsControllers.length > 1) {
      questionsControllers.removeAt(index);
    }
  }

  Future<void> uploadQuestionSet(BuildContext context) async {
    showLoading(context);
    try {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/qrcode/questionset');

      final token = await TokenManager.getToken();

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      final companyId = decodedToken['companyId'];
      final branchId = decodedToken['branchId'];
      final supervisorId = decodedToken['id'];

      // 👇 build structured questions with number + text
      final questionsPayload = List.generate(
        questionsControllers.length,
            (index) => {
          "questionNo": index + 1,
          "text": questionsControllers[index].controller.text,
        },
      );

      print("==========>>>>>>>> ${title.text}");

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'companyId': companyId,
          'branchId': branchId,
          'supervisorId': supervisorId,
          "title": title.text,
          "questions": questionsPayload,
        }),
      );

      if (response.statusCode == 201) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        controller.getQRSets();
        Get.delete<CreateEditQuestionSetController>(force: true);
        Get.snackbar("Success", "Question set submitted successfully");
      } else {
        Navigator.of(context).pop();
        print("❌ Question set submission Failed: ${response.body}");
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      Navigator.of(context).pop();
      print("⚠️ Exception in posting Question set: $e");
      Get.snackbar("Exception", e.toString());
    }
  }


  void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: MyColor.dashbord),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> updateQuestion(BuildContext context, Question question, String questionSetId) async {
    showLoading(context);
    try {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/qrcode/question/$questionSetId');

      final token = await TokenManager.getToken();

      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'question': {
            "questionNo": question.questionNo,
            "text": questionTextController.text
          },
        })
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        questionTextController.clear();
        controller.getQRSets();
        Get.snackbar("Success", "Question edited");
      } else {
        Navigator.of(context).pop();
        print("❌ Question submission Failed: ${response.body}");
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      // isLoading.value = false;
      Navigator.of(context).pop();
      print("⚠️ Exception in posting Questions: $e");
      Get.snackbar("Exception", e.toString());
    }
  }

  void editQuestion(BuildContext context, Question question, String questionSetId) {
    questionTextController.text = question.text;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Edit question",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey, // 👈 form key
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ✅ Box Name field with validator
                  TextFormField(
                    controller: questionTextController,
                    decoration: const InputDecoration(
                      labelText: "Question",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Question is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 7),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                questionTextController.clear();
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: MyColor.dashbord),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: MyColor.dashbord,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  updateQuestion(context, question, questionSetId);
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateQuestionSet(BuildContext context, String questionSetId) async {
    showLoading(context);
    try {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/qrcode/questionset/$questionSetId');
      final token = await TokenManager.getToken();
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);

      final companyId = decodedToken['companyId'];
      final branchId = decodedToken['branchId'];
      final supervisorId = decodedToken['id'];

      // final questionsPayload = List.generate(
      //   questionsControllers.length,
      //       (index) => {
      //
      //     "_id": questionsControllers[index].id, // 👈 include existing ID if available
      //     "questionNo": index + 1,
      //     "text": questionsControllers[index].controller.text,
      //   },
      // );

      final questionsPayload = List.generate(
        questionsControllers.length,
            (index) {
          final map = {
            "questionNo": index + 1,
            "text": questionsControllers[index].controller.text,
          };

          final id = questionsControllers[index].id;
          if (id != null) {
            map["_id"] = id; // safe, only added when not null
          }

          return map;
        },
      );



      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'companyId': companyId,
          'branchId': branchId,
          'supervisorId': supervisorId,
          // "title": title.text,
          "questions": questionsPayload,
        }),
      );

      print("payLoad ========>>>>>>>> ${questionsPayload}");

      Navigator.of(context).pop(); // dismiss loading
      if (response.statusCode == 200) {
        print("questionsetId = $questionSetId payload ==========>>>>>>>>>>>>>> $questionsPayload");
        Navigator.of(context).pop();
        controller.getQRSets();
        Get.delete<CreateEditQuestionSetController>(force: true);
        Get.snackbar("Success", "Question set updated successfully");
        Navigator.of(context).pop();
      } else {
        Get.snackbar("Error", response.body);
        print("errrorrrrrr ${response.body}");
      }
    } catch (e) {
      Navigator.of(context).pop();
      Get.snackbar("Exception", e.toString());
    }
  }
}

class QuestionField {
  final TextEditingController controller;
  final String? id; // null for new questions

  QuestionField({required this.controller, this.id});
}
