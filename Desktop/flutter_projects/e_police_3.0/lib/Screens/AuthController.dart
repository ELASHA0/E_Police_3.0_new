import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {

  final mobileNumberController = TextEditingController();
  RxList<TextEditingController> otpController =  List.generate(6,(_) => TextEditingController()).obs;


  RxString mobile = ''.obs;
  RxString  getOtp = ''.obs;

  //var hasError = false.obs;


  void clearFields(){
    mobileNumberController.clear();
    getOtp.value = '';
  }
  var isResending = false.obs;
  var resendCountdown = 0.obs;

  void resendOtp(BuildContext context) async{
    isResending.value = true;
    resendCountdown.value = 2;

    Timer.periodic(const Duration(seconds:1) ,(timer ) {
      if (resendCountdown.value == 0) {
        timer.cancel();
        isResending.value = false;
      }
      else {
        resendCountdown.value--;
      }
    } );
    await login(context);
  }



  Future<void> login(BuildContext context) async {
    String url = "${dotenv.env['BASE_URL']}/auth/send-otp";
    try {
     // hasError.value = false;


      print('Calling URL: $url');
      print('BASE_URL: ${dotenv.env['BASE_URL']}');
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mobile': mobileNumberController.text.trim()}),
      );
      var rawJsonData = jsonDecode(response.body);
      var dataOtp = rawJsonData['data'];
      print("Login Response : ${dataOtp}");

      if (response.statusCode == 200) {
        if (rawJsonData['message'] == "OTP sent successfully") {
           getOtp.value = rawJsonData['otp'].toString();

           for(int i = 0; i< getOtp.value.length ; i++){
             otpController[i].text =  getOtp.value[i];
           }

          print("Got otp =============> ${getOtp}");
          Text("Got otp ========> $getOtp.value ");
          Get.toNamed('/otp');
        }

      }
    } catch (e) {
      //hasError.value = true;
      print("Login Error: $e");
      print('Error occurred');
    }
  }
}
