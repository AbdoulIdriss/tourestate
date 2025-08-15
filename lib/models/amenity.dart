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
    return Amenity(
      name: map['name'] ?? '',
      icon: IconData(
        map['iconCodePoint'] ?? Icons.check.codePoint,
        fontFamily: 'MaterialIcons',
      ),
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