import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsales_admin/resources/my_colors.dart';

import 'UserManagementController.dart';

class CreateEditUserScreen extends StatefulWidget {

  CreateEditUserScreen({super.key});

  @override
  State<CreateEditUserScreen> createState() => _CreateEditUserScreenState();
}

class _CreateEditUserScreenState extends State<CreateEditUserScreen> {

  final _formKey = GlobalKey<FormState>();

  final UserManagementController controller = Get.put(UserManagementController());

  late bool isEdit;
  late String? salesmanId;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};
    isEdit = args['isEdit'] ?? false;
    salesmanId = args['salesmanId'];

    controller.salesmanId.value = salesmanId ?? '';

    // Pre-fill fields if editing
    if (isEdit) {
      controller.nameController.text = args['salesmanName'] ?? '';
      controller.emailController.text = args['salesmanEmail'] ?? '';
      controller.phoneController.text = args['salesmanPhone'] ?? '';
      controller.userNameController.text = args['username'] ?? '';
      controller.passwordController.text = args['password'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit User" : "Create User"),
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildLabel("Salesman Name:"),
                TextFormField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(
                    // labelText: "Address",
                    hint: Text("Salesman Name", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Salesman Name is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                buildLabel("Salesman Email:"),
                TextFormField(
                  controller: controller.emailController,
                  decoration: const InputDecoration(
                    // labelText: "Address",
                    hint: Text("Salesman Email", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  // validator: (value) {
                  //   if (value == null || value.trim().isEmpty) {
                  //     return "Salesman Email is required";
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 10),
                buildLabel("Salesman Phone:"),
                TextFormField(
                  controller: controller.phoneController,
                  decoration: const InputDecoration(
                    // labelText: "Address",
                    hint: Text("Salesman Phone", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  // validator: (value) {
                  //   if (value == null || value.trim().isEmpty) {
                  //     return "Salesman Phone is required";
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 10),
                buildLabel("Username:"),
                TextFormField(
                  controller: controller.userNameController,
                  decoration: const InputDecoration(
                    // labelText: "Address",
                    hint: Text("Username", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Username is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                buildLabel("Password:"),
                TextFormField(
                  controller: controller.passwordController,
                  decoration: const InputDecoration(
                    // labelText: "Address",
                    hint: Text("Password", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Password is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (isEdit) {
                          controller.updateUser(context);
                        } else {
                          controller.uploadUser(context);
                        }
                      }
                    },
                    child: Text(isEdit ? "Update" : "Submit"),
                  ),
                ),
                if (isEdit)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                      onPressed: () {
                        controller.deleteConfirmation(context);
                      },
                      child: Text("Delete User"),
                    ),
                  )
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
