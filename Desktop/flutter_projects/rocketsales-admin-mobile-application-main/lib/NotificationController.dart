import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class NotificationController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), _initFCM);
  }

  Future<void> _initFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      print('User declined notifications');
      return;
    }

    // Wait for APNs token
    String? apnsToken = await _waitForApnsToken(messaging);
    print("✅ APNs / FCM Token ready: $apnsToken");

    await messaging.subscribeToTopic("admin");
    print("✅ Subscribed to topic");
  }

  Future<String?> _waitForApnsToken(FirebaseMessaging messaging) async {
    String? token = await messaging.getAPNSToken();

    int attempts = 0;
    while ((token == null || token.isEmpty) && attempts < 10) {
      await Future.delayed(const Duration(seconds: 1));
      token = await messaging.getAPNSToken();
      attempts++;
    }

    // Fallback: listen for refresh if still null
    token ??= await messaging.onTokenRefresh.first;
    return token;
  }
}

