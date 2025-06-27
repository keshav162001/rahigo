class TouristPlace {
  final String id;
  final String imageUrl;
  final String name;
  final String state;
  final String description;
  final String? price;
  final bool? mealsIncluded;
  final bool? stayIncluded;
  final String? availableDate;
  final String? category;

  TouristPlace({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.state,
    required this.description,
    this.price,
    this.mealsIncluded,
    this.stayIncluded,
    this.availableDate,
    this.category,
  });

  factory TouristPlace.fromMap(Map<String, dynamic> data, String docId) {
    return TouristPlace(
      id: docId,
      imageUrl: data['imageUrl'] ?? '',
      name: data['name'] ?? '',
      state: data['state'] ?? '',
      description: data['description'] ?? '',
      price: data['price'],
      mealsIncluded: data['mealsIncluded'],
      stayIncluded: data['stayIncluded'],
      availableDate: data['availableDate'],
      category: data['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'name': name,
      'state': state,
      'description': description,
      'price': price,
      'mealsIncluded': mealsIncluded,
      'stayIncluded': stayIncluded,
      'availableDate': availableDate,
      'category': category,
    };
  }
}
