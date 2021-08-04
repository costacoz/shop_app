import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/orders.dart' show Orders;
import 'package:shop_flutter_app/widgets/main_drawer.dart';
import 'package:shop_flutter_app/widgets/order_item.dart';


class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late final future;

  /// Instead of this piece, where we were fetching Orders, the FutureBuilder is implemented below, in the widget tree.
  ///
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (!_fetched) {
  //     setLoading(true);
  //     Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((value) => _fetched = true).catchError((_) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBarSimple(
  //         text: 'Couldn\'t retrieve previous orders!',
  //         color: Colors.red,
  //         iconData: Icons.error,
  //       ));
  //     }).then((value) => setLoading(false));
  //   }
  // }

  @override
  void initState() {
    super.initState();

    /// Important place! (Best practice)
    /// We are calling future method here, to avoid calling in build() method.
    /// Because build() method could be called again for rebuild and this future method will be called again.
    /// Which could lead to redundant and potentially harmful method call.
    /// The 'listen: false' should still be present in order to work!
    future = Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
        future: future,
        builder: (ctx, futureResult) {
          if (futureResult.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (futureResult.error != null) {
              return Center(child: Text('An error occured!'));
            } else {
              return Consumer<Orders>(
                builder: (_, orders, __) => orders.items.isEmpty
                    ? Center(child: Text('You have no previous orders. Order something now!'))
                    : ListView.builder(
                        itemBuilder: (ctx, idx) => OrderItem(order: orders.items[idx]),
                        itemCount: orders.items.length,
                      ),
              );
            }
          }
        },
      ),
    );
  }
}
