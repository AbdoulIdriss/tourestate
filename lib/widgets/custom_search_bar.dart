import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;

  const CustomSearchBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: controller,
      hintText: 'Search by location, amenities, or type...',
      hintStyle: WidgetStateProperty.all<TextStyle>(
        TextStyle(
          color: Colors.grey[500],
          fontSize: 16,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Icon(
          Icons.search,
          color: Colors.grey[600],
          size: 22,
        ),
      ),
      trailing: controller?.text.isNotEmpty == true 
          ? [
              IconButton(
                icon: const Icon(Icons.clear),
                iconSize: 20,
                color: Colors.grey[600],
                onPressed: () {
                  controller?.clear();
                },
                tooltip: 'Clear search',
              ),
            ]
          : const <Widget>[],
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12, // Adjusted for better height
        ),
      ),
      backgroundColor: WidgetStateProperty.all<Color>(Colors.grey[50]!),
      surfaceTintColor: WidgetStateProperty.all<Color>(Colors.transparent),
      elevation: WidgetStateProperty.all<double>(0),
      side: WidgetStateProperty.all<BorderSide>(
        BorderSide(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      shape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(
        const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }
}