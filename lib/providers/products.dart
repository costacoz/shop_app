import 'package:flutter/material.dart';
import 'product.dart';

/// Important note!
/// We change Provider's data only here, because only here can we call notifyListeners.
/// If we change the data elsewhere, widgets won't be notified about data changes, thus not being rebuilt/updated.

/// Another case with _items of it being an array of objects, when an object in this array changes.
/// It is normal if the object's properties changes. But the reference to object should be changed only here, again.
/// If we want to listen to object's property changes, we need to make sure that object of this array also
/// implements ChangeNotifier mixin and do changes in that separate file.

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  /// Should always return copy of data, to avoid modifying it directly.
  /// Otherwise notifyListeners() method wouldn't be able to notify about changes in the state.
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  void removeProduct(productId) {
    _items.removeWhere((product) => product.id == productId);
    notifyListeners();
  }

  void addProduct(Product product) {
    final productWithId = Product(
      id: DateTime.now().toString(),
      price: product.price,
      imageUrl: product.imageUrl,
      description: product.description,
      title: product.title,
    );
    _items.insert(0, productWithId); // add to a start of the list
    notifyListeners();
  }

  void updateProduct(String id, Product updatedProduct) {
    final productIndex = _items.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      _items[productIndex] = updatedProduct;
      notifyListeners();
    }
  }

  /// Add methods like findById() in the store, to make widgets leaner.
  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }
}
