// utils/constants.dart
class AppConstants {
  static const List<String> commonAllergens = [
    'Peanuts',
    'Soy',
    'Gluten',
    'Dairy',
    'Eggs',
    'Shellfish',
    'Tree nuts',
    'Wheat',
    'Sesame',
  ];

  static const String ocrApiKey = 'your-ocr-api-key-here';
  static const String appTitle = 'Allergy Identifier';
}

// utils/helpers.dart
class StringHelper {
  static String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  static List<String> normalizeList(List<String> list) {
    return list.map((e) => e.toLowerCase().trim()).toList();
  }
}
