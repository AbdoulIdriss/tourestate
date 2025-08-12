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

    // A method to convert a reservation object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
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
}