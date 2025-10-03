// widgets/ingredient_card.dart
// PURPOSE: Displays each ingredient from the scan result and highlights if it's an allergen.

import 'package:flutter/material.dart';

class IngredientCard extends StatelessWidget {
  final String ingredient;
  final bool isAllergen;

  const IngredientCard({
    super.key,
    required this.ingredient,
    this.isAllergen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isAllergen ? Colors.red.shade50 : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Icon(
          isAllergen ? Icons.warning : Icons.check_circle,
          color: isAllergen ? Colors.red : Colors.green,
        ),
        title: Text(
          ingredient,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isAllergen ? Colors.red.shade700 : Colors.black,
          ),
        ),
      ),
    );
  }
}
