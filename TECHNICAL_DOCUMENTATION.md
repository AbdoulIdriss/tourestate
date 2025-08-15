# Technical Documentation - Estate App

This document provides detailed technical information for developers working on the Estate app.

## 🏗️ Architecture Overview

### Design Patterns
- **MVVM (Model-View-ViewModel)**: Separation of concerns between UI and business logic
- **Provider Pattern**: State management using Flutter's Provider package
- **Repository Pattern**: Data access abstraction through services
- **Factory Pattern**: Model creation from Firebase data

### Directory Structure Deep Dive

```
lib/
├── main.dart                          # App entry point and initialization
├── firebase_options.dart              # Auto-generated Firebase configuration
├── models/                            # Data models and business entities
│   ├── property.dart                  # Property entity with Firebase integration
│   ├── reservation.dart               # Reservation entity with status management
│   └── amenity.dart                   # Amenity entity for property features
├── screens/                           # UI screens and page components
│   ├── auth_screen.dart               # Authentication flow management
│   ├── booking_screen.dart            # Property booking process
│   ├── payment_screen.dart            # Payment processing interface
│   └── pages/                         # Main application pages
│       ├── home.dart                  # Main navigation and tab management
│       ├── home_content.dart          # Property listing with filtering
│       ├── estate_detail.dart         # Detailed property view
│       ├── map_screen.dart            # Interactive map implementation
│       ├── profile_screen.dart        # User profile and settings
│       └── reservations_screen.dart   # User reservation management
├── widgets/                           # Reusable UI components
│   ├── estate_cards.dart              # Property card components
│   ├── navigation_bar.dart            # Custom bottom navigation
│   ├── filter_dialog.dart             # Advanced filtering interface
│   ├── custom_search_bar.dart         # Search functionality
│   ├── auth_form.dart                 # Authentication forms
│   ├── auth_header.dart               # Authentication screen header
│   ├── custom_text_form_field.dart    # Custom form field components
│   ├── filter_button.dart             # Filter toggle button
│   └── social_login_section.dart      # Social authentication buttons
├── services/                          # Business logic and external integrations
│   ├── firebase_service.dart          # Firebase operations and data management
│   └── data_migration_service.dart    # Data migration utilities
├── providers/                         # State management using Provider
│   └── favorites_provider.dart        # Favorites state management
└── utils/                             # Utility classes and helper functions
    └── auth_utils.dart                # Authentication utility functions
```

## 📊 Data Models

### Property Model (`lib/models/property.dart`)

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
  final bool isActive;
  final DateTime dateAdded;
  
  // Computed properties
  String get listingTypeDisplay => listingType.name.toUpperCase();
  String get propertyTypeDisplay => propertyType.name.toUpperCase();
  bool get hasVirtualTour => virtualTourUrl != null && virtualTourUrl!.isNotEmpty;
  
  // Factory constructor for Firebase integration
  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      location: map['location'] ?? '',
      listingType: ListingType.values.firstWhere(
        (e) => e.toString() == 'ListingType.${map['listingType']}',
        orElse: () => ListingType.rent,
      ),
      propertyType: PropertyType.values.firstWhere(
        (e) => e.toString() == 'PropertyType.${map['propertyType']}',
        orElse: () => PropertyType.apartment,
      ),
      images: List<String>.from(map['images'] ?? []),
      virtualTourUrl: map['virtualTourUrl'],
      amenities: (map['amenities'] as List<dynamic>?)
          ?.map((e) => Amenity.fromMap(e as Map<String, dynamic>))
          .toList() ?? [],
      isActive: map['isActive'] ?? true,
      dateAdded: map['dateAdded'] != null
          ? (map['dateAdded'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
  
  // Convert to Map for Firebase storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'location': location,
      'listingType': listingType.name,
      'propertyType': propertyType.name,
      'images': images,
      'virtualTourUrl': virtualTourUrl,
      'amenities': amenities.map((e) => e.toMap()).toList(),
      'isActive': isActive,
      'dateAdded': Timestamp.fromDate(dateAdded),
    };
  }
}
```

### Reservation Model (`lib/models/reservation.dart`)

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
  
  // Factory constructor
  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      reservationId: map['reservationId'] ?? '',
      propertyId: map['propertyId'] ?? '',
      userId: map['userId'] ?? '',
      checkIn: (map['checkIn'] as Timestamp).toDate(),
      checkOut: (map['checkOut'] as Timestamp).toDate(),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      status: ReservationStatus.values.firstWhere(
        (e) => e.toString() == 'ReservationStatus.${map['status']}',
        orElse: () => ReservationStatus.pending,
      ),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
```

