import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../resources/AppAssets.dart';
import '../../../resources/AppColor.dart';
import 'package:google_fonts/google_fonts.dart';

import 'AuthController.dart';
import '../RegistrationController.dart';
import '../RegistrationForm.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // Change this to stateless
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      SizedBox(
                        height: 180,
                        child: Column(
                          children: [
                            Image(
                              image: ePoliceLogo,
                              height: 140,
                              fit: BoxFit.contain,
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    " Login ",
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: width * 0.06,
                                      color: MyColor.dashboard,
                                    ),
                                  ),

                                  Text(
                                    "to your account",
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: width * 0.06,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: authController.mobileNumberController,
                     /*   onChanged: (value) {
                          authController.hasError.value = false;
                        },*/
                        autofocus: false,
                        keyboardType: TextInputType.phone,
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                              color: MyColor.dashboardBlue,
                            ),
                          ),

                          labelText: 'Enter your mobile number',
                        ),
                      ),
                      SizedBox(height: 4),
                      // for now the Backend don't have check for mobile number
                    /*  Obx(
                        () => authController.hasError.value
                            ? Padding(
                                padding: EdgeInsets.only(top: 6),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: width * 0.04,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "Please enter a correct mobile Number",
                                      style: GoogleFonts.montserrat(
                                        fontSize: width * 0.03,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),*/
                      SizedBox(height: 50),
                      SizedBox(
                        width: size.width * 0.47,
                        height: 47,
                        child: ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            authController.login(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColor.dashboard,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),

                          child: Text(
                            "Login",
                            style: GoogleFonts.montserrat(
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have a account? Tap to ",
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.03,
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(onTap: () {
                            Get.delete<RegistrationController>();
                            Get.to(Registrationform());
                          }, child:

                          Text(
                            "Sign up",
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.03,
                              color: MyColor.dashboardBlue,
                            ),
                          ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: height * 0.02),
              child: Text(
                "AI - Driven Smart Police Management App ",
                style: TextStyle(color: Colors.grey, fontSize: width * 0.04),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
