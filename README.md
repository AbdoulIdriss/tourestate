# Estate App - Real Estate Management Platform

A modern Flutter application for browsing, booking, and managing real estate properties. The app provides a comprehensive platform for users to explore properties, make reservations, and manage their real estate activities.

## 🏠 Features

### Core Features
- **Property Browsing**: Browse properties with advanced filtering options
- **Property Details**: View detailed property information with images and virtual tours
- **Interactive Maps**: Explore properties on an interactive map with location-based search
- **User Authentication**: Secure sign-in/sign-up with email and social login options
- **Reservations**: Book properties and manage reservations
- **Favorites**: Save and manage favorite properties
- **Profile Management**: User profile and settings management

### Advanced Features
- **360° Virtual Tours**: Interactive virtual tours for properties
- **Advanced Filtering**: Filter by price, location, property type, amenities, and more
- **Real-time Data**: Live updates from Firebase Firestore
- **Cross-platform**: Works on iOS, Android, and Web
- **Responsive Design**: Optimized for different screen sizes

## 📱 Screenshots

*[Add screenshots of your app here]*

## 🛠️ Tech Stack

### Frontend
- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Provider
- **UI Components**: Material Design 3
- **Maps**: Google Maps Flutter
- **Fonts**: Google Fonts

### Backend & Services
- **Database**: Firebase Firestore
- **Authentication**: Firebase Auth
- **Storage**: Firebase Storage
- **Hosting**: Firebase Hosting (for web)
- **Maps API**: Google Maps Platform

### Development Tools
- **IDE**: VS Code / Android Studio
- **Version Control**: Git
- **Package Manager**: Pub
- **Testing**: Flutter Test

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.0 or higher)
- **Dart SDK** (2.17 or higher)
- **Android Studio** or **VS Code**
- **Git**
- **Firebase CLI** (optional, for deployment)
- **Xcode** (for iOS development, macOS only)

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/estate.git
cd estate
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Setup API Keys

**Important**: Follow the [API Keys Setup Guide](API_KEYS_SETUP.md) to configure your API keys securely.

### 4. Run the App

```bash
# For development
flutter run

# For specific platforms
flutter run -d chrome    # Web
flutter run -d android   # Android
flutter run -d ios       # iOS
```

## 📁 Project Structure

```
estate/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── firebase_options.dart        # Firebase configuration
│   ├── models/                      # Data models
│   │   ├── property.dart           # Property data model
│   │   ├── reservation.dart        # Reservation data model
│   │   └── amenity.dart            # Amenity data model
│   ├── screens/                     # UI screens
│   │   ├── auth_screen.dart        # Authentication screen
│   │   ├── booking_screen.dart     # Booking flow
│   │   ├── payment_screen.dart     # Payment processing
│   │   └── pages/                  # Main app pages
│   │       ├── home.dart           # Main home screen
│   │       ├── home_content.dart   # Property listing
│   │       ├── estate_detail.dart  # Property details
│   │       ├── map_screen.dart     # Interactive map
│   │       ├── profile_screen.dart # User profile
│   │       └── reservations_screen.dart # User reservations
│   ├── widgets/                     # Reusable widgets
│   │   ├── estate_cards.dart       # Property cards
│   │   ├── navigation_bar.dart     # Bottom navigation
│   │   ├── filter_dialog.dart      # Filter interface
│   │   ├── custom_search_bar.dart  # Search functionality
│   │   └── auth_form.dart          # Authentication forms
│   ├── services/                    # Business logic
│   │   ├── firebase_service.dart   # Firebase operations
│   │   └── data_migration_service.dart # Data migration utilities
│   ├── providers/                   # State management
│   │   └── favorites_provider.dart # Favorites state
│   └── utils/                       # Utility classes
│       └── auth_utils.dart         # Authentication utilities
├── android/                         # Android-specific files
├── ios/                            # iOS-specific files
├── web/                            # Web-specific files
├── test/                           # Test files
└── pubspec.yaml                    # Dependencies
```

