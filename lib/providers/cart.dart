import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  bool get isEmpty {
    return _items.isEmpty;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((_, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (CartItem existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    CartItem undoedProduct = _items[productId] as CartItem;
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingValue) => CartItem(
          id: existingValue.id,
          title: existingValue.title,
          quantity: existingValue.quantity - 1,
          price: existingValue.price,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
    return undoedProduct;
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
