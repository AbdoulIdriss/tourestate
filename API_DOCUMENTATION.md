# API Documentation - Estate App

## 🔥 Firebase Firestore Collections

### Properties Collection (`properties`)

#### Document Structure
```json
{
  "id": "string",
  "title": "string",
  "description": "string",
  "price": "number",
  "location": "string",
  "listingType": "string", // "rent" or "sale"
  "propertyType": "string", // "apartment", "house", "villa", etc.
  "images": ["string"],
  "virtualTourUrl": "string?",
  "amenities": [
    {
      "id": "string",
      "name": "string",
      "icon": "string"
    }
  ],
  "bedrooms": "number",
  "bathrooms": "number",
  "isActive": "boolean",
  "dateAdded": "timestamp"
}
```

#### Query Examples
```dart
// Get all active properties
FirebaseService.getProperties()

// Get properties by listing type
properties.where('listingType', isEqualTo: 'rent')

// Get properties by price range
properties.where('price', isGreaterThanOrEqualTo: 100000)
          .where('price', isLessThanOrEqualTo: 500000)
```

### User Reservations Collection (`users/{userId}/reservations`)

#### Document Structure
```json
{
  "reservationId": "string",
  "propertyId": "string",
  "userId": "string",
  "checkIn": "timestamp",
  "checkOut": "timestamp",
  "totalPrice": "number",
  "status": "string", // "pending", "confirmed", "completed", "cancelled"
  "createdAt": "timestamp"
}
```

#### Query Examples
```dart
// Get user reservations
FirebaseService.getUserReservations()

// Get reservations by status
reservations.where('status', isEqualTo: 'confirmed')
```

## 🔐 Firebase Authentication

### User Object
```dart
User {
  uid: "string",
  email: "string",
  displayName: "string?",
  photoURL: "string?",
  emailVerified: "boolean"
}
```

### Authentication Methods
```dart
// Sign in with email/password
FirebaseAuth.instance.signInWithEmailAndPassword(email, password)

// Sign up with email/password
FirebaseAuth.instance.createUserWithEmailAndPassword(email, password)

// Sign out
FirebaseAuth.instance.signOut()

// Get current user
FirebaseAuth.instance.currentUser
```

## 🗺️ Google Maps API

### API Key Configuration
- **Android**: `android/app/src/main/res/values/secrets.xml`
- **iOS**: `ios/Runner/Secrets.plist`
- **Web**: Environment variables

### Required APIs
- Maps SDK for Android
- Maps SDK for iOS
- Places API (for location search)

### Usage Limits
- 25,000 map loads per day (free tier)
- 1,000 places API requests per day (free tier)

## 📱 Platform-Specific APIs

### Android Permissions
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS Permissions
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to show nearby properties</string>
```

## 🔧 Service Methods

### FirebaseService

#### Property Operations
```dart
// Get all properties with real-time updates
static Stream<List<Property>> getProperties()

// Update properties with missing fields
static Future<void> updatePropertiesWithIsActive()

// Create sample reservations for testing
static Future<void> createSampleReservations()
```

#### Reservation Operations
```dart
// Get user reservations
static Stream<List<Reservation>> getUserReservations()

// Create new reservation
static Future<void> createReservation(Reservation reservation)

// Update reservation status
static Future<void> updateReservationStatus(String reservationId, String status)
```

### AuthUtils

#### Authentication Checks
```dart
// Check if user is authenticated
static bool isUserAuthenticated()

// Require authentication for action
static Future<bool> requireAuthentication(BuildContext context, String action)

// Show authentication dialog
static Future<bool> showAuthDialog(BuildContext context, String action)
```

## 📊 Data Models

### Property Model
```dart
class Property {
  final String id;
  final String title;
  final String description;
  final double price;
  final String location;
  final ListingType listingType;
  final PropertyType propertyType;
  final List<String> images;
  final String? virtualTourUrl;
  final List<Amenity> amenities;
  final int bedrooms;
  final int bathrooms;
  final bool isActive;
  final DateTime dateAdded;
  
