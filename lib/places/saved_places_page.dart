import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/tourist_place.dart';
import 'place_detail_page.dart';

class SavedPlacesPage extends StatefulWidget {
  const SavedPlacesPage({super.key});

  @override
  State<SavedPlacesPage> createState() => _SavedPlacesPageState();
}

class _SavedPlacesPageState extends State<SavedPlacesPage> {
  late Future<List<TouristPlace>> _futurePlaces;
  List<TouristPlace> _places = [];

  @override
  void initState() {
    super.initState();
    _futurePlaces = _fetchSavedPlaces();
  }

  Future<List<TouristPlace>> _fetchSavedPlaces() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('saved_places')
        .get();

    final places = snapshot.docs.map((doc) {
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

    _places = places;
    return places;
  }

  Future<void> _removePlace(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('saved_places')
        .doc(id)
        .delete();

    setState(() {
      _places.removeWhere((place) => place.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('❌ Removed from saved places')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('❤️ Saved Places'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<TouristPlace>>(
        future: _futurePlaces,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('❌ Error: ${snapshot.error}'));
          } else if (_places.isEmpty) {
            return const Center(child: Text('😔 No saved places yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _places.length,
            itemBuilder: (context, index) {
              final place = _places[index];
              final imageUrl = place.imageUrl;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlaceDetailPage(place: place),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                          imageUrl,
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 60),
                        )
                            : const SizedBox(
                          height: 120,
                          width: 120,
                          child: Center(
                            child: Icon(Icons.image_not_supported, size: 50),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      place.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.favorite, color: Colors.red),
                                    onPressed: () => _removePlace(place.id),
                                    tooltip: "Unfavorite",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                place.state,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
