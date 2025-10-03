import 'package:flutter/material.dart';

class AllergyProfileScreen extends StatefulWidget {
  final List<String> userAllergies;
  final Function(List<String>) onAllergiesUpdated;

  const AllergyProfileScreen({
    super.key,
    required this.userAllergies,
    required this.onAllergiesUpdated,
  });

  @override
  State<AllergyProfileScreen> createState() => _AllergyProfileScreenState();
}

class _AllergyProfileScreenState extends State<AllergyProfileScreen> {
  late List<String> _userAllergies;
  final TextEditingController _allergyController = TextEditingController();

  static const Color backgroundColor = Color(0xFF121212);
  static const Color chipColor = Color(0xFF2C2C2C);
  static const Color primaryAccent = Color(0xFF3F51B5);
  static const Color secondaryAccent = Color(0xFF7C4DFF);
  static const Color lightText = Colors.white;
  static const Color greyText = Colors.grey;

  final List<String> commonAllergens = [
    "Milk",
    "Eggs",
    "Fish",
    "Shellfish",
    "Tree Nuts",
    "Peanuts",
    "Wheat",
    "Soybeans",
    "Sesame",
    "Mustard",
    "Sulfites",
    "Celery",
    "Lupin",
    "Mollusks",
  ];

  @override
  void initState() {
    super.initState();
    _userAllergies = List.from(widget.userAllergies);
  }

  void _addAllergy() {
    final newAllergy = _allergyController.text.trim();
    if (newAllergy.isNotEmpty && !_userAllergies.contains(newAllergy)) {
      setState(() {
        _userAllergies.add(newAllergy);
      });
      _allergyController.clear();
      widget.onAllergiesUpdated(_userAllergies);
    }
  }

  void _toggleAllergy(String allergy) {
    setState(() {
      if (_userAllergies.contains(allergy)) {
        _userAllergies.remove(allergy);
      } else {
        _userAllergies.add(allergy);
      }
    });
    widget.onAllergiesUpdated(_userAllergies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryAccent,
        title: const Text("Your Allergy Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Set up your allergy profile to get personalized safety recommendations when scanning products.",
              style: TextStyle(color: greyText, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // Common Allergens
            const Text(
              "Common Allergens",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: commonAllergens.map((allergy) {
                final isSelected = _userAllergies.contains(allergy);
                return ChoiceChip(
                  label: Text(allergy),
                  selected: isSelected,
                  onSelected: (_) => _toggleAllergy(allergy),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : greyText,
                    fontWeight: FontWeight.w500,
                  ),
                  selectedColor: primaryAccent,
                  backgroundColor: chipColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Add Custom Allergy
            const Text(
              "Add Custom Allergy",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _allergyController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter a specific allergen",
                      hintStyle: TextStyle(color: greyText),
                      filled: true,
                      fillColor: chipColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addAllergy,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryAccent,
                  ),
                  child: const Text("Add"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Save Button
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3F51B5), Color(0xFF7C4DFF)],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: ElevatedButton(
                onPressed: _userAllergies.isEmpty ? null : () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  "Save Allergy Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (_userAllergies.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal[700],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Please select at least one allergen to create your profile.",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 30),

            // Tips
            const Text(
              "💡 Tips for Better Protection",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "• Include all your known allergens, even if they seem uncommon",
              style: TextStyle(color: Colors.white70),
            ),
            const Text(
              "• Add specific ingredient names you need to avoid (e.g., casein for milk allergy)",
              style: TextStyle(color: Colors.white70),
            ),
            const Text(
              "• Update your profile whenever you discover new allergens",
              style: TextStyle(color: Colors.white70),
            ),
            const Text(
              "• Use the custom allergy field for specific brand names or additives",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
