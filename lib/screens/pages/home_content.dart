import 'package:estate/models/amenity.dart';
import 'package:estate/models/appartment.dart';
import 'package:estate/widgets/custom_search_bar.dart';
import 'package:estate/widgets/estate_cards.dart';
import 'package:flutter/material.dart';

class HomeContentScreen extends StatefulWidget {
  
  const HomeContentScreen({super.key});

  @override
  State<HomeContentScreen> createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {

  final TextEditingController _searchController = TextEditingController();

  // Mock data 

  final List<Apartment> _apartments = [
    const Apartment(
      title: 'Modern Family House',
      location: 'Bonamoussadi, Douala',
      latitude: 4.0833, // Example coordinates for Bonamoussadi
      longitude: 9.7333,
      beds: 4,
      baths: 3,
      area: 250,
      imageUrls: [
        'https://i.pinimg.com/1200x/c5/a7/18/c5a7180a45368c9b0d30dc37ad1e8723.jpg',
        'https://i.pinimg.com/736x/48/59/db/4859dbba99d28966edbd36d85aa24c94.jpg',
      ],
      description: 'A beautiful and spacious modern house located in the heart of Bonamoussadi. Perfect for families looking for comfort and style. Features a large living room, a state-of-the-art kitchen, and a beautiful garden view.',
      pricePerNight: 80000,
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
        Amenity(name: 'BBQ Equipment', icon: Icons.outdoor_grill),
        Amenity(name: 'Kitchen', icon: Icons.kitchen),
        Amenity(name: 'TV', icon: Icons.tv),
      ],
    ),
    const Apartment(
      title: 'Luxury Beachside Villa',
      location: 'Kribi, South Region',
      latitude: 4.0833, // Example coordinates for Bonamoussadi
      longitude: 9.7333,
      beds: 5,
      baths: 4,
      area: 320,
      imageUrls: [
        'https://i.pinimg.com/736x/ba/e4/a4/bae4a4ba046305ff112d4872374ca751.jpg',
        'https://i.pinimg.com/736x/7b/44/96/7b44969b385a121dc61e2abd8ed9dc81.jpg',
      ],
      description: 'Experience luxury living with this stunning beachside villa in Kribi. Offers breathtaking ocean views, a private pool, and direct access to the beach. An ideal getaway for relaxation and entertainment.',
      pricePerNight: 15000,
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
      ],
    ),
    const Apartment(
      title: 'Cozy Downtown Apartment',
      location: 'Akwa, Douala',
      latitude: 4.0833, // Example coordinates for Bonamoussadi
      longitude: 9.7333,
      beds: 2,
      baths: 1,
      area: 95,
      imageUrls: [
        'https://i.pinimg.com/736x/49/4e/5a/494e5a165daeae2229f66ebf875206cb.jpg',
        'https://i.pinimg.com/736x/d4/7b/e2/d47be28251f9931b33fb37816bc32143.jpg',
      ],
      description: 'A beautiful and spacious modern house located in the heart of Bonamoussadi. Perfect for families looking for comfort and style. Features a large living room, a state-of-the-art kitchen, and a beautiful garden view.',
      pricePerNight: 55000,
      ownerName: 'Banana',
      rating: 4.5,
      reviewCount: 18,
      amenities: [
        Amenity(name: 'Swimming Pool', icon: Icons.pool),
        Amenity(name: 'Free WiFi', icon: Icons.wifi),
        Amenity(name: 'Free Parking', icon: Icons.local_parking),
        Amenity(name: 'Air Conditioning', icon: Icons.ac_unit),
        Amenity(name: 'Private Bathroom', icon: Icons.bathtub_outlined),
        Amenity(name: 'BBQ Equipment', icon: Icons.outdoor_grill),
        Amenity(name: 'Kitchen', icon: Icons.kitchen),
        Amenity(name: 'TV', icon: Icons.tv),
      ],
    ),
    const Apartment(
      title: 'Serene Mountain Retreat',
      location: 'Dschang, West Region',
      latitude: 4.0833, // Example coordinates for Bonamoussadi
      longitude: 9.7333,
      beds: 3,
      baths: 2,
      area: 180,
      imageUrls: [
        'https://i.pinimg.com/736x/d1/f4/3d/d1f43dbeea0c444ff5b0ff9c40d6a534.jpg',
        'https://i.pinimg.com/736x/ba/e4/a4/bae4a4ba046305ff112d4872374ca751.jpg',
      ],
      description: 'A charming and cozy apartment situated in the bustling commercial district of Akwa. Perfect for professionals and couples. Close to shops, restaurants, and public transport.',
      pricePerNight: 20000,
      ownerName: 'Soul kvtana',
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
      ],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSearchBar(
          controller: _searchController,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _apartments.length,
            itemBuilder: (BuildContext context, int index){
              return EstateCards(apartment: _apartments[index]);
            } ,
          )
        )

      ],
    );
  }
}