  // Computed properties
  String get listingTypeDisplay;
  String get propertyTypeDisplay;
  bool get hasVirtualTour;
}
```

### Reservation Model
```dart
class Reservation {
  final String reservationId;
  final String propertyId;
  final String userId;
  final DateTime checkIn;
  final DateTime checkOut;
  final double totalPrice;
  final ReservationStatus status;
  final DateTime createdAt;
}
```

### Amenity Model
```dart
class Amenity {
  final String id;
  final String name;
  final String icon;
}
```

## 🔍 Filtering API

### FilterCriteria
```dart
class FilterCriteria {
  final double minPrice;
  final double maxPrice;
  final int? minBeds;
  final int? maxBeds;
  final int? minBaths;
  final int? maxBaths;
  final List<String> selectedListingTypes;
  final List<String> selectedPropertyTypes;
  final bool? hasVirtualTour;
}
```

### Filter Application
```dart
List<Property> _getFilteredProperties(List<Property> properties) {
  return properties.where((property) {
    // Price filter
    if (property.price < filters.minPrice || property.price > filters.maxPrice) {
      return false;
    }
    
    // Listing type filter
    if (filters.selectedListingTypes.isNotEmpty) {
      final propertyListingType = property.listingTypeDisplay;
      final matchesListingType = filters.selectedListingTypes.contains(propertyListingType);
      if (!matchesListingType) return false;
    }
    
    // Property type filter
    if (filters.selectedPropertyTypes.isNotEmpty) {
      final propertyType = property.propertyTypeDisplay;
      final matchesPropertyType = filters.selectedPropertyTypes.contains(propertyType);
      if (!matchesPropertyType) return false;
    }
    
    // Virtual tour filter
    if (filters.hasVirtualTour == true && !property.hasVirtualTour) {
      return false;
    }
    
    return true;
  }).toList();
}
```

## 🧪 Testing APIs

### Widget Testing
```dart
// Test property card
testWidgets('Property card displays correctly', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: EstateCard(property: testProperty),
    ),
  );
  
  expect(find.text(testProperty.title), findsOneWidget);
  expect(find.text('${testProperty.price} FCFA'), findsOneWidget);
});
```

### Unit Testing
```dart
// Test property model
test('Property fromMap handles missing fields', () {
  final map = {'id': '1', 'title': 'Test'};
  final property = Property.fromMap(map);
  
  expect(property.isActive, true); // Default value
  expect(property.dateAdded, isA<DateTime>()); // Should be set
});
```

## 🚀 Deployment APIs

### Build Commands
```bash
# Android
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

### Firebase Hosting
```bash
# Deploy to Firebase
firebase deploy

# Deploy only hosting
firebase deploy --only hosting
```

## 📊 Analytics APIs

### Firebase Analytics
```dart
// Track user actions
FirebaseAnalytics.instance.logEvent(
  name: 'property_viewed',
  parameters: {
    'property_id': property.id,
    'property_type': property.propertyType.name,
  },
);
```

### Custom Events
```dart
// Track filter usage
FirebaseAnalytics.instance.logEvent(
  name: 'filter_applied',
  parameters: {
    'filter_type': 'price_range',
    'min_price': filters.minPrice,
    'max_price': filters.maxPrice,
  },
);
```

## 🔒 Security Rules

### Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Properties collection - read only for authenticated users
    match /properties/{propertyId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admin can write
    }
    
    // User reservations - user can only access their own
    match /users/{userId}/reservations/{reservationId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 📞 Error Handling

### Common Error Codes
```dart
// Firebase Auth errors
'user-not-found': 'No user found with this email'
'wrong-password': 'Incorrect password'
'email-already-in-use': 'Email already registered'
'weak-password': 'Password is too weak'

// Firestore errors
'permission-denied': 'Insufficient permissions'
'not-found': 'Document not found'
'unavailable': 'Service temporarily unavailable'
```

### Error Handling Pattern
```dart
try {
  final result = await FirebaseService.someOperation();
  return result;
} catch (e) {
  print('Error: $e');
  // Handle error appropriately
  rethrow;
}
```

---

For more detailed information, see the [Developer Guide](DEVELOPER_GUIDE.md) and [Technical Documentation](TECHNICAL_DOCUMENTATION.md).
