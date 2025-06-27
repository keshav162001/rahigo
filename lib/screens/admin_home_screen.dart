import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/add_place_form.dart';
import '../places/admin_category_places_page.dart'; // <== Make sure this file exists

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  bool showAddForm = false;
  bool showCategories = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  bool isStayIncluded = false;
  bool isMealsIncluded = false;
  DateTime? availableDate;
  String? selectedCategory;

  final Map<String, String> categoryMap = {
    '🏙️ Cities': 'cities',
    '⛰️ Hills': 'hills',
    '🏖️ Beaches': 'beaches',
    '🛕 Spiritual': 'spiritual',
    '🏰 Heritage': 'heritage',
    '🐯 Wildlife': 'wildlife',
    '🏜️ Deserts': 'deserts',
    '🏝️ Islands': 'islands',
  };

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Please select a category")),
        );
        return;
      }

      final imageUrl = imageController.text.trim();
      if (imageUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Please enter an image URL")),
        );
        return;
      }

      final placeData = {
        "imageUrl": imageUrl,
        "name": nameController.text.trim(),
        "state": stateController.text.trim(),
        "description": descriptionController.text.trim(),
        "price": priceController.text.trim(),
        "stayIncluded": isStayIncluded,
        "mealsIncluded": isMealsIncluded,
        "category": categoryMap[selectedCategory]!,
        "availableDate": availableDate != null
            ? DateFormat('yyyy-MM-dd').format(availableDate!)
            : "Not selected",
        "timestamp": FieldValue.serverTimestamp(),
      };

      try {
        await FirebaseFirestore.instance.collection('places').add(placeData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Place stored in Firebase!")),
        );

        imageController.clear();
        nameController.clear();
        stateController.clear();
        descriptionController.clear();
        priceController.clear();

        setState(() {
          isStayIncluded = false;
          isMealsIncluded = false;
          availableDate = null;
          selectedCategory = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error saving to Firebase: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("🛕 Admin Panel"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: (showAddForm || showCategories)
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              showAddForm = false;
              showCategories = false;
            });
          },
        )
            : null,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_monument.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          if (showAddForm)
            AddPlaceForm(
              formKey: _formKey,
              imageController: imageController,
              nameController: nameController,
              stateController: stateController,
              descriptionController: descriptionController,
              priceController: priceController,
              isStayIncluded: isStayIncluded,
              isMealsIncluded: isMealsIncluded,
              availableDate: availableDate,
              selectedCategory: selectedCategory,
              categoryMap: categoryMap,
              onStayChanged: (val) => setState(() => isStayIncluded = val ?? false),
              onMealsChanged: (val) => setState(() => isMealsIncluded = val ?? false),
              onCategoryChanged: (val) => setState(() => selectedCategory = val),
              onDatePick: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => availableDate = picked);
              },
              onSubmit: _submitForm,
            )
          else if (showCategories)
            _buildCategoryList()
          else
            _buildCardGrid(),
        ],
      ),
    );
  }

  Widget _buildCardGrid() {
    return GridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildAdminCard(
          icon: Icons.add_location_alt_rounded,
          label: 'Add Place',
          color: Colors.greenAccent,
          onTap: () => setState(() => showAddForm = true),
        ),
        _buildAdminCard(
          icon: Icons.folder_shared_rounded,
          label: 'Show Places',
          color: Colors.amberAccent,
          onTap: () => setState(() => showCategories = true),
        ),
      ],
    );
  }

  Widget _buildAdminCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cinzel',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
      children: categoryMap.entries.map((entry) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AdminCategoryPlacesPage(
                  emojiLabel: entry.key,
                  category: entry.value,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              border: Border.all(color: Colors.orangeAccent),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              entry.key,
              style: const TextStyle(
                color: Colors.orangeAccent,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
