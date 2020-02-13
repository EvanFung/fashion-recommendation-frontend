import 'package:flutter/foundation.dart';

class Favorites with ChangeNotifier {
  Set<String> _favorites = Set();
  String authId;
  String userId;
  String uId;
  Favorites(this.authId, this.userId, this.uId);

  Set<String> get favorites {
    return _favorites;
  }

  void addFavorite(String favorite) {
    _favorites.add(favorite);
    notifyListeners();
  }

  void removeFavorite(String fav) {
    _favorites.removeWhere((favorite) {
      return favorite == fav;
    });
    notifyListeners();
  }
}
