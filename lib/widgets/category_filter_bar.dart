// lib/widgets/category_filter_bar.dart
import 'package:flutter/material.dart';

class CategoryFilterBar extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  const CategoryFilterBar({super.key, required this.categories, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selected == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (bool value) => onSelected(cat),
              backgroundColor: Colors.white,
              selectedColor: Colors.red.shade100,
              checkmarkColor: Colors.red,
              labelStyle: TextStyle(color: isSelected ? Colors.red : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSelected ? Colors.red : Colors.grey.shade300)),
            ),
          );
        },
      ),
    );
  }
}
