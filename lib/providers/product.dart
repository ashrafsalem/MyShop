import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool val) {
    isFavorite = val;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldValue = isFavorite;
    final url = 'https://flutter-update-9681a.firebaseio.com/products/$id.json';
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.patch(
        url,
        body: json.encode({'isFavorite': isFavorite}),
      );

      if (response.statusCode >= 400) {
        _setFavValue(oldValue);
      }
    } catch (error) {
      _setFavValue(oldValue);
    }
  }
}
