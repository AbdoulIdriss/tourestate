# Developer Guide - Estate App

## 🚀 Quick Start

1. **Clone & Setup**
   ```bash
   git clone <repository-url>
   cd estate
   flutter pub get
   ```

2. **Configure API Keys**
   - Follow [API_KEYS_SETUP.md](API_KEYS_SETUP.md)
   - Copy template files and add your keys

3. **Run the App**
   ```bash
   flutter run
   ```

## 🏗️ Architecture

### State Management
- **Provider Pattern**: Used for favorites and user state
- **StreamBuilder**: Real-time Firebase data updates
- **FutureBuilder**: One-time data loading

### Key Components

#### Data Models
- `Property`: Real estate properties with Firebase integration
- `Reservation`: User bookings with status management
- `Amenity`: Property features and amenities

#### Services
- `FirebaseService`: All Firebase operations
- `DataMigrationService`: Data migration utilities
- `AuthUtils`: Authentication helper functions

#### Screens
- `HomeScreen`: Main navigation and tab management
- `HomeContentScreen`: Property listing with filtering
- `EstateDetailScreen`: Detailed property view
- `MapScreen`: Interactive Google Maps
- `ProfileScreen`: User profile and settings
- `ReservationsScreen`: User reservation management

## 🔥 Firebase Integration

### Collections
- `properties`: Property data
- `users/{userId}/reservations`: User reservations
- `users/{userId}/favorites`: User favorites

### Key Methods
```dart
// Get properties with real-time updates
FirebaseService.getProperties()

// Get user reservations
FirebaseService.getUserReservations()

// Create sample data
FirebaseService.createSampleReservations()
```

## 🗺️ Map Implementation

### Features
- Google Maps integration
- Color-coded markers (blue=rent, red=sale)
- Interactive bottom sheets
- Authentication-protected interactions

### Key Components
- `MapScreen`: Main map interface
- `_createMarkers()`: Marker creation with authentication
- `_showPropertyList()`: Bottom sheet property list

## 🔐 Authentication System

### Flow
1. User opens app → Home screen (browsing allowed)
2. User tries to interact → Authentication check
3. If not authenticated → Auth dialog → Auth screen
4. After authentication → Full app access

### Protected Actions
- Adding to favorites
- Booking properties
- Viewing virtual tours
- Accessing profile features

### Implementation
```dart
// Check authentication
AuthUtils.requireAuthentication(context, 'action description')

// Show auth dialog
AuthUtils.showAuthDialog(context, 'action description')
```

## 🎨 UI Components

### Custom Widgets
- `EstateCard`: Property display cards
- `FilterDialog`: Advanced filtering interface
- `CustomNavigationBar`: Bottom navigation
- `CustomSearchBar`: Search functionality

### Key Features
- Responsive design
- Material Design 3
- Google Fonts integration
- Error handling with fallbacks

## 🔍 Filtering System

### FilterCriteria
```dart
class FilterCriteria {
  final double minPrice;
  final double maxPrice;
  final int? minBeds;
  final int? maxBeds;
  final List<String> selectedListingTypes;
  final List<String> selectedPropertyTypes;
  final bool? hasVirtualTour;
}
```

### Filter Types
- Price range (0 - 500M CFA)
- Bedrooms and bathrooms
- Listing type (rent/sale)
- Property type (apartment/house/etc.)
- Virtual tour availability

## 📱 Platform Support

### Android
- Minimum SDK: 21
- Google Maps integration
- Firebase services
- Location permissions

### iOS
- Minimum iOS: 12.0
- Google Maps integration
- Firebase services
- Location permissions

### Web
- Responsive design
- Firebase hosting ready
- Progressive Web App features

## 🧪 Testing

### Running Tests
```bash
# All tests
flutter test

# Specific test
flutter test test/widget_test.dart

# With coverage
flutter test --coverage
```

### Test Structure
- Widget tests for UI components
- Unit tests for business logic
- Integration tests for Firebase operations

## 🚀 Deployment

### Android
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
firebase deploy
```

## 🔧 Configuration

### Environment Variables
- API keys in secrets files
- Firebase configuration
- Google Maps API keys

### Build Variants
- Debug: Development with hot reload
- Release: Production optimized
- Profile: Performance testing

## 🐛 Common Issues

### Build Errors
```bash
flutter clean
flutter pub get
flutter run
```

### API Key Issues
- Verify secrets files exist
- Check API key restrictions
- Ensure Firebase config is correct

### Platform Issues
- **iOS**: Check Xcode and deployment target
- **Android**: Verify SDK and build tools
- **Web**: Check browser compatibility

## 📊 Performance

### Optimizations
- Lazy loading for images
- Efficient list building
- Stream disposal
- Memory management

### Monitoring
- Debug mode for development
- Performance profiling
- Error tracking

## 🔮 Future Development

### Planned Features
- Push notifications
- Offline support
- Advanced analytics
- Multi-language support
- Dark mode
- Property comparison
- Chat system

### Technical Debt
- Increase test coverage
- Add more documentation
- Performance monitoring
- Security audits
- Dependency updates

## 🤝 Contributing

### Code Style
- Follow Dart/Flutter conventions
- Meaningful variable names
- Add comments for complex logic
- Keep functions focused

### Git Workflow
1. Fork repository
2. Create feature branch
3. Make changes
4. Add tests
5. Submit pull request

### Testing Requirements
- Unit tests for business logic
- Widget tests for UI components
- All tests must pass

## 📞 Support

### Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Google Maps Documentation](https://developers.google.com/maps)

### Getting Help
- Check this guide and README.md
- Create GitHub issues
- Use GitHub discussions

---

For detailed technical information, see [TECHNICAL_DOCUMENTATION.md](TECHNICAL_DOCUMENTATION.md)
