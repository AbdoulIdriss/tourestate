import 'package:estate/models/amenity.dart';
import 'package:flutter/foundation.dart';

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

  // --------------------------------------------------------------------------
  // Equality (==) and Hashing (hashCode)
  // --------------------------------------------------------------------------

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Apartment &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          location == other.location &&
          beds == other.beds &&
          baths == other.baths &&
          area == other.area &&
          listEquals(imageUrls, other.imageUrls) && // Use listEquals for lists
          description == other.description &&
          pricePerNight == other.pricePerNight &&
          ownerName == other.ownerName &&
          rating == other.rating &&
          reviewCount == other.reviewCount &&
          hasGarage == other.hasGarage &&
          discountPercentage == other.discountPercentage &&
          listEquals(amenities, other.amenities) && // Assuming Amenity also overrides == and hashCode
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => Object.hash(
        title,
        location,
        beds,
        baths,
        area,
        Object.hashAll(imageUrls), // Hash all elements in the list
        description,
        pricePerNight,
        ownerName,
        rating,
        reviewCount,
        hasGarage,
        discountPercentage,
        Object.hashAll(amenities), // Hash all elements in the list
        latitude,
        longitude,
      );

  // --------------------------------------------------------------------------
  // copyWith Method
  // --------------------------------------------------------------------------

  Apartment copyWith({
    String? title,
    String? location,
    int? beds,
    int? baths,
    int? area,
    List<String>? imageUrls,
    String? description,
    int? pricePerNight,
    String? ownerName,
    double? rating,
    int? reviewCount,
    bool? hasGarage,
    int? discountPercentage,
    List<Amenity>? amenities,
    double? latitude,
    double? longitude,
  }) {
    return Apartment(
      title: title ?? this.title,
      location: location ?? this.location,
      beds: beds ?? this.beds,
      baths: baths ?? this.baths,
      area: area ?? this.area,
      imageUrls: imageUrls ?? this.imageUrls,
      description: description ?? this.description,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      ownerName: ownerName ?? this.ownerName,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      hasGarage: hasGarage ?? this.hasGarage,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      amenities: amenities ?? this.amenities,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}