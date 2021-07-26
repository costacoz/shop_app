import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/orders.dart' show Orders;
import 'package:shop_flutter_app/widgets/main_drawer.dart';
import 'package:shop_flutter_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: MainDrawer(),
      body: orders.items.length > 0 ? ListView.builder(
        itemBuilder: (ctx, idx) => OrderItem(order: orders.items[idx]),
        itemCount: orders.items.length,
      ) : Center(child: Text('You have no previous orders. Order something now!')),
    );
  }
}
