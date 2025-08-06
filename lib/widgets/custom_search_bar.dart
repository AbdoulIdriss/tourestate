// widgets/custom_search_bar.dart

import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;

  const CustomSearchBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: SearchBar(
        controller: controller,
        hintText: 'Search',
        // Re-introduce the search icon and adjust padding to simulate centering
        leading: const Padding(
          padding: EdgeInsets.only(left: 10.0), // Adjust this padding
          child: Icon(Icons.search),
        ),
        trailing: const <Widget>[],
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(
            horizontal: 0, // This padding primarily affects text if leading/trailing are used
            vertical: 8, // Controls height
          ),
        ),
        // No textAlign for SearchBar directly
      ),
    );
  }
}