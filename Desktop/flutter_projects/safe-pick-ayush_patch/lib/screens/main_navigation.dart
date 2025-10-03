import 'package:allergyapp/screens/allergy_profile_screen.dart';
import 'package:allergyapp/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'scan_screen.dart'; // Your Scan/Home screen

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  List<String> _userAllergies = []; // Shared allergies state

  // Define your consistent color palette based on "Tides" scheme
  static const Color backgroundColor = Color(
    0xFFE9EBED,
  ); // Lightest color from Tides
  static const Color primaryAccent = Color(
    0xFF006F98,
  ); // Darkest blue from Tides
  static const Color secondaryAccent = Color(0xFF1ABBEF); // Mid-blue from Tides
  static const Color lightBlue = Color(0xFF7FD2FD); // Light blue from Tides
  static const Color textColor = Color(
    0xFF003049,
  ); // A darker, complementary blue/navy for text
  static const Color lightTextColor =
      Colors.white; // Pure white for text on primary accent background

  // Method to update allergies from child screens
  void _updateAllergies(List<String> allergies) {
    setState(() {
      _userAllergies = allergies;
    });
  }

  List<Widget> get _screens => [
    AllergyProfileScreen(
      userAllergies: _userAllergies,
      onAllergiesUpdated: _updateAllergies,
    ),
    ScanScreen(userAllergies: _userAllergies),
    ProfileScreen(userAllergies: _userAllergies),

    // Optional: Add settings screen
    // const SettingsScreen(), // Uncomment if you add SettingsScreen to _screens list
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Use the new background color
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: backgroundColor, // Light background for the bar (E9EBED)
          boxShadow: [
            BoxShadow(
              color: textColor.withOpacity(0.15), // Use textColor for shadow
              spreadRadius: 0,
              blurRadius: 15,
              offset: const Offset(0, -5), // Shadow coming from the bottom
            ),
          ],
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(25), // Rounded top corners for a modern look
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(
              25,
            ), // Apply the same rounded corners to the clipped content
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (newIndex) {
              setState(() {
                _currentIndex = newIndex;
              });
            },
            selectedItemColor:
                primaryAccent, // Use primary accent for selected item
            unselectedItemColor: secondaryAccent.withOpacity(
              0.6,
            ), // Secondary accent for unselected
            backgroundColor:
                backgroundColor, // Ensure consistent background inside ClipRRect
            elevation: 0, // Elevation is handled by the Container's boxShadow
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w700, // Make selected label even bolder
              fontSize: 13, // Slightly increase font size for selected
              height: 1.5, // Adjust line height for better spacing
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight
                  .w500, // A bit more weight than regular for unselected
              fontSize: 12, // Standard font size for unselected
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(
                    bottom: 4.0,
                  ), // Add padding below icon
                  child: Icon(
                    Icons.no_food_outlined,
                    size: 26,
                  ), // Slightly larger icon
                ),
                label: 'Allergies',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 28,
                  ), // Prominent scan icon
                ),
                label: 'Scan',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(
                    Icons.person_outline,
                    size: 26,
                  ), // Profile icon
                ),
                label: 'Profile',
              ),

              // Optional: If you add Settings
              // BottomNavigationBarItem(
              //   icon: Padding(
              //     padding: EdgeInsets.only(bottom: 4.0),
              //     child: Icon(Icons.settings, size: 26),
              //   ),
              //   label: 'Settings',
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
