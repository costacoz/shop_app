import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/products.dart';

import '../widgets/main_drawer.dart';
import '../widgets/user_product_item.dart';
import 'edit_product_screen.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user-products';

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  var future;

  Future<void> _refreshProducts(BuildContext ctx) async {
    await Provider.of<Products>(ctx, listen: false).fetchAndSetProducts(true);
  }

  @override
  void initState() {
    super.initState();
    future = _refreshProducts(context);
  }

  @override
  Widget build(BuildContext context) {
    // final Products products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.routeName),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Consumer<Products>(
                        builder: (_, products, staticChild) => ListView.builder(
                          itemBuilder: (_, idx) => Column(
                            children: [
                              UserProductItem(
                                id: products.items[idx].id,
                                title: products.items[idx].title,
                                imageUrl: products.items[idx].imageUrl,
                              ),
                              staticChild!
                            ],
                          ),
                          itemCount: products.items.length,
                        ),
                        child: Divider(),
                      ),
                    ),
                  ),
      ),
    );
  }
}
