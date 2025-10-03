import 'package:allergyapp/models/auth_service.dart';
import 'package:allergyapp/screens/login_screen.dart';
import 'package:allergyapp/screens/password_screen.dart'; // Destination screen (Step 2)
import 'package:allergyapp/models/font.dart'; // AppTextStyles
import 'package:allergyapp/models/user_registration_data.dart'; // <-- Add this import
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ------------------------------------------------

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // --- Controllers for Step 1 (User Info) ---
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  // Colors based on the desired visual theme
  static const Color backgroundColor = Colors.white; // Pure white background
  static const Color primaryAccent = Color(
    0xFF1E88E5,
  ); // Bright blue title/link
  static const Color darkTextColor = Color(0xFF424242); // Text color

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Handles validation and navigation to the password screen
  void _handleNavigateToPassword() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();

    // --- Validation Checks for Step 1 ---
    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields.');
      return;
    }

    // Simple email format check
    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _errorMessage = 'Please enter a valid email address.');
      return;
    }

    // Passed validation, navigate to Step 2
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePasswordScreen(
          userData: UserRegistrationData(
            firstName: firstName,
            lastName: lastName,
            email: email,
          ),
        ),
      ),
    );
  }

  // Helper function for text field decoration
  InputDecoration _buildInputDecoration({required String hint}) {
    const Color enabledBorderColor = Color(0xFFD0D0D0);

    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.input.copyWith(
        color: darkTextColor.withOpacity(0.5),
      ),
      filled: true,
      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: enabledBorderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryAccent, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: enabledBorderColor, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 18.0,
        horizontal: 15.0,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
    );
  }

  // Widget for the Social Login Buttons
  Widget _buildSocialButton({
    required String text,
    required Color color,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          elevation: 0,
          textStyle: AppTextStyles.buttonText.copyWith(fontSize: 16),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(text),
      ),
    );
  }

  // Widget for the Gradient Button
  Widget _buildGradientButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF8E2DE2), // Purple end
            Color(0xFF4A00E0), // Darker purple start
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleNavigateToPassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : Text("Create Password", style: AppTextStyles.buttonText),
      ),
    );
  }

  // Helper widget for the field label text
  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: AppTextStyles.inputLabel.copyWith(
        color: darkTextColor,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Logo asset path (retained)
    const String logoAssetPath = 'assets/images/elashasentimage.png';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
              vertical: 40.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 1. Header: Title and Subheading ---
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    logoAssetPath,
                    height: 120, // Retained logo
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Create your account and \nstart staying safe",
                    style: AppTextStyles.subheading.copyWith(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),

                // --- Error message ---
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.red.shade200,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        _errorMessage,
                        style: AppTextStyles.errorText,
                      ),
                    ),
                  ),

                // --- 2. Input Fields ---
                _buildFieldLabel('First Name'),
                const SizedBox(height: 5),
                TextField(
                  controller: _firstNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _buildInputDecoration(hint: 'First name'),
                  style: AppTextStyles.input,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 25),

                _buildFieldLabel('Last Name'),
                const SizedBox(height: 5),
                TextField(
                  controller: _lastNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _buildInputDecoration(hint: 'Last name'),
                  style: AppTextStyles.input,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 25),

                _buildFieldLabel('Email Address'),
                const SizedBox(height: 5),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  decoration: _buildInputDecoration(hint: 'Email Address'),
                  style: AppTextStyles.input,
                ),
                const SizedBox(height: 40),

                // --- 3. Social Login Buttons ---
                _buildSocialButton(
                  text: 'Continue with Facebook',
                  color: const Color(0xFF1877F2), // Facebook Blue
                  icon: Icons.facebook,
                  onPressed: () {
                    // TODO: Implement Facebook sign-in logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Facebook Sign-in tapped!')),
                    );
                  },
                ),
                const SizedBox(height: 15),
                _buildSocialButton(
                  text: 'Continue with Google',
                  color: const Color(0xFF4285F4), // Google Blue
                  icon: Icons.g_mobiledata, // Using a generic G icon
                  onPressed: () {
                    // TODO: Implement Google sign-in logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Google Sign-in tapped!')),
                    );
                  },
                ),
                const SizedBox(height: 25),

                // --- OR Divider ---
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'OR',
                    style: AppTextStyles.subheading.copyWith(
                      color: darkTextColor.withOpacity(0.6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // --- 4. Create Password Button (Step 1 Complete) ---
                _buildGradientButton(),
                const SizedBox(height: 40),

                // --- 5. Footer Link ---
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: AppTextStyles.subheading.copyWith(
                        fontSize: 14,
                        color: darkTextColor.withOpacity(0.7),
                      ),
                      children: [
                        TextSpan(
                          text: "Sign in here",
                          style: AppTextStyles.linkText,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
