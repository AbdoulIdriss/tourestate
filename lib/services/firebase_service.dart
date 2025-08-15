import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:estate/models/property.dart';
import 'package:estate/models/reservation.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Properties Collection Reference
  static CollectionReference get _propertiesCollection =>
      _firestore.collection('properties');

  // User's Reservations Collection Reference
  static CollectionReference _userReservationsCollection(String userId) =>
      _firestore.collection('users').doc(userId).collection('reservations');

  // Save Property to Firestore
  static Future<void> saveProperty(Property property) async {
    try {
      await _propertiesCollection.doc(property.id).set(property.toMap());
      print('Property saved successfully: ${property.title}');
    } catch (e) {
      print('Error saving property: $e');
      rethrow;
    }
  }

  // Get All Properties
  static Stream<List<Property>> getProperties() {
    return _propertiesCollection
        .snapshots()
        .map((snapshot) {
          final docs = snapshot.docs;
          final properties = <Property>[];
          
          for (var doc in docs) {
            try {
              final data = doc.data();
              if (data == null) continue;
              
              final Map<String, dynamic> propertyData = Map<String, dynamic>.from(data as Map);
              
              // If isActive field doesn't exist, treat it as active
              if (!propertyData.containsKey('isActive')) {
                propertyData['isActive'] = true;
              }
              // If dateAdded field doesn't exist, add it
              if (!propertyData.containsKey('dateAdded')) {
                propertyData['dateAdded'] = Timestamp.now();
              }
              
              final property = Property.fromMap(propertyData);
              if (property.isActive) {
                properties.add(property);
              }
            } catch (e) {
              print('Error parsing property ${doc.id}: $e');
              // Continue with other properties
            }
          }
          
          // Sort by dateAdded (newest first)
          properties.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
          
          return properties;
        });
  }

  // Save Reservation to Firestore
  static Future<void> saveReservation(Reservation reservation) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _userReservationsCollection(user.uid)
          .doc(reservation.reservationId)
          .set(reservation.toMap());
      
      print('Reservation saved successfully: ${reservation.reservationId}');
    } catch (e) {
      print('Error saving reservation: $e');
      rethrow;
    }
  }

  // Get User's Reservations
  static Stream<List<Reservation>> getUserReservations() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _userReservationsCollection(user.uid)
        .orderBy('reservationDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Reservation.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // Save Multiple Properties (for initial data)
  static Future<void> saveMultipleProperties(List<Property> properties) async {
    try {
      WriteBatch batch = _firestore.batch();
      
      for (Property property in properties) {
        DocumentReference docRef = _propertiesCollection.doc(property.id);
        batch.set(docRef, property.toMap());
      }
      
      await batch.commit();
      print('${properties.length} properties saved successfully');
    } catch (e) {
      print('Error saving multiple properties: $e');
      rethrow;
    }
  }

  // Delete Property
  static Future<void> deleteProperty(String propertyId) async {
    try {
      await _propertiesCollection.doc(propertyId).update({'isActive': false});
      print('Property deactivated successfully: $propertyId');
    } catch (e) {
      print('Error deactivating property: $e');
      rethrow;
    }
  }

  // Update all properties to include isActive field if missing
  static Future<void> updatePropertiesWithIsActive() async {
    try {
      final snapshot = await _propertiesCollection.get();
      final batch = _firestore.batch();
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data != null && data is Map && !data.containsKey('isActive')) {
          batch.update(doc.reference, {'isActive': true});
          print('Updated property ${doc.id} with isActive: true');
        }
      }
      
      await batch.commit();
      print('All properties updated with isActive field');
    } catch (e) {
      print('Error updating properties with isActive field: $e');
      rethrow;
    }
  }

  // Create sample reservations for testing
  static Future<void> createSampleReservations() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final sampleReservations = [
        Reservation(
          reservationId: 'res_001',
          userId: user.uid,
          propertyTitle: 'Modern Family Apartment',
          propertyLocation: 'Bonamoussadi, Douala',
          propertyImageUrl: 'https://i.pinimg.com/1200x/87/c5/1a/87c51a688a123bf0dcb07a8540145a63.jpg',
          checkInDate: DateTime.now().add(const Duration(days: 10)),
          checkOutDate: DateTime.now().add(const Duration(days: 15)),
          amountPaid: 80000,
          totalPrice: 400000,
          paymentStatus: 'Partial Payment',
          reservationDate: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Reservation(
          reservationId: 'res_002',
          userId: user.uid,
          propertyTitle: 'Luxury Beachside Villa',
          propertyLocation: 'Kribi, South Region',
          propertyImageUrl: 'https://i.pinimg.com/1200x/d2/13/3d/d2133ddf98ac417716a7eeb0ee8ccf02.jpg',
          checkInDate: DateTime.now().subtract(const Duration(days: 20)),
          checkOutDate: DateTime.now().subtract(const Duration(days: 15)),
          amountPaid: 75000,
          totalPrice: 75000,
          paymentStatus: 'Paid in Full',
          reservationDate: DateTime.now().subtract(const Duration(days: 30)),
        ),
        Reservation(
          reservationId: 'res_003',
          userId: user.uid,
          propertyTitle: 'Serene Mountain House',
          propertyLocation: 'Dschang, West Region',
          propertyImageUrl: 'https://i.pinimg.com/1200x/29/09/85/29098575fdbf82e69b60b4c02efd2050.jpg',
          checkInDate: DateTime.now().add(const Duration(days: 30)),
          checkOutDate: DateTime.now().add(const Duration(days: 35)),
          amountPaid: 45000,
          totalPrice: 45000,
          paymentStatus: 'Paid in Full',
          reservationDate: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];

      final batch = _firestore.batch();
      
      for (Reservation reservation in sampleReservations) {
        DocumentReference docRef = _userReservationsCollection(user.uid).doc(reservation.reservationId);
        batch.set(docRef, reservation.toMap());
      }
      
      await batch.commit();
      print('Sample reservations created successfully');
    } catch (e) {
      print('Error creating sample reservations: $e');
      rethrow;
    }
  }
}