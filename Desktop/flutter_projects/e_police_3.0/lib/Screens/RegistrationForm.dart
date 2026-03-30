import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../resources/AppAssets.dart';
import '../resources/AppColor.dart';
import 'AddressInfo.dart';
import 'RegistrationController.dart';

class Registrationform extends StatelessWidget {
  final RegistrationController controller = Get.put(RegistrationController());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Registrationform({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.clearFields();
    });

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.delete<RegistrationController>();
            Get.back();
          },
        ),

        title: Text(
          "Registration Form",
          style: TextStyle(fontSize: width * 0.04),
        ),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(height: height * 0.02),

              // Logo
              Center(child: Image(image: ePoliceLogo, height: 120)),

              SizedBox(height: height * 0.02),
              Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Name",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: height * 0.005),

                    TextFormField(
                      controller: controller.nameController,
                      validator: (v) => controller.validateName(v!),

                      //Flutter call this fuction automatically when form is validated
                      //v is whatever the user typed in the filed
                      // v! means "Im sure this isn't null "
                      // it passes the value to validateName in your controller
                      decoration: InputDecoration(
                        hintText: "Enter your Name",
                        hintStyle: TextStyle(fontSize: width * 0.035),
                        prefixIcon: Icon(Icons.person_outline,size: width * 0.055 ),
                        border: const UnderlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: height * 0.005),
                    Text(
                      "Mobile Number",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: height * 0.005),
                    TextFormField(
                      controller: controller.mobileController,
                      validator: (v) => controller.validateMobile(v!),

                      keyboardType: TextInputType.phone,

                      decoration: InputDecoration(
                        hintText: "Enter mobile number",
                        hintStyle: TextStyle(fontSize: width * 0.035),
                        prefixIcon: Icon(Icons.phone,size: width * 0.055 ),
                        border: const UnderlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: height * 0.005),
                    Text(
                      "Email",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: height * 0.005),

                    TextFormField(
                      controller: controller.emailController,
                      validator: (v) => controller.validateEmail(v!),
                      decoration: InputDecoration(
                        hintText: "Enter your Email",
                        hintStyle: TextStyle(fontSize: width * 0.035),
                        prefixIcon: Icon(Icons.email_outlined,size: width * 0.055 ),
                        border: const UnderlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: height * 0.005),
                    Text(
                      "Password",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: height * 0.005),

                    TextFormField(
                      controller: controller.passwordController,

                      decoration: InputDecoration(
                        hintText: "Enter your Password",
                        hintStyle: TextStyle(fontSize: width * 0.035),
                        prefixIcon: Icon(Icons.password_outlined, size: width * 0.055 ),
                        border: const UnderlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: height * 0.005),
                    Text(
                      "Gender",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: height * 0.005),

                    Obx(
                      () => Row(
                        children: [
                          Radio(
                            value: "Male",
                            groupValue: controller.gender.value,
                            onChanged: (value) {
                              controller.gender.value = value.toString();
                            },
                          ),
                          const Text("Male"),
                          const SizedBox(width: 30),
                          Radio(
                            value: "Female",
                            groupValue: controller.gender.value,
                            onChanged: (value) {
                              controller.gender.value = value.toString();
                            },
                          ),
                          const Text("Female"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: SizedBox(
                        width:  width * 0.5,
                        height: height * 0.06,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColor.dashboard,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            final isValid = controller.formKey.currentState!.validate();
                            if (isValid) {
                              print("Name: ${controller.nameController.text}");
                              print("Mobile: ${controller.mobileController
                                  .text}");
                              print("Password: ${controller.passwordController
                                  .text}");
                              print(
                                  "Email: ${controller.emailController.text}");
                              print("Gender: ${controller.gender.value}");
                            }
                            Get.to(AddressInfoScreen());


                          },
                          child: Text(
                            "Next",
                            style: TextStyle(fontSize: width * 0.04, color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    // Have to put gender slection
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
