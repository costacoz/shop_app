import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/auth.dart';
import '../screens/cart_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/products_overview_screen.dart';
import '../screens/user_products_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          buildHeading(context),
          buildDrawerItem(context, Icons.list_alt, "Products", routeName: ProductsOverviewScreen.routeName),
          Divider(),
          buildDrawerItem(context, Icons.shopping_cart, "Cart", routeName: CartScreen.routeName),
          Divider(),
          buildDrawerItem(context, Icons.local_shipping, "Orders", routeName: OrdersScreen.routeName),
          Divider(),
          buildDrawerItem(context, Icons.business_center, "Your Products", routeName: UserProductsScreen.routeName),
          Divider(),
          buildDrawerItem(context, Icons.exit_to_app, "Logout", func: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Auth>(context, listen: false).logout();
          }),
        ],
      ),
    );
  }

  ListTile buildDrawerItem(BuildContext context, IconData icon, String label, {String? routeName, Function? func}) => ListTile(
    leading: Icon(icon, size: 26, color: Theme.of(context).primaryColor,),
    title: Text(
      label,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
    ),
    onTap: () =>
    routeName != null ?
        Navigator.of(context).pushReplacementNamed(routeName)
        :
    func != null ? func() : null
    ,
  );

  AppBar buildHeading(BuildContext context) => AppBar(
    title: Text('Shop navigation'),
    automaticallyImplyLeading: false,
  );
}
