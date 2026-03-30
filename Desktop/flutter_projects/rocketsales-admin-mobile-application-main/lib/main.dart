import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rocketsales_admin/resources/my_colors.dart';
import 'package:rocketsales_admin/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NotificationController.dart';
import 'Screens/AdminDashboard/AdminDashboardScreen.dart';
import 'Screens/Login/LoginPage.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  String initialRoute = (token != null && token.isNotEmpty) ? '/admin' : '/';

  runApp(MyApp(initialRoute: initialRoute));

  // Initialize notification controller (after app is running)
  if (Platform.isIOS || Platform.isMacOS) {
    Get.put(NotificationController(), permanent: true);
  } else {
    await FirebaseMessaging.instance.subscribeToTopic("admin");
  }
}
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final storage = GetStorage();
  List<dynamic> oldNotifications =
      storage.read<List<dynamic>>('notifications') ?? [];

  Map<String, dynamic> newNotification = {
    'title': message.notification?.title ?? '',
    'body': message.notification?.body ?? '',
    'data': message.data,
    'timestamp': DateTime.now().toIso8601String(),
  };

  oldNotifications.add(newNotification);
  storage.write('notifications', oldNotifications);
  print("Notification saved in background: $newNotification");
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({required this.initialRoute});

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rocket Sales',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: MyColor.dashbord, // set your app’s seed color
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColor.dashbord,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontFamily: 'NataSans-Bold', // 👈 change font here
                fontSize: 16,
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: MyColor.dashbord,
              // side: BorderSide(color: MyColor.dashbord),
              textStyle: const TextStyle(
                fontFamily: 'NataSans-Regular', // 👈 for TextButton
                fontSize: 14,
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: MyColor.dashbord,
              textStyle: const TextStyle(
                fontFamily: 'NataSans-Regular', // 👈 for OutlinedButton
                fontSize: 14,
              ),
            ),
          ),
          textTheme: const TextTheme(
            titleMedium: TextStyle(fontFamily: 'NataSans-Bold'),
            titleLarge: TextStyle(fontFamily: 'NataSans-Bold'),
            bodyLarge: TextStyle(fontFamily: 'NataSans-Bold'),
            bodyMedium: TextStyle(fontFamily: 'NataSans-Regular'),
            bodySmall: TextStyle(fontFamily: 'NataSans-Regular'),
          ),
          primaryColor: MyColor.dashbord,
          scaffoldBackgroundColor: Colors.white,
        primarySwatch: createMaterialColor(MyColor.dashbord),
      )
          .copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/admin', page: () => DashboardAdmin()),
      ],
    );
  }
}