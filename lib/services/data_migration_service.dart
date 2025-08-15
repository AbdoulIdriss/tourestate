import 'package:estate/models/property.dart';
import 'package:estate/models/amenity.dart';
import 'package:estate/services/firebase_service.dart';
import 'package:flutter/material.dart';

class DataMigrationService {
  static Future<void> migratePropertiesToFirestore() async {
    final List<Property> properties = [
      Property(
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
          'https://i.pinimg.com/1200x/87/c5/1a/87c51a688a123bf0dcb07a8540145a63.jpg',
          'https://i.pinimg.com/1200x/18/ce/c1/18cec114761a4f6a860465a084e0db8b.jpg',
          'https://i.pinimg.com/736x/58/33/3c/58333c4d1c68218855fbe54be228efc8.jpg',
          'https://i.pinimg.com/1200x/f9/d9/b3/f9d9b33fb52a5eb3c5c1fda9a7ac9543.jpg'
        ],
        description: 'A beautiful and spacious modern apartment located in the heart of Bonamoussadi. Perfect for families looking for comfort and style.',
        price: 80000,
        ownerName: 'Abdul Idriss',
        rating: 4.8,
        reviewCount: 32,
        hasGarage: true,
        discountPercentage: 15,
        isActive: true,
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
        dateAdded: DateTime.now(),
      ),

      Property(
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
        'https://i.pinimg.com/1200x/d2/13/3d/d2133ddf98ac417716a7eeb0ee8ccf02.jpg',
        'https://i.pinimg.com/736x/27/d5/4a/27d54a6b0137ce4ceac0c7dadcc24d12.jpg',
        'https://i.pinimg.com/736x/99/c3/e2/99c3e288be36d2b9e0079a77cc8f9c74.jpg',
      ],
      description: 'Experience luxury living with this stunning beachside villa in Kribi. Offers breathtaking ocean views, a private pool, and direct access to the beach. An ideal family home with modern amenities and spacious rooms.',
      price: 85000000, // 85M CFA for sale
      ownerName: 'Ben Idriss',
      rating: 4.9,
      reviewCount: 55,
      hasGarage: true,
      isActive: true,
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
      virtualTourUrl: 'https://laresidenciatarifa.com/en/virtual-tour-apartments/#estudio-superior-vista-mar',
      floors: 2,
      furnished: false,
      parkingSpots: '4 spots + garage',
      dateAdded: DateTime.now().subtract(Duration(days: 5)), 
    ),

    // OFFICE FOR RENT
    Property(
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
        'https://i.pinimg.com/736x/b3/21/e2/b321e2485da40c0dde2685c3a4fdcb56.jpg',
        'https://i.pinimg.com/736x/8f/78/03/8f780382972b3b90ae497450a9a64b7c.jpg',
      ],
      description: 'Prime office space in the heart of Douala\'s business district. Perfect for startups and established companies. Features modern amenities, high-speed internet, and professional meeting rooms.',
      price: 120000, // per month
      ownerName: 'Business Properties Ltd',
      rating: 4.6,
      reviewCount: 24,
      hasGarage: false,
      isActive: true,
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
      dateAdded: DateTime.now().subtract(Duration(days: 25)), 
    ),

    // HOUSE FOR RENT
    Property(
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
        'https://i.pinimg.com/1200x/29/09/85/29098575fdbf82e69b60b4c02efd2050.jpg',
        'https://i.pinimg.com/736x/ef/5f/78/ef5f78919856edcd5c126a8cb65a1d2e.jpg',
      ],
      description: 'Escape to this peaceful mountain house in Dschang. Surrounded by nature with stunning views and fresh mountain air. Perfect for a tranquil family home with modern conveniences.',
      price: 45000,
      ownerName: 'Soul Kvtana',
      rating: 4.7,
      reviewCount: 28,
      hasGarage: true,
      isActive: true,
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
      dateAdded: DateTime.now().subtract(Duration(days: 10)),
    ),

    // APARTMENT FOR SALE
    Property(
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
        'https://a0.muscache.com/im/pictures/miso/Hosting-1305788081004001073/original/e5cfa29f-6314-435f-8bc4-57ec7965a76a.jpeg?im_w=1440',
        'https://a0.muscache.com/im/pictures/miso/Hosting-1305788081004001073/original/c2cc259f-dca3-44e8-bb35-19d2fd82d16a.jpeg?im_w=1440',
        'https://a0.muscache.com/im/pictures/miso/Hosting-1305788081004001073/original/0ce17654-26be-4c58-a6c3-dd19fe5c62f4.jpeg?im_w=1440',
        'https://a0.muscache.com/im/pictures/miso/Hosting-1305788081004001073/original/f96fd0d6-50f8-458c-a4fb-21e10a562af3.jpeg?im_w=1440',
        'https://a0.muscache.com/im/pictures/miso/Hosting-1305788081004001073/original/a9fd2f71-92b1-44ec-8393-31dfc3528df7.jpeg?im_w=1440',
      ],
      description: 'Prime investment opportunity in Bonapriso. This modern apartment offers excellent rental potential in one of Douala\'s most sought-after neighborhoods.',
      price: 25000000, // 25M CFA
      ownerName: 'Investment Properties',
      rating: 4.4,
      reviewCount: 15,
      hasGarage: false,
      isActive: true,
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
      dateAdded: DateTime.now().subtract(Duration(days: 15)),
    ),

    // OFFICE FOR SALE
    Property(
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
        'https://storage.googleapis.com/koutchoumi-listings-original-pictures/orig_6885ad2fea14f.jpeg',
        'https://storage.googleapis.com/koutchoumi-listings-original-pictures/orig_6885ad30d1ef6.jpeg',
      ],
      description: 'Premium office building perfect for corporate headquarters. Features multiple floors, modern infrastructure, and prime location in Douala\'s financial district.',
      price: 450000000, // 450M CFA
      ownerName: 'Commercial Real Estate Co.',
      rating: 4.8,
      reviewCount: 12,
      hasGarage: true,
      isActive: true,
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
      dateAdded: DateTime.now().subtract(Duration(days: 20)), 
    ),
      
    ];

    try {
      await FirebaseService.saveMultipleProperties(properties);
      print('All properties migrated successfully!');
    } catch (e) {
      print('Migration failed: $e');
    }
  }
}