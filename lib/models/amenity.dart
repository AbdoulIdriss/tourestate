// models/amenity.dart
import 'package:flutter/material.dart';

class Amenity {
  final String name;
  final IconData icon;

  const Amenity({
    required this.name,
    required this.icon,
  });

  // Convert to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconCodePoint': icon.codePoint,
    };
  }

  // Create from Firestore Map
  factory Amenity.fromMap(Map<String, dynamic> map) {
    final iconCodePoint = map['iconCodePoint'] ?? Icons.check.codePoint;
    IconData icon;
    
    // Use predefined icons to avoid non-constant IconData creation
    switch (iconCodePoint) {
      case 0xe3c9: // Icons.check.codePoint
        icon = Icons.check;
        break;
      case 0xe3c7: // Icons.wifi.codePoint
        icon = Icons.wifi;
        break;
      case 0xe3c8: // Icons.pool.codePoint
        icon = Icons.pool;
        break;
      case 0xe3ca: // Icons.local_parking.codePoint
        icon = Icons.local_parking;
        break;
      case 0xe3cb: // Icons.ac_unit.codePoint
        icon = Icons.ac_unit;
        break;
      case 0xe3cc: // Icons.fitness_center.codePoint
        icon = Icons.fitness_center;
        break;
      case 0xe3cd: // Icons.restaurant.codePoint
        icon = Icons.restaurant;
        break;
      case 0xe3ce: // Icons.local_bar.codePoint
        icon = Icons.local_bar;
        break;
      case 0xe3cf: // Icons.spa.codePoint
        icon = Icons.spa;
        break;
      case 0xe3d0: // Icons.security.codePoint
        icon = Icons.security;
        break;
      default:
        icon = Icons.check;
    }
    
    return Amenity(
      name: map['name'] ?? '',
      icon: icon,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Amenity &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          icon == other.icon;

  @override
  int get hashCode => name.hashCode ^ icon.hashCode;
}