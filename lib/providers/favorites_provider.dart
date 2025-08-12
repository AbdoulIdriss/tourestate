import 'package:flutter/foundation.dart';
import 'package:estate/models/property.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Property> _favorites = [];

  List<Property> get favorites => _favorites;

  void toggleFavorite(Property property) {
    if (_favorites.contains(property)) {
      _favorites.remove(property);
    } else {
      _favorites.add(property);
    }
    notifyListeners(); // Notify listeners that the list has changed
  }

  bool isFavorite(Property property) {
    return _favorites.contains(property);
  }
}