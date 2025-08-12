import 'package:estate/models/amenity.dart';
import 'package:flutter/foundation.dart';

enum PropertyType { apartment, house, office }
enum ListingType { rent, sale }

class Property {
  final String id;
  final String title;
  final String location;
  final PropertyType propertyType;
  final ListingType listingType;
  final int beds;
  final int baths;
  final int area;
  final List<String> imageUrls;
  final String description;
  final int price; 
  final String ownerName;
  final double rating;
  final int reviewCount;
  final bool hasGarage;
  final int? discountPercentage;
  final List<Amenity> amenities;
  final double latitude;
  final double longitude;
  final String? virtualTourUrl;
  final int? floors;
  final bool? furnished; 
  final String? parkingSpots;

  const Property({
    required this.id,
    required this.title,
    required this.location,
    required this.propertyType,
    required this.listingType,
    required this.beds,
    required this.baths,
    required this.area,
    required this.imageUrls,
    required this.description,
    required this.price,
    required this.ownerName,
    required this.rating,
    required this.reviewCount,
    this.hasGarage = false,
    this.discountPercentage,
    required this.amenities,
    required this.latitude,
    required this.longitude,
    this.virtualTourUrl,
    this.floors,
    this.furnished,
    this.parkingSpots,
  });

  // Helper methods for display
  String get propertyTypeDisplay {
    switch (propertyType) {
      case PropertyType.apartment:
        return 'Apartment';
      case PropertyType.house:
        return 'House';
      case PropertyType.office:
        return 'Office';
    }
  }

  String get listingTypeDisplay {
    switch (listingType) {
      case ListingType.rent:
        return 'For Rent';
      case ListingType.sale:
        return 'For Sale';
    }
  }

  String get priceDisplay {
    if (listingType == ListingType.rent) {
      return '$price CFA / night';
    } else {
      return '$price CFA';
    }
  }

  bool get hasVirtualTour => virtualTourUrl != null && virtualTourUrl!.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Property &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          location == other.location &&
          propertyType == other.propertyType &&
          listingType == other.listingType &&
          beds == other.beds &&
          baths == other.baths &&
          area == other.area &&
          listEquals(imageUrls, other.imageUrls) &&
          description == other.description &&
          price == other.price &&
          ownerName == other.ownerName &&
          rating == other.rating &&
          reviewCount == other.reviewCount &&
          hasGarage == other.hasGarage &&
          discountPercentage == other.discountPercentage &&
          listEquals(amenities, other.amenities) &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          virtualTourUrl == other.virtualTourUrl &&
          floors == other.floors &&
          furnished == other.furnished &&
          parkingSpots == other.parkingSpots;

  @override
  int get hashCode => Object.hash(
        id,
        title,
        location,
        propertyType,
        listingType,
        beds,
        baths,
        area,
        Object.hashAll(imageUrls),
        description,
        price,
        ownerName,
        rating,
        reviewCount,
        hasGarage,
        discountPercentage,
        Object.hashAll(amenities),
        latitude,
        longitude,
        Object.hash(virtualTourUrl, floors, furnished, parkingSpots),
      );

  Property copyWith({
    String? id,
    String? title,
    String? location,
    PropertyType? propertyType,
    ListingType? listingType,
    int? beds,
    int? baths,
    int? area,
    List<String>? imageUrls,
    String? description,
    int? price,
    String? ownerName,
    double? rating,
    int? reviewCount,
    bool? hasGarage,
    int? discountPercentage,
    List<Amenity>? amenities,
    double? latitude,
    double? longitude,
    String? virtualTourUrl,
    int? floors,
    bool? furnished,
    String? parkingSpots,
  }) {
    return Property(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      propertyType: propertyType ?? this.propertyType,
      listingType: listingType ?? this.listingType,
      beds: beds ?? this.beds,
      baths: baths ?? this.baths,
      area: area ?? this.area,
      imageUrls: imageUrls ?? this.imageUrls,
      description: description ?? this.description,
      price: price ?? this.price,
      ownerName: ownerName ?? this.ownerName,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      hasGarage: hasGarage ?? this.hasGarage,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      amenities: amenities ?? this.amenities,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      virtualTourUrl: virtualTourUrl ?? this.virtualTourUrl,
      floors: floors ?? this.floors,
      furnished: furnished ?? this.furnished,
      parkingSpots: parkingSpots ?? this.parkingSpots,
    );
  }
}