// services/mock_scan_service.dart
class MockScanService {
  static List<String> extractIngredients(String imagePath) {
    // Simulated OCR output
    return ['Milk', 'Sugar', 'Peanuts', 'Salt', 'Soy Lecithin'];
  }

  static List<String> detectAllergens(
    List<String> ingredients,
    List<String> userAllergies,
  ) {
    return ingredients.where((ingredient) {
      return userAllergies.any(
        (allergy) => ingredient.toLowerCase().contains(allergy.toLowerCase()),
      );
    }).toList();
  }
}
