// models/allergy_profile.dart
class AllergyProfile {
  final String name;
  final List<String> allergens;

  AllergyProfile({required this.name, required this.allergens});

  factory AllergyProfile.fromJson(Map<String, dynamic> json) {
    return AllergyProfile(
      name: json['name'],
      allergens: List<String>.from(json['allergens'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'allergens': allergens};
  }
}
