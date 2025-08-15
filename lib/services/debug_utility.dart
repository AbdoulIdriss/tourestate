import 'package:estate/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DebugUtility {
  static Future<void> checkAndFixProperties() async {
    try {
      print('🔍 Checking Firebase properties...');
      
      final snapshot = await FirebaseFirestore.instance.collection('properties').get();
      print('📊 Total properties in Firebase: ${snapshot.docs.length}');
      
      int missingIsActive = 0;
      int activeProperties = 0;
      int inactiveProperties = 0;
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        print('🏠 Property: ${data['title'] ?? 'No title'} (ID: ${doc.id})');
        print('   - isActive: ${data['isActive'] ?? 'MISSING'}');
        
        if (!data.containsKey('isActive')) {
          missingIsActive++;
        } else if (data['isActive'] == true) {
          activeProperties++;
        } else {
          inactiveProperties++;
        }
      }
      
      print('\n📈 Summary:');
      print('   - Properties missing isActive field: $missingIsActive');
      print('   - Active properties: $activeProperties');
      print('   - Inactive properties: $inactiveProperties');
      
      if (missingIsActive > 0) {
        print('\n🔧 Fixing properties with missing isActive field...');
        await FirebaseService.updatePropertiesWithIsActive();
        print('✅ Properties fixed!');
      } else {
        print('\n✅ All properties already have the isActive field');
      }
      
    } catch (e) {
      print('❌ Error checking properties: $e');
    }
  }
  
  static Future<void> listAllProperties() async {
    try {
      print('📋 Listing all properties in Firebase:');
      
      final snapshot = await FirebaseFirestore.instance.collection('properties').get();
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        print('🏠 ${data['title'] ?? 'No title'}');
        print('   - ID: ${doc.id}');
        print('   - Location: ${data['location'] ?? 'No location'}');
        print('   - Price: ${data['price'] ?? 'No price'}');
        print('   - isActive: ${data['isActive'] ?? 'MISSING'}');
        print('   - Property Type: ${data['propertyType'] ?? 'No type'}');
        print('   - Listing Type: ${data['listingType'] ?? 'No listing type'}');
        print('---');
      }
      
    } catch (e) {
      print('❌ Error listing properties: $e');
    }
  }
}
