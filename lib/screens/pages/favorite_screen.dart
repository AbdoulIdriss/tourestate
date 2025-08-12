import 'package:estate/providers/favorites_provider.dart';
import 'package:estate/widgets/estate_cards.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the FavoritesProvider to rebuild when the favorites list changes
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoriteProperties = favoritesProvider.favorites; // Changed from favoriteApartments to favoriteProperties

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorites'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: favoriteProperties.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No favorites yet!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Add properties to your favorites to see them here.', // Changed from "apartments" to "properties"
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favoriteProperties.length,
              itemBuilder: (context, index) {
                final property = favoriteProperties[index]; // Changed from apartment to property
                return EstateCards(property: property); // Updated parameter name - check your EstateCards widget
              },
            ),
    );
  }
}