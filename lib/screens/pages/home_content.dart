import 'package:estate/models/amenity.dart';
import 'package:estate/models/appartment.dart';
import 'package:estate/widgets/estate_cards.dart';
import 'package:flutter/material.dart';

class HomeContentScreen extends StatefulWidget {

  final TextEditingController searchController;
  
  const HomeContentScreen({super.key , required this.searchController,});

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
      latitude: 4.0833,
      longitude: 9.7333,
      beds: 4,
      baths: 3,
      area: 250,
      imageUrls: [
        'https://a0.muscache.com/im/pictures/miso/Hosting-1267748599413486428/original/eeec4306-9223-408e-82bc-084369017a57.jpeg?im_w=320',
        'https://a0.muscache.com/im/pictures/miso/Hosting-1267748599413486428/original/4c932584-f7eb-42c4-a7c3-d5d263a15e1b.jpeg?im_w=320',
        'https://a0.muscache.com/im/pictures/miso/Hosting-1267748599413486428/original/51265d53-5791-441e-a0ea-b8c290e1cacc.jpeg?im_w=320',
        'https://a0.muscache.com/im/pictures/hosting/Hosting-U3RheVN1cHBseUxpc3Rpbmc6MTI2Nzc0ODU5OTQxMzQ4NjQyOA%3D%3D/original/b383c149-3f8b-4806-954c-0fe6ae6bc487.jpeg?im_w=320',
        'https://a0.muscache.com/im/pictures/hosting/Hosting-U3RheVN1cHBseUxpc3Rpbmc6MTI2Nzc0ODU5OTQxMzQ4NjQyOA%3D%3D/original/ae7238b9-ae24-4ae9-94b8-ecac028a1845.jpeg?im_w=320',
        'https://a0.muscache.com/im/pictures/hosting/Hosting-U3RheVN1cHBseUxpc3Rpbmc6MTI2Nzc0ODU5OTQxMzQ4NjQyOA%3D%3D/original/a826099d-1f65-4e3c-a52e-703ed5c6c53c.jpeg?im_w=320',
        'https://a0.muscache.com/im/pictures/hosting/Hosting-1267748599413486428/original/8d9a5986-990c-421e-8564-b80fb77c19d9.jpeg?im_w=320',
        'https://a0.muscache.com/im/pictures/miso/Hosting-1267748599413486428/original/d2b9eb32-fa25-445d-ab55-e84f0d2d6ee7.jpeg?im_w=320',
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
      latitude: 4.0833,
      longitude: 9.7333,
      beds: 5,
      baths: 4,
      area: 320,
      imageUrls: [
        'https://a0.muscache.com/im/pictures/miso/Hosting-1379844891510007535/original/e1536b3b-71d0-4839-841d-ebb59b2e3a17.jpeg?im_w=960',
        'https://a0.muscache.com/im/pictures/miso/Hosting-1379844891510007535/original/2f08d7cd-2042-440c-9c91-4a9e25ecc4fe.jpeg?im_w=1200',
        'https://a0.muscache.com/im/pictures/miso/Hosting-1379844891510007535/original/3338cd8a-a030-4628-9769-f9c31492d097.jpeg?im_w=1200',
        'https://a0.muscache.com/im/pictures/miso/Hosting-1379844891510007535/original/a9ff04f5-0cce-4ff3-8ee3-5a4b3917948a.jpeg?im_w=1200',
        'https://a0.muscache.com/im/pictures/hosting/Hosting-U3RheVN1cHBseUxpc3Rpbmc6MTM3OTg0NDg5MTUxMDAwNzUzNQ==/original/f82044d6-802b-4b51-bc5e-904ea305539f.jpeg?im_w=1200',
        'https://a0.muscache.com/im/pictures/miso/Hosting-1379844891510007535/original/91032504-00be-4a31-a1c8-505bd78f3bbb.jpeg?im_w=1200'
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
      latitude: 4.0833,
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
      latitude: 4.0833,
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
    // Only display the list of apartments here
    return ListView.builder(
      itemCount: _apartments.length,
      itemBuilder: (BuildContext context, int index) {
        return EstateCards(apartment: _apartments[index]);
      },
    );
  }

}