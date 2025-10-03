import 'package:flutter/material.dart';

class IngredientResultScreen extends StatelessWidget {
  final List<String> ingredients;
  final List<String> matchedAllergens;

  const IngredientResultScreen({
    super.key,
    required this.ingredients,
    required this.matchedAllergens,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan Result')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detected Ingredients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...ingredients.map((item) => Text("- $item")),
            SizedBox(height: 20),
            Text(
              'Allergens Detected:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            ...matchedAllergens.map(
              (item) => Text("⚠️ $item", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
