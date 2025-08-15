// models/property.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:estate/models/amenity.dart';

enum PropertyType { apartment, house, office }
enum ListingType { rent, sale }

class Property {
  final String id;
  final String title;
  final String location;
  final PropertyType propertyType;
  final ListingType listingType;
  final double latitude;
  final double longitude;
  final int beds;
  final int baths;
  final double area; // Changed to double to match Firebase guide
  final List<String> imageUrls;
  final String description;
  final double price; // Changed to double for consistency
  final String ownerName;
  final double rating;
  final int reviewCount;
  final bool hasGarage;
  final List<Amenity> amenities;
  final String? virtualTourUrl;
  final int? floors;
  final bool? furnished;
  final String? parkingSpots;
  final double? discountPercentage; // Changed to double
  final DateTime dateAdded; // Added for Firebase
  final bool isActive; // Added for Firebase

  const Property({
    required this.id,
    required this.title,
    required this.location,
    required this.propertyType,
    required this.listingType,
    required this.latitude,
    required this.longitude,
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
    required this.amenities,
    this.virtualTourUrl,
    this.floors,
    this.furnished,
    this.parkingSpots,
    this.discountPercentage,
    required this.dateAdded,
    this.isActive = true,
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
      return '${price.toInt()} CFA / night';
    } else {
      return '${price.toInt()} CFA';
    }
  }

  bool get hasVirtualTour => virtualTourUrl != null && virtualTourUrl!.isNotEmpty;

  // Convert to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'propertyType': propertyType.toString(),
      'listingType': listingType.toString(),
      'latitude': latitude,
      'longitude': longitude,
      'beds': beds,
      'baths': baths,
      'area': area,
      'imageUrls': imageUrls,
      'description': description,
      'price': price,
      'ownerName': ownerName,
      'rating': rating,
      'reviewCount': reviewCount,
      'hasGarage': hasGarage,
      'amenities': amenities.map((a) => a.toMap()).toList(),
      'virtualTourUrl': virtualTourUrl,
      'floors': floors,
      'furnished': furnished,
      'parkingSpots': parkingSpots,
      'discountPercentage': discountPercentage,
      'dateAdded': Timestamp.fromDate(dateAdded),
      'isActive': isActive,
    };
  }

  // Create from Firestore Map
  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      location: map['location'] ?? '',
      propertyType: PropertyType.values.firstWhere(
        (e) => e.toString() == map['propertyType'],
        orElse: () => PropertyType.apartment,
      ),
      listingType: ListingType.values.firstWhere(
        (e) => e.toString() == map['listingType'],
        orElse: () => ListingType.rent,
      ),
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      beds: map['beds'] ?? 0,
      baths: map['baths'] ?? 0,
      area: (map['area'] ?? 0.0).toDouble(),
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      ownerName: map['ownerName'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      hasGarage: map['hasGarage'] ?? false,
      amenities: (map['amenities'] as List<dynamic>?)
          ?.map((a) => Amenity.fromMap(a as Map<String, dynamic>))
          .toList() ?? [],
      virtualTourUrl: map['virtualTourUrl'],
      floors: map['floors'],
      furnished: map['furnished'],
      parkingSpots: map['parkingSpots'],
      discountPercentage: map['discountPercentage']?.toDouble(),
      dateAdded: map['dateAdded'] != null 
          ? (map['dateAdded'] as Timestamp).toDate()
          : DateTime.now(),
      isActive: map['isActive'] ?? true,
    );
  }

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
          parkingSpots == other.parkingSpots &&
          dateAdded == other.dateAdded &&
          isActive == other.isActive;

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
        Object.hash(virtualTourUrl, floors, furnished, parkingSpots, dateAdded, isActive),
      );

  Property copyWith({
    String? id,
    String? title,
    String? location,
    PropertyType? propertyType,
    ListingType? listingType,
    int? beds,
    int? baths,
    double? area,
    List<String>? imageUrls,
    String? description,
    double? price,
    String? ownerName,
    double? rating,
    int? reviewCount,
    bool? hasGarage,
    double? discountPercentage,
    List<Amenity>? amenities,
    double? latitude,
    double? longitude,
    String? virtualTourUrl,
    int? floors,
    bool? furnished,
    String? parkingSpots,
    DateTime? dateAdded,
    bool? isActive,
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
      dateAdded: dateAdded ?? this.dateAdded,
      isActive: isActive ?? this.isActive,
    );
  }
}