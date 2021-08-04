import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_flutter_app/helpers/global_config.dart';
import 'package:shop_flutter_app/models/http_exception.dart';
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
  String? authToken;
  String? _userId;

  List<OrderItem> _items;

  Orders([this.authToken, this._userId, this._items = const []]);

  List<OrderItem> get items => [..._items];

  Future<void> fetchAndSetOrders() async {
    try {
      final http.Response response = await http.get(GlobalConfig.getOrdersUri(authToken, _userId));
      final decodedResponse = json.decode(response.body);
      if (decodedResponse == null) return;
      final Map<String, dynamic> orders = decodedResponse;
      final List<OrderItem> _loadedOrders = [];
      orders.forEach((orderKey, orderValue) {
            _loadedOrders.add(
              OrderItem(
                id: orderKey,
                total: orderValue['total'],
                dateTime: DateTime.parse(orderValue['dateTime']),
                cartItems: (orderValue['cartItems'] as List)
                    .map((cartItem) => CartItem(
                          id: cartItem['id'],
                          title: cartItem['title'],
                          quantity: cartItem['quantity'],
                          price: cartItem['price'],
                        ))
                    .toList(),
              ),
            );
          });
      _items = _loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addOrder(List<CartItem> cartItems, double total) async {
    final timestamp = DateTime.now();
    final String orderJson = json.encode({
      'total': total,
      'dateTime': timestamp.toIso8601String(),
      'cartItems': cartItems
          .map((item) => {
                'id': item.id,
                'quantity': item.quantity,
                'price': item.price,
                'title': item.title,
              })
          .toList()
    });
    try {
      final http.Response response = await http.post(GlobalConfig.getOrdersUri(authToken, _userId), body: orderJson);
      _items.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          total: total,
          cartItems: cartItems,
          dateTime: timestamp,
        ),
      );
      notifyListeners();
    } catch (e) {
      print(e);
      throw HttpException('Error occured! Order was not added.');
    }
  }
}
