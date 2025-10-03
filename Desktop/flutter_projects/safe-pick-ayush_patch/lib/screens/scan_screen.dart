import 'dart:io';
import 'package:allergyapp/screens/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ScanScreen extends StatefulWidget {
  final List<String> userAllergies;

  const ScanScreen({super.key, required this.userAllergies});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with SingleTickerProviderStateMixin {
  File? _image;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 85, // Slightly higher quality
      maxWidth: 1024, // Limit image size for performance
      maxHeight: 1024,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _animationController.forward(
        from: 0.0,
      ); // Trigger animation on image capture
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null) {
      _showSnackBar(
        "Please capture or select a product label first!",
        backgroundColor: Colors.redAccent,
        icon: Icons.error_outline_rounded,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Updated to use the deployed backend on Render
      final uri = Uri.parse("https://safe-pick-backend.onrender.com/analyze");

      final request = http.MultipartRequest("POST", uri)
        ..fields['allergies'] = widget.userAllergies.join(',')
        ..files.add(await http.MultipartFile.fromPath('image', _image!.path));

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(result: responseBody),
          ),
        );
      } else {
        _showSnackBar(
          "❌ Server Error: ${streamedResponse.statusCode}\n$responseBody",
          backgroundColor: Colors.redAccent,
          icon: Icons.cloud_off_rounded,
        );
      }
    } catch (e) {
      _showSnackBar(
        "❌ An error occurred: $e",
        backgroundColor: Colors.redAccent,
        icon: Icons.wifi_off_rounded,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Helper method for custom SnackBar
  void _showSnackBar(String message, {Color? backgroundColor, IconData? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
            ],
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor:
            backgroundColor ?? textColor, // Use textColor for SnackBar
        behavior: SnackBarBehavior.floating, // Make it float
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Apply the new background color
      appBar: AppBar(
        backgroundColor: primaryAccent, // Use primaryAccent for app bar
        elevation: 6.0, // Add elevation for a lifted effect
        shadowColor: textColor.withOpacity(0.4), // Subtle shadow
        centerTitle: true,
        title: const Text(
          "Scan Product Label",
          style: TextStyle(
            color: lightTextColor, // White title for better contrast
            fontWeight: FontWeight.bold,
            fontSize: 22, // Larger title
            letterSpacing: 0.8, // Increased letter spacing for flair
          ),
        ),
        iconTheme: const IconThemeData(
          color: lightTextColor,
        ), // Back button color is white
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25), // Increased padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- Image Preview Area ---
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: double.infinity,
                  height: 280, // Taller container
                  decoration: BoxDecoration(
                    color:
                        Colors.white, // White background for the preview area
                    borderRadius: BorderRadius.circular(
                      20,
                    ), // More rounded corners for visual softness
                    border: Border.all(
                      color: _image != null
                          ? primaryAccent.withOpacity(
                              0.7,
                            ) // Accent border when image is present
                          : Colors.grey.shade300,
                      width: _image != null
                          ? 3.0
                          : 2.0, // Thicker border when image is present
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: textColor.withOpacity(0.1), // Subtle shadow
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                            18,
                          ), // Slightly smaller radius than container
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                            alignment: Alignment
                                .topCenter, // Focus on the top part of the image
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Using the new image for the empty state
                            const SizedBox(height: 15),
                            Text(
                              "Capture or select a label to begin",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Good lighting helps for best results.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(
                height: 40,
              ), // More space between preview and buttons
              // --- Capture Label Button ---
              ElevatedButton.icon(
                onPressed: _isLoading
                    ? null
                    : () => _pickImage(ImageSource.camera),
                icon: const Icon(
                  Icons.camera_alt_rounded,
                  size: 28,
                ), // Rounded icon, larger
                label: const Text("Capture from Camera"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: lightTextColor, // Text color is white
                  backgroundColor: _isLoading
                      ? Colors.grey.shade400
                      : primaryAccent, // Use primaryAccent
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30, // More padding
                    vertical: 18, // More padding
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18, // Larger text
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ), // More rounded corners
                  ),
                  elevation: 6, // More pronounced shadow
                  shadowColor: textColor.withOpacity(0.3),
                ),
              ),
              const SizedBox(height: 20), // Space between buttons
              // --- Pick from Gallery Button ---
              ElevatedButton.icon(
                onPressed: _isLoading
                    ? null
                    : () => _pickImage(ImageSource.gallery),
                icon: const Icon(
                  Icons.photo_library_rounded, // Gallery icon
                  size: 28,
                ),
                label: const Text("Pick from Gallery"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: lightTextColor, // Text color is white
                  backgroundColor: _isLoading
                      ? Colors.grey.shade400
                      : secondaryAccent, // Use secondaryAccent
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 18,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  shadowColor: textColor.withOpacity(0.3),
                ),
              ),
              const SizedBox(height: 30), // Space before analyze button
              // --- Analyze Allergens Button ---
              ElevatedButton(
                onPressed: (_image == null || _isLoading)
                    ? null
                    : _analyzeImage,
                style: ElevatedButton.styleFrom(
                  foregroundColor: lightTextColor, // Text color is white
                  backgroundColor: (_image == null || _isLoading)
                      ? Colors
                            .grey
                            .shade400 // Disabled color
                      : primaryAccent.withOpacity(
                          0.8,
                        ), // Slightly subdued primary accent
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 18,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  shadowColor: textColor.withOpacity(0.3),
                ),

                child: _isLoading
                    ? const SizedBox(
                        width: 28, // Larger loading indicator
                        height: 28,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3.5, // Thicker stroke
                        ),
                      )
                    : const Text("Analyze Allergens"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
