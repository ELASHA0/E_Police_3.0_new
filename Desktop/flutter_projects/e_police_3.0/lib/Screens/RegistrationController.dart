import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var gender = ''.obs;

  void clearFields() {
    nameController.clear();
    mobileController.clear();
    passwordController.clear();
    emailController.clear();
    formKey.currentState?.reset();
    gender.value = '';
  }


  String? validateName(String value) {
    // this removes all the white spaces
    if (value
        .trim()
        .isEmpty) return "Name is required";
    if (value
        .trim()
        .length < 3) return "Name must be at least 3 characters";
    return null;
  }

  String? validateMobile(String value) {
    if (value.isEmpty) return "Mobile number is required";
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return "Enter a valid 10 digit number";
    }
    return null;
  }

  String? validateEmail(String value) {
    // this removes all the white spaces
    if (value.isEmpty) return "Email is required";
    if (!RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return "Enter a valid Email- Id ";
    }
    return null;
  }

}


