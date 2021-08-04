import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../helpers/global_config.dart';
import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String? token, String? userId) async {
    if ([token, userId].contains(null)) return;

    final oldStatus = isFavorite;
    _setFavorite(!isFavorite);

    final String body = json.encode(isFavorite);
    try {
      final http.Response response = await http.put(
        GlobalConfig.getUriUserIsFavoriteForProduct(productId: id, userId: userId, token: token),
        body: body,
      );
      if (response.statusCode >= 400) {
        _setFavorite(oldStatus);
        throw HttpException('Patch unsuccessful for isFavorite');
      }
    } catch (e) {
      print(e);
      _setFavorite(oldStatus);
      rethrow;
    }
  }

  void _setFavorite(bool state) {
    isFavorite = state;
    notifyListeners();
  }
}
