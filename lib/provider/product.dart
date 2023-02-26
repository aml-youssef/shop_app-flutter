import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.description,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggelFavoriteState() async {
    final oldState = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final Uri url = Uri.parse(
        'https://shop-app-68554-default-rtdb.firebaseio.com/products/$id.json');
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );
      if (response.statusCode >= 400) {
        isFavorite = oldState;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldState;
      notifyListeners();
      throw error;
    }
  }
}
