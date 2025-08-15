import 'package:estate/models/property.dart';
import 'package:estate/services/firebase_service.dart';
import 'package:estate/widgets/estate_cards.dart';
import 'package:estate/widgets/filter_dialog.dart';
import 'package:flutter/material.dart';

class HomeContentScreen extends StatefulWidget {
  final TextEditingController searchController;
  final FilterCriteria filterCriteria;
  
  const HomeContentScreen({
    super.key, 
    required this.searchController,
    required this.filterCriteria,
  });

  @override
  State<HomeContentScreen> createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  List<Property> _allProperties = [];

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onSearchChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Property>>(
      stream: FirebaseService.getProperties(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        _allProperties = snapshot.data ?? [];
        
        // Calculate filtered properties directly in build method without setState
        final filteredProperties = _getFilteredProperties();

        return Column(
          children: [
            Expanded(
              child: filteredProperties.isEmpty
                  ? _buildNoResultsWidget()
                  : ListView.builder(
                      itemCount: filteredProperties.length,
                      itemBuilder: (BuildContext context, int index) {
                        return EstateCards(property: filteredProperties[index]);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(HomeContentScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // No need to call setState here - build will be called automatically
    // when the widget updates and we'll recalculate filtered properties
  }

  void _onSearchChanged() {
    // This triggers a rebuild which will recalculate the filtered properties
    setState(() {
      // Empty setState - just triggers rebuild
    });
  }

  // Extract filtering logic to a pure function that returns filtered list
  List<Property> _getFilteredProperties() {
    return _allProperties.where((property) {
      // Search query filter
      if (widget.searchController.text.isNotEmpty) {
        final searchLower = widget.searchController.text.toLowerCase();
        
        final titleMatch = property.title.toLowerCase().contains(searchLower);
        final locationMatch = property.location.toLowerCase().contains(searchLower);
        final descriptionMatch = property.description.toLowerCase().contains(searchLower);
        final ownerMatch = property.ownerName.toLowerCase().contains(searchLower);
        final amenityMatch = property.amenities.any((amenity) =>
            amenity.name.toLowerCase().contains(searchLower));
        
        // Property type search
        final typeMatch = property.propertyTypeDisplay.toLowerCase().contains(searchLower);
        final listingMatch = property.listingTypeDisplay.toLowerCase().contains(searchLower);
        
        final bedsMatch = searchLower.contains('bed') && 
            widget.searchController.text.contains(property.beds.toString());
        final bathsMatch = searchLower.contains('bath') && 
            widget.searchController.text.contains(property.baths.toString());
        
        bool priceMatch = false;
        if (searchLower.contains('cheap') || searchLower.contains('budget')) {
          priceMatch = property.price <= 50000;
        } else if (searchLower.contains('luxury') || searchLower.contains('expensive')) {
          priceMatch = property.price >= 100000;
        }
        
        final matchesSearch = titleMatch || locationMatch || descriptionMatch || 
               ownerMatch || amenityMatch || bedsMatch || bathsMatch || priceMatch ||
               typeMatch || listingMatch;
        
        if (!matchesSearch) return false;
      }

      // Apply FilterCriteria filters
      final filters = widget.filterCriteria;

      // Price filter
      if (property.price < filters.minPrice || 
          property.price > filters.maxPrice) {
        return false;
      }

      // Bedrooms filter (skip for offices)
      if (property.propertyType != PropertyType.office) {
        if (filters.minBeds != null && property.beds < filters.minBeds!) {
          return false;
        }
        if (filters.maxBeds != null && property.beds > filters.maxBeds!) {
          return false;
        }
      }

      // Bathrooms filter
      if (filters.minBaths != null && property.baths < filters.minBaths!) {
        return false;
      }
      if (filters.maxBaths != null && property.baths > filters.maxBaths!) {
        return false;
      }

      // Area filter
      if (filters.minArea != null && property.area < filters.minArea!) {
        return false;
      }
      if (filters.maxArea != null && property.area > filters.maxArea!) {
        return false;
      }

      // Rating filter
      if (filters.minRating != null && property.rating < filters.minRating!) {
        return false;
      }

      // Garage filter
      if (filters.hasGarage != null && property.hasGarage != filters.hasGarage!) {
        return false;
      }

      // Location filter
      if (filters.selectedLocations.isNotEmpty) {
        final matchesLocation = filters.selectedLocations.any((selectedLocation) =>
            property.location.toLowerCase().contains(selectedLocation.toLowerCase()));
        if (!matchesLocation) return false;
      }

      // Amenities filter
      if (filters.selectedAmenities.isNotEmpty) {
        final propertyAmenityNames = property.amenities.map((a) => a.name).toList();
        final hasAllAmenities = filters.selectedAmenities.every((selectedAmenity) =>
            propertyAmenityNames.contains(selectedAmenity));
        if (!hasAllAmenities) return false;
      }

      // Listing type filter
      if (filters.selectedListingTypes.isNotEmpty) {
        final propertyListingType = property.listingTypeDisplay;
        final matchesListingType = filters.selectedListingTypes.contains(propertyListingType);
        if (!matchesListingType) return false;
      }

      // Property type filter
      if (filters.selectedPropertyTypes.isNotEmpty) {
        final propertyType = property.propertyTypeDisplay;
        final matchesPropertyType = filters.selectedPropertyTypes.contains(propertyType);
        if (!matchesPropertyType) return false;
      }

      // Virtual tour filter
      if (filters.hasVirtualTour == true && !property.hasVirtualTour) {
        return false;
      }

      return true;
    }).toList();
  }

  Widget _buildNoResultsWidget() {
    final hasSearch = widget.searchController.text.isNotEmpty;
    final hasFilters = widget.filterCriteria.hasActiveFilters;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasSearch || hasFilters ? Icons.search_off : Icons.home_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            hasSearch || hasFilters 
                ? 'No properties found'
                : 'No properties available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasSearch || hasFilters
                ? 'Try adjusting your search terms\nor filter criteria'
                : 'Check back later for new listings',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          if (hasSearch || hasFilters) ...[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.searchController.clear();
                // You'll need to call a callback to clear filters from parent
                // For now, this just clears the search
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Clear Search & Filters'),
            ),
          ],
        ],
      ),
    );
  }
}