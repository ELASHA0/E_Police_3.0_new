// lib/models/font.dart

import 'package:flutter/material.dart';

// --- Color Palette matching the desired look ---
// Blue Title/Primary Accent
const Color primaryAccent = Color(
  0xFF1E88E5,
); // Bright blue for "Join Safe Pick"
// Gradient Start/Link Color (Blue)
const Color secondaryAccent = Color(
  0xFF42A5F5,
); // Mid-blue for links/gradient start
// Dark Gray Text
const Color textColor = Color(0xFF424242); // Text color

/// Placeholder for application-wide TextStyles.
class AppTextStyles {
  // Main Title: "Join Safe Pick"
  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: primaryAccent,
    fontFamily: 'Lato',
  );

  // Subheading: "Create your account and start staying safe"
  static const TextStyle subheading = TextStyle(
    fontSize: 15,
    color: textColor,
    fontFamily: 'Lato',
  );

  // Text field label/input styles
  static TextStyle inputLabel = TextStyle(
    fontSize: 14,
    color: textColor.withOpacity(0.9),
    fontFamily: 'Lato',
  );

  static const TextStyle input = TextStyle(
    fontSize: 16,
    color: textColor,
    fontFamily: 'Lato',
  );

  // Button text style
  static const TextStyle buttonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: 'Lato',
  );

  // Error and Link text styles
  static TextStyle errorText = TextStyle(
    fontSize: 14,
    color: Colors.red.shade700,
    fontFamily: 'Lato',
  );

  static const TextStyle linkText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: primaryAccent,
    decoration: TextDecoration.underline,
    decorationColor: primaryAccent,
    fontFamily: 'Lato',
  );
}
