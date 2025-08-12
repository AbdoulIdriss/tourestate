import 'package:estate/models/amenity.dart';
import 'package:estate/models/property.dart';
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
  List<Property> _filteredProperties = [];
  
  // Enhanced mock data with apartments, houses, and offices
  final List<Property> _properties = [
    // APARTMENTS FOR RENT
    const Property(
      id: 'apt_001',
      title: 'Modern Family Apartment',
      location: 'Bonamoussadi, Douala',
      propertyType: PropertyType.apartment,
      listingType: ListingType.rent,
      latitude: 4.0833,
      longitude: 9.7333,
      beds: 4,
      baths: 3,
      area: 250,
      imageUrls: [
        'https://a0.muscache.com/im/pictures/miso/Hosting-1267748599413486428/original/eeec4306-9223-408e-82bc-084369017a57.jpeg?im_w=320',
        'https://a0.muscache.com/im/pictures/miso/Hosting-1267748599413486428/original/4c932584-f7eb-42c4-a7c3-d5d263a15e1b.jpeg?im_w=320',
        'https://a0.muscache.com/im/pictures/miso/Hosting-1267748599413486428/original/51265d53-5791-441e-a0ea-b8c290e1cacc.jpeg?im_w=320',
      ],
      description: 'A beautiful and spacious modern apartment located in the heart of Bonamoussadi. Perfect for families looking for comfort and style. Features a large living room, a state-of-the-art kitchen, and a beautiful garden view.',
      price: 80000,
      ownerName: 'Abdul Idriss',
      rating: 4.8,
      reviewCount: 32,
      hasGarage: true,
      discountPercentage: 15,
      amenities: [
        Amenity(name: 'Swimming Pool', icon: Icons.pool),
        Amenity(name: 'Free WiFi', icon: Icons.wifi),
        Amenity(name: 'Free Parking', icon: Icons.local_parking),
        Amenity(name: 'Air Conditioning', icon: Icons.ac_unit),
        Amenity(name: 'Private Bathroom', icon: Icons.bathtub_outlined),
        Amenity(name: 'Kitchen', icon: Icons.kitchen),
        Amenity(name: 'TV', icon: Icons.tv),
      ],
      virtualTourUrl: 'https://www.visite-virtuelle360.fr/visite-virtuelle/210930-PavillonsIDF/',
      floors: 1,
      furnished: true,
      parkingSpots: '2 spots',
    ),
    
    // HOUSE FOR SALE
    const Property(
      id: 'house_001',
      title: 'Luxury Beachside Villa',
      location: 'Kribi, South Region',
      propertyType: PropertyType.house,
      listingType: ListingType.sale,
      latitude: 2.9333,
      longitude: 9.9167,
      beds: 5,
      baths: 4,
      area: 320,
      imageUrls: [
        'https://a0.muscache.com/im/pictures/miso/Hosting-1379844891510007535/original/e1536b3b-71d0-4839-841d-ebb59b2e3a17.jpeg?im_w=960',
        'https://a0.muscache.com/im/pictures/miso/Hosting-1379844891510007535/original/2f08d7cd-2042-440c-9c91-4a9e25ecc4fe.jpeg?im_w=1200',
        'https://a0.muscache.com/im/pictures/miso/Hosting-1379844891510007535/original/3338cd8a-a030-4628-9769-f9c31492d097.jpeg?im_w=1200',
      ],
      description: 'Experience luxury living with this stunning beachside villa in Kribi. Offers breathtaking ocean views, a private pool, and direct access to the beach. An ideal family home with modern amenities and spacious rooms.',
      price: 85000000, // 85M CFA for sale
      ownerName: 'Ben Idriss',
      rating: 4.9,
      reviewCount: 55,
      hasGarage: true,
      amenities: [
        Amenity(name: 'Swimming Pool', icon: Icons.pool),
        Amenity(name: 'Free WiFi', icon: Icons.wifi),
        Amenity(name: 'Free Parking', icon: Icons.local_parking),
        Amenity(name: 'Air Conditioning', icon: Icons.ac_unit),
        Amenity(name: 'Private Bathroom', icon: Icons.bathtub_outlined),
        Amenity(name: 'BBQ Equipment', icon: Icons.outdoor_grill),
        Amenity(name: 'Kitchen', icon: Icons.kitchen),
        Amenity(name: 'TV', icon: Icons.tv),
        Amenity(name: 'Garden', icon: Icons.grass),
        Amenity(name: 'Balcony', icon: Icons.balcony),
      ],
      virtualTourUrl: 'https://www.example.com/virtual-tour/villa-001',
      floors: 2,
      furnished: false,
      parkingSpots: '4 spots + garage',
    ),

    // OFFICE FOR RENT
    const Property(
      id: 'office_001',
      title: 'Modern Business Center Office',
      location: 'Akwa, Douala',
      propertyType: PropertyType.office,
      listingType: ListingType.rent,
      latitude: 4.0500,
      longitude: 9.7000,
      beds: 0, // offices don't have bedrooms
      baths: 2,
      area: 150,
      imageUrls: [
        'https://i.pinimg.com/736x/49/4e/5a/494e5a165daeae2229f66ebf875206cb.jpg',
        'https://i.pinimg.com/736x/d4/7b/e2/d47be28251f9931b33fb37816bc32143.jpg',
      ],
      description: 'Prime office space in the heart of Douala\'s business district. Perfect for startups and established companies. Features modern amenities, high-speed internet, and professional meeting rooms.',
      price: 120000, // per month
      ownerName: 'Business Properties Ltd',
      rating: 4.6,
      reviewCount: 24,
      hasGarage: false,
      amenities: [
        Amenity(name: 'High-Speed WiFi', icon: Icons.wifi),
        Amenity(name: 'Air Conditioning', icon: Icons.ac_unit),
        Amenity(name: 'Conference Room', icon: Icons.meeting_room),
        Amenity(name: 'Reception Area', icon: Icons.desk),
        Amenity(name: '24/7 Security', icon: Icons.security),
        Amenity(name: 'Elevator', icon: Icons.elevator),
      ],
      floors: 1,
      furnished: true,
      parkingSpots: '10 spots',
    ),

    // HOUSE FOR RENT
    const Property(
      id: 'house_002',
      title: 'Serene Mountain House',
      location: 'Dschang, West Region',
      propertyType: PropertyType.house,
      listingType: ListingType.rent,
      latitude: 5.4500,
      longitude: 10.0500,
      beds: 3,
      baths: 2,
      area: 180,
      imageUrls: [
        'https://i.pinimg.com/736x/d1/f4/3d/d1f43dbeea0c444ff5b0ff9c40d6a534.jpg',
        'https://i.pinimg.com/736x/ba/e4/a4/bae4a4ba046305ff112d4872374ca751.jpg',
      ],
      description: 'Escape to this peaceful mountain house in Dschang. Surrounded by nature with stunning views and fresh mountain air. Perfect for a tranquil family home with modern conveniences.',
      price: 45000,
      ownerName: 'Soul Kvtana',
      rating: 4.7,
      reviewCount: 28,
      hasGarage: true,
      amenities: [
        Amenity(name: 'Free WiFi', icon: Icons.wifi),
        Amenity(name: 'Free Parking', icon: Icons.local_parking),
        Amenity(name: 'Private Bathroom', icon: Icons.bathtub_outlined),
        Amenity(name: 'Kitchen', icon: Icons.kitchen),
        Amenity(name: 'Garden', icon: Icons.grass),
        Amenity(name: 'BBQ Equipment', icon: Icons.outdoor_grill),
      ],
      floors: 2,
      furnished: false,
      parkingSpots: '2 spots',
    ),

    // APARTMENT FOR SALE
    const Property(
      id: 'apt_002',
      title: 'Downtown Investment Apartment',
      location: 'Bonapriso, Douala',
      propertyType: PropertyType.apartment,
      listingType: ListingType.sale,
      latitude: 4.0600,
      longitude: 9.7200,
      beds: 2,
      baths: 2,
      area: 110,
      imageUrls: [
        'https://i.pinimg.com/736x/49/4e/5a/494e5a165daeae2229f66ebf875206cb.jpg',
        'https://i.pinimg.com/736x/d4/7b/e2/d47be28251f9931b33fb37816bc32143.jpg',
      ],
      description: 'Prime investment opportunity in Bonapriso. This modern apartment offers excellent rental potential in one of Douala\'s most sought-after neighborhoods.',
      price: 25000000, // 25M CFA
      ownerName: 'Investment Properties',
      rating: 4.4,
      reviewCount: 15,
      hasGarage: false,
      amenities: [
        Amenity(name: 'Free WiFi', icon: Icons.wifi),
        Amenity(name: 'Air Conditioning', icon: Icons.ac_unit),
        Amenity(name: 'Private Bathroom', icon: Icons.bathtub_outlined),
        Amenity(name: 'Kitchen', icon: Icons.kitchen),
        Amenity(name: 'TV', icon: Icons.tv),
        Amenity(name: 'Balcony', icon: Icons.balcony),
      ],
      virtualTourUrl: 'https://www.example.com/virtual-tour/apt-002',
      floors: 1,
      furnished: true,
      parkingSpots: '1 spot',
    ),

    // OFFICE FOR SALE
    const Property(
      id: 'office_002',
      title: 'Corporate Headquarters Building',
      location: 'Bonanjo, Douala',
      propertyType: PropertyType.office,
      listingType: ListingType.sale,
      latitude: 4.0400,
      longitude: 9.6900,
      beds: 0,
      baths: 6,
      area: 800,
      imageUrls: [
        'https://i.pinimg.com/736x/49/4e/5a/494e5a165daeae2229f66ebf875206cb.jpg',
        'https://i.pinimg.com/736x/d4/7b/e2/d47be28251f9931b33fb37816bc32143.jpg',
      ],
      description: 'Premium office building perfect for corporate headquarters. Features multiple floors, modern infrastructure, and prime location in Douala\'s financial district.',
      price: 450000000, // 450M CFA
      ownerName: 'Commercial Real Estate Co.',
      rating: 4.8,
      reviewCount: 12,
      hasGarage: true,
      amenities: [
        Amenity(name: 'High-Speed WiFi', icon: Icons.wifi),
        Amenity(name: 'Air Conditioning', icon: Icons.ac_unit),
        Amenity(name: 'Conference Rooms', icon: Icons.meeting_room),
        Amenity(name: 'Reception Areas', icon: Icons.desk),
        Amenity(name: '24/7 Security', icon: Icons.security),
        Amenity(name: 'Elevators', icon: Icons.elevator),
        Amenity(name: 'Cafeteria', icon: Icons.restaurant),
        Amenity(name: 'Backup Generator', icon: Icons.power),
      ],
      floors: 4,
      furnished: false,
      parkingSpots: '50 spots',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredProperties = List.from(_properties);
    widget.searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(HomeContentScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filterCriteria != widget.filterCriteria) {
      _applyFilters();
    }
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredProperties = _properties.where((property) {
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

        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search results and filter info
        if (widget.searchController.text.isNotEmpty || widget.filterCriteria.hasActiveFilters)
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${_filteredProperties.length} result${_filteredProperties.length != 1 ? 's' : ''} found',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (widget.searchController.text.isNotEmpty)
                      Text(
                        ' for "${widget.searchController.text}"',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                if (widget.filterCriteria.hasActiveFilters)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_list,
                          size: 16,
                          color: Colors.blue[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Filters applied',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        
        // List of properties
        Expanded(
          child: _filteredProperties.isEmpty
              ? _buildNoResultsWidget()
              : ListView.builder(
                  itemCount: _filteredProperties.length,
                  itemBuilder: (BuildContext context, int index) {
                    return EstateCards(property: _filteredProperties[index]);
                  },
                ),
        ),
      ],
    );
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