import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/models/http_exception.dart';
import 'package:shop_flutter_app/providers/orders.dart';
import 'package:shop_flutter_app/widgets/main_drawer.dart';
import 'package:shop_flutter_app/widgets/snackbar_simple.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$${cart.totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.headline6!.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: cart.isEmpty
                ? Center(
                    child: Text('No items in your cart. Add products and click ORDER NOW'),
                  )
                : ListView.builder(
                    itemBuilder: (ctx, index) => CartItem(
                      id: cart.items.values.toList()[index].id,
                      productId: cart.items.keys.toList()[index],
                      price: cart.items.values.toList()[index].price,
                      quantity: cart.items.values.toList()[index].quantity,
                      title: cart.items.values.toList()[index].title,
                    ),
                    itemCount: cart.itemCount,
                  ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final cart;

  OrderButton(this.cart);

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  void setLoading(state) {
    setState(() {
      _isLoading = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? CircularProgressIndicator() : TextButton(
      onPressed: _isLoading || widget.cart.isEmpty
          ? null
          : () async {
        setLoading(true);
        try {
          await Provider.of<Orders>(context, listen: false).addOrder(
            widget.cart.items.values.toList(),
            widget.cart.totalAmount,
          );
          widget.cart.clearCart();
        } on HttpException catch (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBarSimple(
              text: 'Error occured! Order was not completed.',
              color: Colors.red,
              iconData: Icons.error,
            ),
          );
        } finally {
          setLoading(false);
        }
      },
      child: Text('ORDER NOW'),
    );
  }
}
