import 'package:allergyapp/models/font.dart';
import 'package:allergyapp/screens/onboarding_screens.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:allergyapp/models/user_registration_data.dart'; // <-- Add this import

// ------------------------------------------------

class CreatePasswordScreen extends StatefulWidget {
  final UserRegistrationData userData;

  const CreatePasswordScreen({super.key, required this.userData});

  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';
  final String _passwordHint = 'Password must be at least 6 characters long.';

  // Colors (Copied from RegisterScreen for consistency)
  static const Color primaryAccent = Color(0xFF1E88E5);
  static const Color darkTextColor = Color(0xFF424242);

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Final Registration Logic
  Future<void> _handleFinalRegister() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() => _errorMessage = 'Please enter and confirm your password.');
      return;
    }

    if (password.length < 6) {
      setState(() => _errorMessage = _passwordHint);
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
      // Perform Supabase registration with all collected data
      final response = await Supabase.instance.client.auth.signUp(
        email: widget.userData.email,
        password: password,
        data: {
          'first_name': widget.userData.firstName,
          'last_name': widget.userData.lastName,
        },
      );

      if (!mounted) return;

      if (response.user != null) {
        // Registration success → navigate to onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );
      } else {
        setState(
          () => _errorMessage = 'Registration failed. Please try again.',
        );
      }
    } on AuthException catch (e) {
      setState(() => _errorMessage = 'Registration failed: ${e.message}');
    } catch (e) {
      setState(() => _errorMessage = 'Unexpected error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Helper function for text field decoration (from RegisterScreen)
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

  // Widget for the Gradient Button (from RegisterScreen)
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
        onPressed: _isLoading ? null : _handleFinalRegister,
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
            : Text("Create Account", style: AppTextStyles.buttonText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Simple back button to go back to the User Info screen
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 1. Header: Title and Subheading ---
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Create Your Password",
                    style: AppTextStyles.heading,
                  ),
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "This protects your account and data.",
                    style: AppTextStyles.subheading,
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

                // --- 2. Password ---
                Text(
                  'Password',
                  style: AppTextStyles.inputLabel.copyWith(
                    color: darkTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  decoration: _buildInputDecoration(hint: 'Create a password'),
                  style: AppTextStyles.input,
                ),

                // Password hint text
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 25.0),
                  child: Text(
                    _passwordHint,
                    style: AppTextStyles.subheading.copyWith(
                      fontSize: 14,
                      color: darkTextColor.withOpacity(0.7),
                    ),
                  ),
                ),

                // --- 3. Confirm Password ---
                Text(
                  'Confirm Password',
                  style: AppTextStyles.inputLabel.copyWith(
                    color: darkTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  decoration: _buildInputDecoration(
                    hint: 'Confirm your password',
                  ),
                  style: AppTextStyles.input,
                ),
                const SizedBox(height: 40),

                // --- 4. Create Account Button (Final Step) ---
                _buildGradientButton(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
