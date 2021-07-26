import 'package:flutter/material.dart';
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
          buildDrawerItem(context, Icons.list_alt, "Products", ProductsOverviewScreen.routeName),
          Divider(),
          buildDrawerItem(context, Icons.shopping_cart, "Cart", CartScreen.routeName),
          Divider(),
          buildDrawerItem(context, Icons.local_shipping, "Orders", OrdersScreen.routeName),
          Divider(),
          buildDrawerItem(context, Icons.business_center, "Your Products", UserProductsScreen.routeName),
        ],
      ),
    );
  }

  ListTile buildDrawerItem(BuildContext context, IconData icon, String label, String routeName) => ListTile(
    leading: Icon(icon, size: 26, color: Theme.of(context).primaryColor,),
    title: Text(
      label,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
    ),
    onTap: () => Navigator.of(context).pushReplacementNamed(routeName),
  );

  AppBar buildHeading(BuildContext context) => AppBar(
    title: Text('Shop navigation'),
    automaticallyImplyLeading: false,
  );
}