## 🔄 State Management

### Provider Implementation

#### FavoritesProvider (`lib/providers/favorites_provider.dart`)

```dart
class FavoritesProvider with ChangeNotifier {
  final Set<String> _favoriteIds = {};
  
  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);
  
  bool isFavorite(Property property) => _favoriteIds.contains(property.id);
  
  void toggleFavorite(Property property) {
    if (_favoriteIds.contains(property.id)) {
      _favoriteIds.remove(property.id);
    } else {
      _favoriteIds.add(property.id);
    }
    notifyListeners();
  }
  
  void clearFavorites() {
    _favoriteIds.clear();
    notifyListeners();
  }
}
```

### Usage in Widgets

```dart
// In a widget
Consumer<FavoritesProvider>(
  builder: (context, favoritesProvider, child) {
    final isFav = favoritesProvider.isFavorite(property);
    return IconButton(
      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
      onPressed: () => favoritesProvider.toggleFavorite(property),
    );
  },
)
```

## 🔥 Firebase Integration

### FirebaseService (`lib/services/firebase_service.dart`)

#### Key Methods

```dart
class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Properties collection
  static CollectionReference<Map<String, dynamic>> get _propertiesCollection =>
      _firestore.collection('properties');
  
  // Get properties with real-time updates
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
              
              final Map<String, dynamic> propertyData = 
                  Map<String, dynamic>.from(data as Map);
              
              // Handle missing fields
              if (!propertyData.containsKey('isActive')) {
                propertyData['isActive'] = true;
              }
              if (!propertyData.containsKey('dateAdded')) {
                propertyData['dateAdded'] = Timestamp.now();
              }
              
              final property = Property.fromMap(propertyData);
              if (property.isActive) {
                properties.add(property);
              }
            } catch (e) {
              print('Error parsing property ${doc.id}: $e');
            }
          }
          
          // Sort by dateAdded (newest first)
          properties.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
          return properties;
        });
  }
  
  // Get user reservations
  static Stream<List<Reservation>> getUserReservations() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);
    
    return _userReservationsCollection(user.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Reservation.fromMap(doc.data()))
            .toList());
  }
}
```

## 🗺️ Map Implementation

### MapScreen (`lib/screens/pages/map_screen.dart`)

#### Key Features
- **Google Maps Integration**: Using `google_maps_flutter` package
- **Property Markers**: Color-coded markers based on listing type
- **Interactive Bottom Sheets**: Property details and list views
- **Authentication Checks**: Protected interactions for unauthenticated users

#### Marker Implementation

```dart
Set<Marker> _createMarkers(List<Property> properties) {
  return properties.map((property) {
    return Marker(
      markerId: MarkerId(property.id),
      position: LatLng(property.latitude, property.longitude),
      infoWindow: InfoWindow(
        title: property.title,
        snippet: '${property.price} FCFA',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(_getMarkerColor(property)),
      onTap: () async {
        final isAuthenticated = await AuthUtils.requireAuthentication(
          context,
          'view property details',
        );
        if (isAuthenticated) {
          setState(() {
            _selectedProperty = property;
            _showPropertyDetails = true;
          });
        }
      },
    );
  }).toSet();
}

double _getMarkerColor(Property property) {
  switch (property.listingType) {
    case ListingType.rent:
      return BitmapDescriptor.hueBlue;
    case ListingType.sale:
      return BitmapDescriptor.hueRed;
    default:
      return BitmapDescriptor.hueGreen;
  }
}
```

## 🔐 Authentication System

### AuthUtils (`lib/utils/auth_utils.dart`)

#### Authentication Flow

