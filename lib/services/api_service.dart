import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tourist_place.dart';

class ApiService {
  /// Map UI category names (with emojis) to the Firestore values
  static final Map<String, String> categoryMap = {
    '🏙️ Cities': '🏙️ Cities',
    '⛰️ Hills': '⛰️ Hills',
    '🏖️ Beaches': '🏖️ Beaches',
    '🛕 Spiritual': '🛕 Spiritual',
    '🏰 Heritage': '🏰 Heritage',
    '🐯 Wildlife': '🐯 Wildlife',
    '🏜️ Deserts': '🏜️ Deserts',
    '🏝️ Islands': '🏝️ Islands',
  };

  /// Fetch places from Firestore for the given category
  static Future<List<TouristPlace>> fetchPlacesByCategory(String displayCategory) async {
    final category = categoryMap[displayCategory] ?? displayCategory;

    try {
      print("🔎 Fetching places from Firestore for category: $category");

      final snapshot = await FirebaseFirestore.instance
          .collection('places')
          .where('category', isEqualTo: category)
          .orderBy('timestamp', descending: true)
          .get();

      print("✅ Fetched ${snapshot.docs.length} documents from Firestore");

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return TouristPlace(
          id: doc.id,
          imageUrl: data['imageUrl'] ?? '',
          name: data['name'] ?? '',
          state: data['state'] ?? '',
          description: data['description'] ?? '',
          category: data['category'] ?? '',
          price: data['price'] ?? '',
          mealsIncluded: data['mealsIncluded'] ?? false,
          stayIncluded: data['stayIncluded'] ?? false,
          availableDate: data['availableDate'] ?? '',
        );
      }).toList();
    } catch (e) {
      print("❌ Error loading places for category '$category': $e");
      throw Exception("Error loading places for category: $category");
    }
  }
}
