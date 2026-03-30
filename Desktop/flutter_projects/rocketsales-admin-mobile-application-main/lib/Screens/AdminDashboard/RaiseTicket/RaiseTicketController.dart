import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../TokenManager.dart';
import '../../../resources/my_colors.dart';
import 'TicketModel.dart';
import 'TicketTypeModel.dart';

class RaiseTicketController extends GetxController {
  final RxList<TicketModel> tickets = <TicketModel>[].obs;
  final RxList<TicketTypeModel> ticketTypes = <TicketTypeModel>[].obs;
  final RxBool isLoading = true.obs;

  // final RxBool areProductsLoading = false.obs;
  final RxString error = ''.obs;
  final dateTimeFilter = ''.obs;
  final searchString = ''.obs;
  final salesmanId = ''.obs;
  final RxString selectedTag = "".obs;
  final RxBool isLoadingTicketType = false.obs;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController ticketDescription = TextEditingController();

  RxInt page = 2.obs;
  RxBool isMoreCardsAvailable = false.obs;

  @override
  void onInit() {
    getTickets();
    super.onInit();
  }

  void showInvoiceDialog(BuildContext context) {
    final TextEditingController sgstController = TextEditingController();
    final TextEditingController cgstController = TextEditingController();
    final TextEditingController discountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Enter Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: sgstController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "SGST",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: cgstController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "CGST",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: discountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Discount",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: MyColor.dashbord),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: MyColor.dashbord,
                  foregroundColor: Colors.white),
              onPressed: () {
                String sgst = sgstController.text;
                String cgst = cgstController.text;
                String discount = discountController.text;

                // 👉 Do something with values
                print("SGST: $sgst, CGST: $cgst, Discount: $discount");

                Navigator.pop(context);
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
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

  String formattedDate(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);
    return DateFormat('dd/MM/yy').format(dateTime);
  }

  String formattedTime(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);

    // Format to hh:mm a (12-hour format with AM/PM)
    return DateFormat('hh:mm a').format(dateTime);
  }

  void getTickets() async {
    isLoading.value = true;
    isMoreCardsAvailable.value = false;
    page.value = 2;
    try {
      final token = await TokenManager.getToken();

      print("user token ======>>>> $token");

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/raiseticket?&limit=10${dateTimeFilter.value}&search=${searchString.value}&status=${selectedTag.value}');

      print("url ======>>>>> $url");
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        final List<dynamic> dataList = jsonData['tickets'];
        print("expenseList ========>>>>>> $dataList");
        final expenseList =
        dataList.map((item) => TicketModel.fromJson(item)).toList();
        tickets.assignAll(expenseList);
      } else {
        tickets.clear();
        Get.snackbar("Error connect",
            "Couldn't get Tickets (Code: ${response.statusCode})");
        print("errrrrrr ========>>>>>>>>${response.body}");
      }
    } catch (e) {
      tickets.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get Tickets");
      print("errrrrrr ========>>>>>>>>${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void getMoreTicketsCards() async {
    print('fetching more');
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/raiseticket?page=$page&limit=10$dateTimeFilter&search=$searchString&status=${selectedTag.value}');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // print(jsonData);
        final List<dynamic> dataList = jsonData['tickets'];
        // final List<dynamic> dataList = jsonData;
        final expenseList =
        dataList.map((item) => TicketModel.fromJson(item)).toList();
        // page.value++;
        if (expenseList.length < 1) {
          isMoreCardsAvailable.value = false;
          // page.value = 1;
        } else {
          page.value++;
        }
        tickets.addAll(expenseList);
      } else {
        tickets.clear();
        Get.snackbar("Error connect",
            "Couldn't get tickets (Code: ${response.statusCode})");
      }
    } catch (e) {
      tickets.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get Tickets");
    }
  }


  Future <void> getTicketTypes() async {
    isLoadingTicketType.value = true;
    try {
      final token = await TokenManager.getToken();

      print("user token ======>>>> $token");

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/ticket/type');

      print("url ======>>>>> $url");
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        final List<dynamic> dataList = jsonData['ticketTypes'];
        print("ticketTypes ========>>>>>> $dataList");
        final ticketTypesList =
        dataList.map((item) => TicketTypeModel.fromJson(item)).toList();
        ticketTypes.assignAll(ticketTypesList);
      } else {
        ticketTypes.clear();
        Get.snackbar("Error connect",
            "Couldn't get ticket types (Code: ${response.statusCode})");
      }
    } catch (e) {
      ticketTypes.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get ticket types");
    } finally {
      isLoadingTicketType.value = false;
    }
  }

  Future<void> uploadTicket(BuildContext context) async {
    showLoading(context);
    try {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/raiseticket');

      final token = await TokenManager.getToken();

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      final companyId = decodedToken['companyId'];
      final branchId = decodedToken['branchId'];
      final supervisorId = decodedToken['id'];

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'type': selectedTag.value,
          'description': ticketDescription.text,
          'companyId': companyId,
          'branchId': branchId,
          'supervisorId': supervisorId,
        }),
      );

      if (response.statusCode == 201) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        ticketDescription.clear();
        selectedTag.value = "";
        getTickets();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ticket raised!'),
          ),
        );
      } else {
        Navigator.of(context).pop();
        print("❌ Feedback submission Failed: ${response.body}");
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      // isLoading.value = false;
      Navigator.of(context).pop();
      print("⚠️ Exception in posting feedback: $e");
      Get.snackbar("Exception", e.toString());
    }
  }


  Future <void> createNewTicket(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // make sure types are fetched
        if (ticketTypes.isEmpty && !isLoadingTicketType.value) {
          getTicketTypes();
        }

        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Enter Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey, // 👈 form key
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ✅ Description field
                  TextFormField(
                    controller: ticketDescription,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Description is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // ✅ Dropdown for Ticket Types
                  Obx(() {
                    if (isLoadingTicketType.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (ticketTypes.isEmpty) {
                      return const Text("No ticket types available");
                    }
                    return DropdownButtonFormField<String>(
                      value: selectedTag.value.isNotEmpty
                          ? selectedTag.value
                          : null,
                      decoration: const InputDecoration(
                        labelText: "Select Ticket Type",
                        border: OutlineInputBorder(),
                      ),
                      items: ticketTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type.type, // assuming TicketTypeModel has `id`
                          child: Text(type.type), // assuming TicketTypeModel has `type`
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          selectedTag.value = value;
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select a ticket type";
                        }
                        return null;
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                ticketDescription.clear();
                selectedTag.value = "";
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
                  // ✅ Use selectedTag.value here
                  print("Description: ${ticketDescription.text}");
                  print("TicketTypeId: ${selectedTag.value}");

                  uploadTicket(context);
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}
