import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Screens
import 'package:allergyapp/screens/register_screen.dart';
import 'package:allergyapp/screens/onboarding_screens.dart';
import 'package:allergyapp/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Supabase instead of Firebase
  await Supabase.initialize(
    url: 'https://ipbsnpaodtibxzjxyoqu.supabase.co', // your project URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlwYnNucGFvZHRpYnh6anh5b3F1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg0NTE1NDMsImV4cCI6MjA3NDAyNzU0M30.neJiYIJzVuK16p_fqzArGNGmlZ9ko0gkyDgcO_6J92k', // get this from teammate / Supabase dashboard
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Allergy App',
      // ✅ You can decide your starting screen here
      home: RegisterScreen(),
      // Or, for onboarding: home: OnboardingScreen(),
      // Or, for login: home: LoginScreen(),
    );
  }
}
