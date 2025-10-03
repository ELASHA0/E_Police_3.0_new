import 'package:flutter/material.dart';
import 'scan_screen.dart';
import 'allergy_profile_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1; // default to 'capture' section
  List<String> _userAllergies = []; // Shared allergies state

  // Method to update allergies
  void _updateAllergies(List<String> allergies) {
    setState(() {
      _userAllergies = allergies;
    });
  }

  List<Widget> get _pages => [
    AllergyProfileScreen(
      userAllergies: _userAllergies,
      onAllergiesUpdated: _updateAllergies,
    ),
    ScanScreen(userAllergies: _userAllergies),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Capture',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
