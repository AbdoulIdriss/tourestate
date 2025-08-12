import 'package:estate/widgets/custom_search_bar.dart';
import 'package:estate/widgets/filter_button.dart';
import 'package:estate/widgets/filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:estate/screens/auth_screen.dart';
import 'package:estate/widgets/navigation_bar.dart';

import 'package:estate/screens/pages/home_content.dart';
import 'package:estate/screens/pages/favorite_screen.dart';
import 'package:estate/screens/pages/map_screen.dart';
import 'package:estate/screens/pages/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  FilterCriteria _currentFilters = FilterCriteria();

  List<Widget>? _screens;

  // Available options for filters
  final List<String> _availableAmenities = [
    'Swimming Pool',
    'Free WiFi',
    'Free Parking',
    'Air Conditioning',
    'Private Bathroom',
    'BBQ Equipment',
    'Kitchen',
    'TV',
    'Gym',
    'Garden',
    'Balcony',
    'Laundry',
    'Security',
    'Elevator',
    'Furnished',
  ];

  final List<String> _availableLocations = [
    'Bonamoussadi, Douala',
    'Kribi, South Region',
    'Akwa, Douala',
    'Dschang, West Region',
    'Yaoundé, Centre',
    'Bamenda, Northwest',
    'Bafoussam, West',
    'Limbe, Southwest',
  ];

  @override
  void initState() {
    super.initState();
    _screens = <Widget>[
      HomeContentScreen(
        searchController: _searchController,
        filterCriteria: _currentFilters,
      ),
      const FavoriteScreen(),
      const MapScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showFilterDialog() async {
    final result = await showFilterDialog(
      context: context,
      currentFilters: _currentFilters,
      availableAmenities: _availableAmenities,
      availableLocations: _availableLocations,
    );

    if (result != null) {
      setState(() {
        _currentFilters = result;
        // Update the home content screen with new filters
        _screens![0] = HomeContentScreen(
          searchController: _searchController,
          filterCriteria: _currentFilters,
        );
      });
    }
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (_currentFilters.minPrice > 0) count++;
    if (_currentFilters.maxPrice < 200000) count++;
    if (_currentFilters.minBeds != null) count++;
    if (_currentFilters.maxBeds != null) count++;
    if (_currentFilters.minBaths != null) count++;
    if (_currentFilters.maxBaths != null) count++;
    if (_currentFilters.minArea != null) count++;
    if (_currentFilters.maxArea != null) count++;
    if (_currentFilters.selectedAmenities.isNotEmpty) count++;
    if (_currentFilters.minRating != null) count++;
    if (_currentFilters.hasGarage != null) count++;
    if (_currentFilters.selectedLocations.isNotEmpty) count++;
    if (_currentFilters.selectedPropertyTypes.isNotEmpty) count++;
    if (_currentFilters.selectedListingTypes.isNotEmpty) count++;
    if (_currentFilters.hasVirtualTour != null) count++;
    return count;
  }

  static const List<String> _screenTitles = <String>[
    'Home',
    'Favorites',
    'Map',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              toolbarHeight: 30,
              title: _selectedIndex == 0
                  ? null
                  : Text(
                      _screenTitles[_selectedIndex],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              bottom: _selectedIndex == 0
                  ? PreferredSize(
                      preferredSize: const Size.fromHeight(80.0),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: 1,
                                  ),
                                ),
                                child: CustomSearchBar(
                                  controller: _searchController,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            FilterButton(
                              onPressed: _showFilterDialog,
                              hasActiveFilters: _currentFilters.hasActiveFilters,
                              activeFilterCount: _getActiveFilterCount(),
                            ),
                          ],
                        ),
                      ),
                    )
                  : null,
            ),
            body: _screens![_selectedIndex],
            bottomNavigationBar: CustomNavigationBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          );
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}