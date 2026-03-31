import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'Screens/Login/AuthController.dart';
import 'Screens/Login/LoginScreen.dart';
import 'Screens/Login/OTPScreen.dart';
import 'Screens/RegistrationForm.dart';
import 'Screens/Login/SplashScreen.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  Get.put(AuthController(), permanent: true);

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'E Police ',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      //initialRoute : initalRoute,
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/otp', page: () => OtpVerificationScreen()),
    GetPage(name: '/register', page: () => Registrationform()),



    ]
    );
  }
}


