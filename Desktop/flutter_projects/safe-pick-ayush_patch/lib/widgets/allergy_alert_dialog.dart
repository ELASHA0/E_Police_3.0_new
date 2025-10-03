// widgets/allergy_alert_dialog.dart
// PURPOSE: Displays a pop-up dialog warning users when allergens are detected in scanned products.

import 'package:flutter/material.dart';

class AllergyAlertDialog extends StatelessWidget {
  final List<String> detectedAllergens;

  const AllergyAlertDialog({super.key, required this.detectedAllergens});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Allergy Alert!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: detectedAllergens
            .map(
              (allergen) => ListTile(
                leading: const Icon(Icons.warning, color: Colors.red),
                title: Text(allergen),
              ),
            )
            .toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