## 🏗️ Architecture

### State Management
The app uses **Provider** for state management with the following providers:
- `FavoritesProvider`: Manages user's favorite properties
- Future: Additional providers for user data, filters, etc.

### Data Flow
1. **UI Layer**: Screens and widgets
2. **Business Logic**: Services and providers
3. **Data Layer**: Firebase Firestore and models

### Authentication Flow
1. User opens app → Home screen (browsing allowed)
2. User tries to interact (like, book, etc.) → Authentication check
3. If not authenticated → Auth dialog → Auth screen
4. After authentication → Full app access

## 📊 Data Models

### Property Model
```dart
class Property {
  final String id;
  final String title;
  final String description;
  final double price;
  final String location;
  final ListingType listingType; // rent/sale
  final PropertyType propertyType; // apartment/house/etc.
  final List<String> images;
  final String? virtualTourUrl;
  final List<Amenity> amenities;
  final bool isActive;
  final DateTime dateAdded;
  // ... other properties
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
  // ... other properties
}
```

## 🔧 Configuration

### Firebase Setup
1. Create a Firebase project
2. Enable Authentication, Firestore, and Storage
3. Download configuration files
4. Follow the [API Keys Setup Guide](API_KEYS_SETUP.md)

### Google Maps Setup
1. Create a Google Cloud project
2. Enable Maps SDK for Android/iOS
3. Create API keys with proper restrictions
4. Add keys to secrets files

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Test Structure
- `test/`: Contains all test files
- `test/widget_test.dart`: Main widget tests
- Future: Add unit tests, integration tests

## 🚀 Deployment

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS
```bash
# Build for iOS
flutter build ios --release
```

### Web
```bash
# Build for web
flutter build web --release

# Deploy to Firebase Hosting
firebase deploy
```

## 🔒 Security

### API Key Protection
- All API keys are stored in separate secrets files
- Secrets files are excluded from version control
- Template files provided for easy setup
- See [API Keys Setup Guide](API_KEYS_SETUP.md) for details

### Authentication
- Firebase Authentication for user management
- Email/password and social login support
- Secure token-based authentication
- User data protection

## 🐛 Troubleshooting

### Common Issues

#### Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

#### API Key Issues
- Verify API keys are correctly set in secrets files
- Check API key restrictions in Google Cloud Console
- Ensure Firebase configuration files are in place

#### Platform-Specific Issues
- **iOS**: Check Xcode and iOS deployment target
- **Android**: Verify Android SDK and build tools
- **Web**: Check browser compatibility

### Debug Mode
```bash
# Enable debug mode
flutter run --debug

# Check logs
flutter logs
```

## 🤝 Contributing

### Development Workflow
1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Add tests if applicable
5. Commit your changes: `git commit -m 'Add feature'`
6. Push to the branch: `git push origin feature-name`
7. Create a Pull Request

### Code Style
- Follow Dart/Flutter conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### Testing Requirements
- Add unit tests for new business logic
- Add widget tests for new UI components
- Ensure all tests pass before submitting PR

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Lead Developer**: [Your Name]
- **UI/UX Designer**: [Designer Name]
- **Backend Developer**: [Backend Developer Name]

## 📞 Support

### Getting Help
- **Documentation**: Check this README and API_KEYS_SETUP.md
- **Issues**: Create an issue on GitHub
- **Discussions**: Use GitHub Discussions for questions

### Contact
- **Email**: [your-email@example.com]
- **GitHub**: [@yourusername]

## 🔄 Changelog

### Version 1.0.0 (Current)
- Initial release
- Property browsing and filtering
- User authentication
- Reservation system
- Interactive maps
- Virtual tours
- Favorites system

### Future Versions
- [ ] Push notifications
- [ ] Offline support
- [ ] Advanced analytics
- [ ] Multi-language support
- [ ] Dark mode
- [ ] Property comparison
- [ ] Chat system

---

**Note**: This documentation is a living document. Please update it as the project evolves.
