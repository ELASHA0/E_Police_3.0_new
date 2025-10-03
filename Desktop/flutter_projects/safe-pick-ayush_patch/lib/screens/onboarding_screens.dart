import 'package:allergyapp/screens/allergy_profile_screen.dart';
import 'package:allergyapp/screens/main_navigation.dart';
import 'package:flutter/material.dart';
// update your import paths

// Colors (you can move these to your theme file if you already have them)
const Color primaryColor = Color(0xFF4CAF50);
const Color textColor = Colors.black;

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> titles = [
    "Smart Image Analysis",
    "Real-time Allergen Detection",
    "Personalized Protection",
    "Ready to Stay Safe?",
  ];

  final List<String> subtitles = [
    "Upload or scan food label images using your device's camera or file upload.",
    "Instantly identify allergens by comparing extracted ingredients with your personal allergy profile. Get color-coded risk assessments.",
    "Create your custom allergy profile and receive personalized safety recommendations for every product you scan.",
    "Join thousands of users who trust Safe Pick to keep them safe from allergens.",
  ];

  final List<String> images = [
    'assets/images/onboarding_camera.png',
    'assets/images/onboarding_warning.png',
    'assets/images/onboarding_shield.png',
    'assets/images/onboarding_safety.png',
  ];

  void _nextPage() {
    if (_currentPage < titles.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainNavigationScreen()),
      );
    }
  }

  Widget buildPage(int index) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Expanded(
          flex: 3,
          child: Center(
            child: Image.asset(images[index], height: 120, fit: BoxFit.contain),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Text(
                titles[index],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  subtitles[index],
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: titles.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) => buildPage(index),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                titles.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 20 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? primaryColor
                        : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _currentPage == titles.length - 1 ? "Get Started" : "Next",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
