import 'package:flutter/material.dart';
import 'package:shop_flutter_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double total;
  final List<CartItem> cartItems;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.total,
    required this.cartItems,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _items = [];

  List<OrderItem> get items => [..._items];

  void addOrder(List<CartItem> cartItems, double total) {
    _items.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        total: total,
        cartItems: cartItems,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
