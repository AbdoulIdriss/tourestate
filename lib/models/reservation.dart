// models/reservation.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final String reservationId;
  final String userId;
  final String propertyTitle;
  final String propertyLocation;
  final String propertyImageUrl;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final double amountPaid;
  final double totalPrice;
  final String paymentStatus; // e.g., "Partial Payment", "Paid in Full"
  final DateTime reservationDate;

  Reservation({
    required this.reservationId,
    required this.userId,
    required this.propertyTitle,
    required this.propertyLocation,
    required this.propertyImageUrl,
    required this.checkInDate,
    required this.checkOutDate,
    required this.amountPaid,
    required this.totalPrice,
    required this.paymentStatus,
    required this.reservationDate,
  });

  // Convert to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'reservationId': reservationId, // Include reservationId in the map
      'userId': userId,
      'propertyTitle': propertyTitle,
      'propertyLocation': propertyLocation,
      'propertyImageUrl': propertyImageUrl,
      'checkInDate': Timestamp.fromDate(checkInDate),
      'checkOutDate': Timestamp.fromDate(checkOutDate),
      'amountPaid': amountPaid,
      'totalPrice': totalPrice,
      'paymentStatus': paymentStatus,
      'reservationDate': Timestamp.fromDate(reservationDate),
    };
  }

  // Create from Firestore Map
  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      reservationId: map['reservationId'] ?? '',
      userId: map['userId'] ?? '',
      propertyTitle: map['propertyTitle'] ?? '',
      propertyLocation: map['propertyLocation'] ?? '',
      propertyImageUrl: map['propertyImageUrl'] ?? '',
      checkInDate: (map['checkInDate'] as Timestamp).toDate(),
      checkOutDate: (map['checkOutDate'] as Timestamp).toDate(),
      amountPaid: (map['amountPaid'] ?? 0.0).toDouble(),
      totalPrice: (map['totalPrice'] ?? 0.0).toDouble(),
      paymentStatus: map['paymentStatus'] ?? '',
      reservationDate: (map['reservationDate'] as Timestamp).toDate(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reservation &&
          runtimeType == other.runtimeType &&
          reservationId == other.reservationId &&
          userId == other.userId &&
          propertyTitle == other.propertyTitle &&
          propertyLocation == other.propertyLocation &&
          propertyImageUrl == other.propertyImageUrl &&
          checkInDate == other.checkInDate &&
          checkOutDate == other.checkOutDate &&
          amountPaid == other.amountPaid &&
          totalPrice == other.totalPrice &&
          paymentStatus == other.paymentStatus &&
          reservationDate == other.reservationDate;

  @override
  int get hashCode => Object.hash(
        reservationId,
        userId,
        propertyTitle,
        propertyLocation,
        propertyImageUrl,
        checkInDate,
        checkOutDate,
        amountPaid,
        totalPrice,
        paymentStatus,
        reservationDate,
      );
}