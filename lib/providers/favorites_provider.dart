import 'package:estate/models/appartment.dart';
import 'package:flutter/foundation.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Apartment> _favorites = [];

  List<Apartment> get favorites => _favorites;

  void toggleFavorite(Apartment apartment) {
    if (_favorites.contains(apartment)) {
      _favorites.remove(apartment);
    } else {
      _favorites.add(apartment);
    }
    notifyListeners(); // Notify listeners that the list has changed
  }

  bool isFavorite(Apartment apartment) {
    return _favorites.contains(apartment);
  }
}