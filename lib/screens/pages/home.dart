import 'package:estate/widgets/custom_search_bar.dart';
import 'package:estate/widgets/filter_button.dart';
import 'package:estate/widgets/filter_dialog.dart';
import 'package:estate/services/data_migration_service.dart'; // Add this import
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool _isMigrating = false; // Add loading state for migration

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

  // Add migration function
  void _migrateData() async {
    setState(() {
      _isMigrating = true;
    });

    try {
      await DataMigrationService.migratePropertiesToFirestore();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data migration completed successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Migration failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isMigrating = false;
        });
      }
    }
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (_currentFilters.minPrice > 0) count++;
    // Don't count maxPrice as active filter since it's set to a very high default
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
              // Add actions to AppBar
              actions: [
                // Only show migration button on home screen and when not migrating
                if (_selectedIndex == 0)
                  _isMigrating
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ),
                        )
                      : IconButton(
                          onPressed: _migrateData,
                          icon: const Icon(Icons.cloud_upload),
                          tooltip: 'Migrate Data to Firebase',
                          iconSize: 24,
                        ),
                const SizedBox(width: 8), // Add some spacing
              ],
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
          // Show home screen even for unauthenticated users
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
              // No sign in button in home screen - it's in profile screen
              actions: [
                const SizedBox(width: 8),
              ],
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
            body: _selectedIndex == 0 
                ? HomeContentScreen(
                    searchController: _searchController,
                    filterCriteria: _currentFilters,
                  )
                : _buildUnauthenticatedScreen(),
            bottomNavigationBar: CustomNavigationBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          );
        }
      },
    );
  }

  Widget _buildUnauthenticatedScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Sign In Required',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please sign in to access this feature',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AuthScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Sign In',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}