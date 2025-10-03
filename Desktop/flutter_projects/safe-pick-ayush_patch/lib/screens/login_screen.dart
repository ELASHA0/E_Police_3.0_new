import 'package:allergyapp/models/auth_service.dart';
import 'package:allergyapp/screens/onboarding_screens.dart';
import 'package:allergyapp/screens/register_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:allergyapp/models/font.dart'; // AppTextStyles
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  // --- Colors based on the desired visual theme ---
  static const Color backgroundColor = Colors.white; // White background
  static const Color primaryAccent = Color(
    0xFF1E88E5,
  ); // Bright blue title/link
  static const Color darkTextColor = Color(0xFF424242); // Text color
  static const Color lightFieldFill = Colors.white; // Changed to pure white

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await _authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (response != null && response.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );
      } else {
        setState(() {
          _errorMessage = 'Login failed. Please check your credentials.';
        });
      }
    } on AuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Unexpected error: $e';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Helper function for minimal text field decoration
  InputDecoration _buildInputDecoration({required String hint}) {
    // Subtle border color (almost invisible)
    const Color enabledBorderColor = Color(0xFFE0E0E0);
    const Color focusedBorderColor = Color(
      0xFFB0B0B0,
    ); // Slightly darker on focus

    return InputDecoration(
      hintText: hint,
      // Hint text style matching the gray text inside the box
      hintStyle: AppTextStyles.input.copyWith(
        color: darkTextColor.withOpacity(0.5),
      ),

      // Fill settings
      filled: true,
      fillColor: lightFieldFill, // Use white fill
      // Border styling (Minimalist border appearance)
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: enabledBorderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: focusedBorderColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: enabledBorderColor, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 18.0,
        horizontal: 15.0,
      ),
      // Since the label is a separate widget, disable floating label behaviour
      floatingLabelBehavior: FloatingLabelBehavior.never,
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
        onPressed: _isLoading ? null : _handleLogin,
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
            : Text("Sign In", style: AppTextStyles.buttonText),
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
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- Logo (Retained as requested) ---
                Image.asset(logoAssetPath, height: 120, fit: BoxFit.contain),
                const SizedBox(height: 10),

                // --- 1. Header: Title and Subheading ---
                Text("Welcome Back!", style: AppTextStyles.heading),
                const SizedBox(height: 8),
                Text(
                  "Sign in to your Safe Pick account",
                  style: AppTextStyles.subheading,
                  textAlign: TextAlign.center,
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

                // Align field content left
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- 2. Email Input ---
                      _buildFieldLabel('Email Address'),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: _buildInputDecoration(
                          hint: "Enter your email",
                        ),
                        style: AppTextStyles.input,
                      ),
                      const SizedBox(height: 25),

                      // --- 3. Password Input ---
                      _buildFieldLabel('Password'),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _passwordController,
                        textInputAction: TextInputAction.done,
                        decoration: _buildInputDecoration(
                          hint: "Enter your password",
                        ),
                        obscureText: true,
                        style: AppTextStyles.input,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // --- 4. Login Button (Gradient) ---
                _buildGradientButton(),
                const SizedBox(height: 40),

                // --- Divider (optional line) ---
                const Divider(
                  color: Color(0xFFE0E0E0),
                  height: 1,
                  thickness: 1,
                ),
                const SizedBox(height: 25),

                // --- 5. Footer Links ---
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Don’t have an account? ",
                    style: AppTextStyles.subheading.copyWith(
                      fontSize: 14,
                      color: darkTextColor.withOpacity(0.7),
                    ),
                    children: [
                      TextSpan(
                        text: "Create one here",
                        style: AppTextStyles.linkText,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Back to Home Link
                GestureDetector(
                  onTap: () {
                    // Navigate back or to a main/home screen if one exists before login
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '← Back to Home',
                      style: AppTextStyles.linkText.copyWith(
                        color: darkTextColor.withOpacity(0.7),
                        decoration: TextDecoration.none,
                        fontSize: 14,
                      ),
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