```dart
class AuthUtils {
  static bool isUserAuthenticated() {
    return FirebaseAuth.instance.currentUser != null;
  }
  
  static Future<bool> requireAuthentication(BuildContext context, String action) async {
    if (isUserAuthenticated()) {
      return true;
    }
    return await showAuthDialog(context, action);
  }
  
  static Future<bool> showAuthDialog(BuildContext context, String action) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign In Required'),
          content: Text('Please sign in to $action.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AuthScreen(),
                  ),
                );
              },
              child: const Text('Sign In'),
            ),
          ],
        );
      },
    ) ?? false;
  }
}
```

## 🎨 UI Components

### Custom Widgets

#### EstateCard (`lib/widgets/estate_cards.dart`)

```dart
class EstateCard extends StatelessWidget {
  final Property property;
  final VoidCallback? onTap;
  
  const EstateCard({
    super.key,
    required this.property,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with favorite button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    property.images.isNotEmpty ? property.images.first : '',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 50),
                      );
                    },
                  ),
                ),
                // Favorite button with authentication check
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () async {
                      final isAuthenticated = await AuthUtils.requireAuthentication(
                        context,
                        'add this property to favorites',
                      );
                      if (isAuthenticated) {
                        context.read<FavoritesProvider>().toggleFavorite(property);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Consumer<FavoritesProvider>(
                        builder: (context, favoritesProvider, child) {
                          final isFav = favoritesProvider.isFavorite(property);
                          return Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey[600],
                            size: 20,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Property details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: property.listingType == ListingType.rent
                              ? Colors.blue[100]
                              : Colors.green[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          property.listingTypeDisplay,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: property.listingType == ListingType.rent
                                ? Colors.blue[700]
                                : Colors.green[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    property.location,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${property.price.toStringAsFixed(0)} FCFA',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange[600],
                        ),
                      ),
                      if (property.hasVirtualTour)
                        Row(
                          children: [
                            Icon(Icons.view_in_ar, size: 16, color: Colors.blue[600]),
                            const SizedBox(width: 4),
                            Text(
                              '360° Tour',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.blue[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🔍 Filtering System

### FilterDialog (`lib/widgets/filter_dialog.dart`)

#### FilterCriteria Model

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
  
  const FilterCriteria({
    this.minPrice = 0,
    this.maxPrice = 500000000, // 500M CFA
    this.minBeds,
    this.maxBeds,
    this.minBaths,
    this.maxBaths,
    this.selectedListingTypes = const [],
    this.selectedPropertyTypes = const [],
    this.hasVirtualTour,
  });
  
  bool get hasActiveFilters {
    return minPrice > 0 ||
           minBeds != null ||
           maxBeds != null ||
           minBaths != null ||
           maxBaths != null ||
           selectedListingTypes.isNotEmpty ||
           selectedPropertyTypes.isNotEmpty ||
           hasVirtualTour == true;
  }
}
```

#### Filter Implementation

```dart
List<Property> _getFilteredProperties(List<Property> properties) {
  return properties.where((property) {
    // Price filter
    if (property.price < filters.minPrice || property.price > filters.maxPrice) {
      return false;
    }
    
    // Beds filter
    if (filters.minBeds != null && property.bedrooms < filters.minBeds!) {
      return false;
    }
    if (filters.maxBeds != null && property.bedrooms > filters.maxBeds!) {
      return false;
    }
    
    // Baths filter
    if (filters.minBaths != null && property.bathrooms < filters.minBaths!) {
      return false;
    }
    if (filters.maxBaths != null && property.bathrooms > filters.maxBaths!) {
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

## 🧪 Testing Strategy

### Widget Testing

```dart
// Example widget test
testWidgets('Property card displays correct information', (WidgetTester tester) async {
  final property = Property(
    id: '1',
    title: 'Test Property',
    description: 'Test Description',
    price: 100000,
    location: 'Test Location',
    listingType: ListingType.rent,
    propertyType: PropertyType.apartment,
    images: ['https://example.com/image.jpg'],
    amenities: [],
    isActive: true,
    dateAdded: DateTime.now(),
  );
  
  await tester.pumpWidget(
    MaterialApp(
      home: EstateCard(property: property),
    ),
  );
  
  expect(find.text('Test Property'), findsOneWidget);
  expect(find.text('100000 FCFA'), findsOneWidget);
  expect(find.text('Test Location'), findsOneWidget);
});
```

### Unit Testing

```dart
// Example unit test for Property model
test('Property fromMap handles missing fields correctly', () {
  final map = {
    'id': '1',
    'title': 'Test Property',
    'price': 100000,
    'location': 'Test Location',
  };
  
  final property = Property.fromMap(map);
  
  expect(property.id, '1');
  expect(property.title, 'Test Property');
  expect(property.isActive, true); // Default value
  expect(property.dateAdded, isA<DateTime>()); // Should be set
});
```

## 🚀 Performance Optimization

### Best Practices Implemented

1. **Lazy Loading**: Images loaded on demand
2. **Pagination**: Large lists handled efficiently
3. **Caching**: Firebase data cached locally
4. **Memory Management**: Proper disposal of streams and controllers
5. **Image Optimization**: Error handling and placeholder images

### Code Examples

```dart
// Stream disposal in StatefulWidget
@override
void dispose() {
  _searchController.dispose();
  super.dispose();
}

