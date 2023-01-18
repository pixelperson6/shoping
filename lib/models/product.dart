import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shoping/models/http_exeption.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      this.isFavorite = false});

  Future<void> toggleFavoriteStatus() async {
    final url = Uri.https('shoping-flutter-bc891-default-rtdb.firebaseio.com',
        '/products/$id.json');

    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response =
          await patch(url, body: json.encode({'isFavorite': isFavorite}));
      if (response.statusCode >= 0) {
        throw HttpException('error');
      }
    } catch (e) {
      isFavorite = !isFavorite;
      notifyListeners();
    }
  }
}
