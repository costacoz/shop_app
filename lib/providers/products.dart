import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_flutter_app/helpers/global_config.dart';
import '../models/http_exception.dart';

import 'product.dart';

/// Important note!
/// We change Provider's data only here, because only here can we call notifyListeners.
/// If we change the data elsewhere, widgets won't be notified about data changes, thus not being rebuilt/updated.

/// Another case with _items of it being an array of objects, when an object in this array changes.
/// It is normal if the object's properties changes. But the reference to object should be changed only here, again.
/// If we want to listen to object's property changes, we need to make sure that object of this array also
/// implements ChangeNotifier mixin and do changes in that separate file.

class Products with ChangeNotifier {
  List<Product> _items = [];

  /// Should always return copy of data, to avoid modifying it directly.
  /// Otherwise notifyListeners() method wouldn't be able to notify about changes in the state.
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  /// "Optimistic updating" approach. For better user experience.
  Future<void> removeProduct(id) async {
    final _uriProduct = GlobalConfig.getUriByProductId(id);
    final existingProductIndex = _items.indexWhere((product) => product.id == id);
    dynamic existingProduct = _items[existingProductIndex];

    /// 1. First remove.
    _items.removeAt(existingProductIndex);
    notifyListeners();

    /// 2. Then send request.
    final response = await http.delete(_uriProduct);

    /// http package doesn't throw error for DELETE method, only for GET/POST.
    /// To check whether error occured, need to check statusCode in successful .then() block!
    /// To see how it works, remove '.json' part from getUriPerProductId() method.
    if (response.statusCode >= 400) {
      // 3. Re-add it, if some error happened.
      await Future.delayed(const Duration(seconds: 10));
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Delete method failed', statusCode: response.statusCode, uri: _uriProduct);
    }

    // Deletion request  success. Reference to object is no longer needed.
    existingProduct = null;
  }

  Future<void> fetchAndSetProducts() async {
    try {
      final response = await http.get(GlobalConfig.productsUri);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, productData) {
        loadedProducts.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          price: productData['price'],
          isFavorite: productData['isFavorite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    final _json = json.encode({
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'isFavorite': product.isFavorite,
    });

    try {
      final _response = await http.post(GlobalConfig.productsUri, body: _json);
      final _productWithId = Product(
        id: json.decode(_response.body)["name"],
        price: product.price,
        imageUrl: product.imageUrl,
        description: product.description,
        title: product.title,
      );
      _items.insert(0, _productWithId); // add to a start of the list
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product updatedProduct) async {
    final productIndex = _items.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      final _uriProduct = GlobalConfig.getUriByProductId(id);
      try {
        await http.patch(_uriProduct,
            body: json.encode({
              'title': updatedProduct.title,
              'price': updatedProduct.price,
              'imageUrl': updatedProduct.imageUrl,
              'description': updatedProduct.description,
            }));
      } catch (e) {
        throw e;
      }
      _items[productIndex] = updatedProduct;
      notifyListeners();
    }
  }

  /// Add methods like findById() in the store, to make widgets leaner.
  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }
}
