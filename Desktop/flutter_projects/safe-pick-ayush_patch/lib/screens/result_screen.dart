import 'dart:convert';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String result;

  const ResultScreen({super.key, required this.result});

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

  // Helper widget to build a styled section with a heading and content box
  Widget _buildInfoSection(
    String title,
    Widget content, {
    Color? headingBgColor,
    IconData? headingIcon, // Optional icon for the heading
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
      ), // More vertical margin between sections
      decoration: BoxDecoration(
        color: Colors.white, // White background for the entire section card
        borderRadius: BorderRadius.circular(
          18,
        ), // More rounded corners for the section card
        boxShadow: [
          BoxShadow(
            color: textColor.withOpacity(0.1), // Subtle shadow for depth
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading Box
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0, // More horizontal padding
              vertical: 14.0, // More vertical padding
            ),
            decoration: BoxDecoration(
              color:
                  headingBgColor ??
                  lightBlue.withOpacity(
                    0.3,
                  ), // Default to a lighter accent from new palette
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18), // Match parent container's top radius
              ),
            ),
            width: double.infinity,
            child: Row(
              children: [
                if (headingIcon != null) ...[
                  Icon(headingIcon, color: textColor, size: 24),
                  const SizedBox(width: 10),
                ],
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20, // Slightly larger font for headings
                    color: textColor, // Use consistent dark text color
                  ),
                ),
              ],
            ),
          ),
          // Content Box
          Padding(
            padding: const EdgeInsets.all(20.0), // Generous padding for content
            child: content,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> parsedResult = {};
    try {
      parsedResult = json.decode(result) as Map<String, dynamic>;
    } catch (e) {
      return Scaffold(
        backgroundColor: backgroundColor, // Apply new background color
        appBar: AppBar(
          title: const Text(
            'Analysis Result',
            style: TextStyle(
              color: lightTextColor,
              fontWeight: FontWeight.bold,
            ), // Use lightTextColor
          ),
          backgroundColor: primaryAccent, // Use primaryAccent for app bar
          iconTheme: const IconThemeData(
            color: lightTextColor,
          ), // Use lightTextColor
          elevation: 6.0,
          shadowColor: textColor.withOpacity(0.4),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sentiment_dissatisfied_rounded,
                  color: secondaryAccent, // Use secondaryAccent
                  size: 80,
                ), // More expressive icon
                const SizedBox(height: 20),
                const Text(
                  "Oops! Something went wrong...",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor, // Use textColor
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "We couldn't process the label. Please try scanning again.",
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor.withOpacity(0.7),
                  ), // Use textColor with opacity
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  "Error Details: ${e.toString()}", // More descriptive error message
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withOpacity(0.5),
                  ), // Use textColor with opacity
                  textAlign: TextAlign.center,
                ),
                if (result.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Raw Response: $result",
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withOpacity(0.4),
                      ), // Use textColor with opacity
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    List<dynamic> extractedIngredients =
        parsedResult['extracted_ingredients'] ?? [];
    List<dynamic> detectedAllergens = parsedResult['detected_allergens'] ?? [];
    String recommendation =
        parsedResult['recommendation'] ??
        "No specific recommendation provided.";
    String riskLevel =
        parsedResult['risk_level']?.toString().toLowerCase() ?? "unknown";

    // Determine the color, icon, and display text for the risk level
    Color riskBgColor;
    Color riskTextColor;
    String riskDisplayText;
    IconData riskIcon;

    switch (riskLevel) {
      case "high":
        riskBgColor = Colors
            .red
            .shade100; // Keeping red for high risk (universal understanding)
        riskTextColor = Colors.red.shade700;
        riskDisplayText = "HIGH RISK";
        riskIcon = Icons.warning_rounded; // Bold warning icon
        break;
      case "moderate":
        riskBgColor = Colors.amber.shade100; // Keeping amber for moderate risk
        riskTextColor = Colors.amber.shade700;
        riskDisplayText = "MODERATE RISK";
        riskIcon = Icons.info_rounded; // Info icon
        break;
      case "low":
        riskBgColor = Colors.green.shade100; // Keeping green for low risk
        riskTextColor = Colors.green.shade700;
        riskDisplayText = "LOW RISK";
        riskIcon = Icons.check_circle_rounded; // Checkmark icon
        break;
      default:
        riskBgColor = Colors.grey.shade100;
        riskTextColor = Colors.grey.shade700;
        riskDisplayText = "UNKNOWN RISK";
        riskIcon = Icons.help_outline_rounded; // Help icon for unknown
        break;
    }

    return Scaffold(
      backgroundColor:
          backgroundColor, // Apply new background color to the whole screen
      appBar: AppBar(
        backgroundColor: primaryAccent, // Use primary accent for app bar
        elevation: 6.0,
        shadowColor: textColor.withOpacity(0.4),
        title: const Text(
          'Analysis Results',
          style: TextStyle(
            color: lightTextColor, // Use lightTextColor (white) for title
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: lightTextColor, // Back button color is white
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0), // More overall padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Risk Level Section ---
            _buildInfoSection(
              "Overall Risk Assessment",
              Row(
                children: [
                  Icon(
                    riskIcon,
                    color: riskTextColor,
                    size: 30,
                  ), // Icon next to text
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      riskDisplayText,
                      style: TextStyle(
                        fontSize: 22, // Larger font for impact
                        fontWeight: FontWeight.w900, // Extra bold
                        color: riskTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              headingBgColor: riskBgColor, // Dynamic background based on risk
              headingIcon: Icons
                  .shield_moon_rounded, // An icon for the heading title itself
            ),
            // --- Extracted Ingredients Section ---
            _buildInfoSection(
              "Extracted Ingredients",
              extractedIngredients.isEmpty
                  ? Text(
                      "No ingredients were clearly extracted. Please ensure the label is well-lit and clear.",
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor.withOpacity(0.7),
                      ), // Use textColor
                    )
                  : ListView.builder(
                      shrinkWrap: true, // Important for ListView inside Column
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable internal scrolling
                      itemCount: extractedIngredients.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            "• ${extractedIngredients[index]}", // Bullet point list
                            style: const TextStyle(
                              fontSize: 16,
                              color: textColor, // Dark text
                            ),
                          ),
                        );
                      },
                    ),
              headingIcon:
                  Icons.format_list_bulleted_rounded, // Icon for heading
            ),
            // --- Detected Allergens Section ---
            _buildInfoSection(
              "Detected Allergens",
              detectedAllergens.isEmpty
                  ? Text(
                      "Great news! No known allergens from your profile were detected in the label.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors
                            .green
                            .shade700, // Keeping green for positive outcome
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: detectedAllergens.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6.0,
                            horizontal: 10.0,
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors
                                .red
                                .shade50, // Very light red background for each allergen
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.red.shade200,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.dangerous_rounded,
                                color: Colors.red, // Danger icon in red
                                size: 20,
                              ), // Danger icon
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  detectedAllergens[index]
                                      .toString()
                                      .toUpperCase(), // Uppercase for emphasis
                                  style: TextStyle(
                                    color: Colors.red.shade800, // Dark red text
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              headingIcon: Icons.warning_amber_rounded, // Icon for heading
            ),
            // --- Recommendation Section ---
            _buildInfoSection(
              "Recommendation",
              Text(
                recommendation,
                style: const TextStyle(
                  fontSize: 16,
                  color: textColor, // Use textColor
                  height: 1.5, // Line height for better readability
                ),
              ),
              headingIcon: Icons.lightbulb_outline_rounded, // Icon for heading
            ),
            const SizedBox(height: 20), // Space at the bottom
            // Reminder/Disclaimer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Disclaimer: This app provides a preliminary analysis. Always consult with a healthcare professional for severe allergies and confirm ingredients on the product label.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(
                    0.6,
                  ), // Use textColor with opacity
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
