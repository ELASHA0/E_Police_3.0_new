import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../resources/AppAssets.dart';

class SplashScreen extends StatefulWidget  {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen>  {



  @override

  void initState(){
    super.initState();
    _navigateToLogin();
  }

  void  _navigateToLogin()  async {
    await Future.delayed(const Duration(seconds: 3));
    //
    Get.offAllNamed('/login');
  }

  Widget build(BuildContext context) {
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
