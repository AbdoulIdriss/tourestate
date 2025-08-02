import 'package:estate/models/amenity.dart';

class Apartment {

  final String title;
  final String location;
  final int beds;
  final int baths;
  final int area;
  final List<String> imageUrls;
  final String description;
  final int pricePerNight;
  final String ownerName;
  final double rating;
  final int reviewCount;
  final bool hasGarage;
  final int? discountPercentage; // Optional discount
  final List<Amenity> amenities;
  final double latitude; // <-- NEW FIELD for map
  final double longitude;


  const Apartment({

    required this.title,
    required this.location,
    required this.beds,
    required this.baths,
    required this.area,
    required this.imageUrls,
    required this.description,
    required this.pricePerNight,
    required this.ownerName,
    required this.rating,
    required this.reviewCount,
    this.hasGarage = false,
    this.discountPercentage,
    required this.amenities,
    required this.latitude,
    required this.longitude,
  });

}