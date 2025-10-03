import 'package:allergyapp/models/font.dart'; // AppTextStyles
import 'package:allergyapp/screens/onboarding_screens.dart'; // Destination screen
import 'package:allergyapp/screens/register_screen.dart'; // To get UserRegistrationData
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Add this class definition at the top (or import from a shared file if it exists elsewhere)
class UserRegistrationData {
  final String email;
  final String firstName;
  final String lastName;

  UserRegistrationData({
    required this.email,
    required this.firstName,
    required this.lastName,
  });
}

class PasswordScreen extends StatefulWidget {
  final UserRegistrationData userData;

  const PasswordScreen({super.key, required this.userData});

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  // --- Colors based on RegisterScreen theme ---
  static const Color backgroundColor = Colors.white;
  static const Color primaryAccent = Color(0xFF1E88E5);
  static const Color darkTextColor = Color(0xFF424242);

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- Supabase Registration Logic ---
  Future<void> _handleRegister() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // 1. Local Validation
    if (password.length < 6) {
      setState(
        () => _errorMessage = 'Password must be at least 6 characters long.',
      );
      return;
    }
    if (password != confirmPassword) {
      setState(() => _errorMessage = 'Passwords do not match.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // 2. Execute Supabase Sign Up
      final response = await Supabase.instance.client.auth.signUp(
        email: widget.userData.email,
        password: password,
        // Pass first and last name as user metadata (for profile storage later)
        data: {
          'first_name': widget.userData.firstName,
          'last_name': widget.userData.lastName,
        },
      );

      if (!mounted) return;

      if (response.user != null) {
        // ✅ Registration success → move to onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );
      } else {
        // Should be caught by AuthException, but included for safety
        setState(
          () => _errorMessage = 'Registration failed. Please try again.',
        );
      }
    } on AuthException catch (e) {
      setState(() => _errorMessage = 'Registration failed: ${e.message}');
    } catch (e) {
      setState(() => _errorMessage = 'Unexpected error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Helper function for text field decoration (copied from RegisterScreen)
  InputDecoration _buildInputDecoration({required String hint}) {
    const Color enabledBorderColor = Color(0xFFD0D0D0);
    const Color primaryAccent = Color(0xFF1E88E5);

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
        onPressed: _isLoading ? null : _handleRegister,
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
            : Text(
                "Create Account", // Changed text to final action
                style: AppTextStyles.buttonText,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
                // Back Button (simple back arrow)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: darkTextColor),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 20),

                // --- Header ---
                Text(
                  "Choose a Secure Password",
                  style: AppTextStyles.heading.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  "You are registering as ${widget.userData.email}",
                  style: AppTextStyles.subheading.copyWith(fontSize: 16),
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

                // --- Password Input ---
                _buildFieldLabel('Password'),
                const SizedBox(height: 5),
                TextField(
                  controller: _passwordController,
                  textInputAction: TextInputAction.next,
                  decoration: _buildInputDecoration(hint: 'Create a password'),
                  obscureText: true,
                  style: AppTextStyles.input,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 25.0),
                  child: Text(
                    'Password must be at least 6 characters long.',
                    style: AppTextStyles.subheading.copyWith(
                      fontSize: 14,
                      color: darkTextColor.withOpacity(0.6),
                    ),
                  ),
                ),

                // --- Confirm Password Input ---
                _buildFieldLabel('Confirm Password'),
                const SizedBox(height: 5),
                TextField(
                  controller: _confirmPasswordController,
                  textInputAction: TextInputAction.done,
                  decoration: _buildInputDecoration(
                    hint: 'Confirm your password',
                  ),
                  obscureText: true,
                  style: AppTextStyles.input,
                ),
                const SizedBox(height: 40),

                // --- Final Registration Button ---
                _buildGradientButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
