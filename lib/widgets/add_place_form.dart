import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddPlaceForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController imageController;
  final TextEditingController nameController;
  final TextEditingController stateController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final bool isStayIncluded;
  final bool isMealsIncluded;
  final DateTime? availableDate;
  final String? selectedCategory;
  final Map<String, String> categoryMap;
  final Function(bool?) onStayChanged;
  final Function(bool?) onMealsChanged;
  final Function(String?) onCategoryChanged;
  final VoidCallback onDatePick;
  final VoidCallback onSubmit;

  const AddPlaceForm({
    super.key,
    required this.formKey,
    required this.imageController,
    required this.nameController,
    required this.stateController,
    required this.descriptionController,
    required this.priceController,
    required this.isStayIncluded,
    required this.isMealsIncluded,
    required this.availableDate,
    required this.selectedCategory,
    required this.categoryMap,
    required this.onStayChanged,
    required this.onMealsChanged,
    required this.onCategoryChanged,
    required this.onDatePick,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white24),
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "📝 Place Information",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent.shade100,
                    fontFamily: 'Cinzel',
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField("🖼 Image URL", imageController),
                const SizedBox(height: 12),
                _buildTextField("📍 Place Name", nameController),
                const SizedBox(height: 12),
                _buildTextField("🌐 State", stateController),
                const SizedBox(height: 12),
                _buildTextField("📝 Description", descriptionController, maxLines: 3),
                const SizedBox(height: 12),
                _buildTextField("💰 Price (₹)", priceController, isNumber: true),
                const SizedBox(height: 12),
                _buildCheckbox("🏨 Stay Included", isStayIncluded, onStayChanged),
                _buildCheckbox("🍽 Meals Included", isMealsIncluded, onMealsChanged),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  dropdownColor: Colors.black87,
                  onChanged: onCategoryChanged,
                  items: categoryMap.keys
                      .map((cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(cat,
                        style: const TextStyle(color: Colors.orangeAccent)),
                  ))
                      .toList(),
                  validator: (val) =>
                  val == null ? "Please select a category" : null,
                  decoration: InputDecoration(
                    labelText: "📂 Choose Category",
                    labelStyle: TextStyle(color: Colors.orange.shade100),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.date_range, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text("📅 Available From:",
                        style: TextStyle(color: Colors.white70)),
                    TextButton(
                      onPressed: onDatePick,
                      child: Text(
                        availableDate != null
                            ? DateFormat('dd MMM yyyy')
                            .format(availableDate!)
                            : "Select Date",
                        style: TextStyle(
                          color: Colors.orangeAccent.shade100,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: onSubmit,
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text("Submit to Firebase"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent.shade200,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      validator: (value) =>
      (value == null || value.trim().isEmpty) ? "Enter $label" : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.orange.shade100),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orangeAccent.shade100),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orangeAccent.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        fillColor: Colors.white.withOpacity(0.1),
        filled: true,
      ),
    );
  }

  Widget _buildCheckbox(String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.orangeAccent,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }
}