// Efficient list building
ListView.builder(
  itemCount: filteredProperties.length,
  itemBuilder: (context, index) {
    return EstateCard(
      property: filteredProperties[index],
      onTap: () => _navigateToDetail(filteredProperties[index]),
    );
  },
)
```

## 🔧 Configuration Management

### Environment-Specific Settings

```dart
// Example configuration class
class AppConfig {
  static const String firebaseProjectId = 'real-estate-600f3';
  static const String googleMapsApiKey = 'YOUR_API_KEY';
  static const bool enableDebugMode = true;
  static const String appVersion = '1.0.0';
}
```

## 📱 Platform-Specific Code

### Android Configuration

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.INTERNET" />
    
    <application
        android:label="estate"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="@string/google_maps_api_key" />
    </application>
</manifest>
```

### iOS Configuration

```swift
// ios/Runner/AppDelegate.swift
import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Load API key from secrets file
    if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
       let secrets = NSDictionary(contentsOfFile: path),
       let apiKey = secrets["GOOGLE_MAPS_API_KEY"] as? String {
      GMSServices.provideAPIKey(apiKey)
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## 🔄 Data Migration

### MigrationService (`lib/services/data_migration_service.dart`)

```dart
class DataMigrationService {
  static Future<void> migrateProperties() async {
    try {
      final snapshot = await FirebaseService.getPropertiesCollection().get();
      final batch = FirebaseFirestore.instance.batch();
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data != null && !data.containsKey('isActive')) {
          batch.update(doc.reference, {'isActive': true});
        }
        if (data != null && !data.containsKey('dateAdded')) {
          batch.update(doc.reference, {'dateAdded': Timestamp.now()});
        }
      }
      
      await batch.commit();
      print('Properties migration completed successfully');
    } catch (e) {
      print('Error during properties migration: $e');
      rethrow;
    }
  }
}
```

## 📊 Analytics and Monitoring

### Error Tracking

```dart
// Example error tracking
void logError(String error, StackTrace? stackTrace) {
  print('Error: $error');
  if (stackTrace != null) {
    print('StackTrace: $stackTrace');
  }
  // Add Firebase Crashlytics or other error tracking here
}

// Usage in try-catch blocks
try {
  // Some operation
} catch (e, stackTrace) {
  logError('Operation failed: $e', stackTrace);
}
```

## 🔮 Future Enhancements

### Planned Features

1. **Push Notifications**: Firebase Cloud Messaging integration
2. **Offline Support**: Local database with sync
3. **Advanced Analytics**: User behavior tracking
4. **Multi-language Support**: Internationalization
5. **Dark Mode**: Theme switching
6. **Property Comparison**: Side-by-side property comparison
7. **Chat System**: In-app messaging
8. **Payment Integration**: Stripe/PayPal integration

### Technical Debt

1. **Test Coverage**: Increase unit and integration test coverage
2. **Code Documentation**: Add more inline documentation
3. **Performance Monitoring**: Add performance tracking
4. **Security Audit**: Regular security reviews
5. **Dependency Updates**: Keep dependencies up to date

---

This technical documentation should be updated as the project evolves. For questions or contributions, please refer to the main README.md file.
