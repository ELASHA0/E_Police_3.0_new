import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../resources/AppAssets.dart';
import '../../../resources/AppColor.dart';
import 'AuthController.dart';

class OtpVerificationScreen extends StatelessWidget {
  OtpVerificationScreen({super.key});

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
                      Image(
                        image: ePoliceLogo,
                        height: 140,
                        fit: BoxFit.contain,
                      ),

                      Text(
                        "OTP Verification ",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.06,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 2),

                      Text(
                        "Enter the 6-digit sent to your mobile number",
                        style: GoogleFonts.montserrat(
                          fontSize: width * 0.03,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: authController.otpController
                              .map((c) => digitBox(c, context))
                              .toList(),
                        );
                      }),

                      SizedBox(height: 50),
                      SizedBox(
                        width: size.width * 0.47,
                        height: 47,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColor.dashboard,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Verify",
                            style: GoogleFonts.montserrat(
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Obx(() => authController.isResending.value ? Text("Resending OTP in ${authController.resendCountdown.value}s...",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.03,
                          color: Colors.black,

                      ),
                      ):

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive OTP?",
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.03,
                              color: Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                              authController.resendOtp(context),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap
                          ),
                            child: Text(
                              "Resend",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.03,
                                color: MyColor.dashboardBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: height * 0.02),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  authController.clearFields();
                  Get.back();
                },

                child: Text(
                  "Back To Login",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: MyColor.dashboardBlue,
                    fontWeight: FontWeight.bold,

                    fontSize: width * 0.035,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget digitBox(TextEditingController getotpcontroller, BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width * 0.01),
    child: Container(
      width: width * 0.12,
      height: width * 0.12,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: MyColor.dashboard, width: 2),
      ),
      child: Center(
        child: TextField(
          controller: getotpcontroller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          maxLength: 1,
          style: TextStyle(fontSize: width * 0.04),

          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            //contentPadding: EdgeInsets.all(10),
            isCollapsed: true,
          ),
        ),
      ),
    ),
  );
}
