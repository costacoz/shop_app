import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/cart.dart';
import 'package:shop_flutter_app/providers/products.dart';
import 'package:shop_flutter_app/widgets/badge.dart';
import 'package:shop_flutter_app/widgets/main_drawer.dart';

import '../widgets/products_grid.dart';
import 'cart_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/overview';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;
  bool _areProductsFetched = false;
  bool _isLoadingProducts = false;

  void setLoadingProducts(bool value) {
    setState(() {
      _isLoadingProducts = value;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_areProductsFetched) {
      setLoadingProducts(true);
      Provider.of<Products>(context, listen: false).fetchAndSetProducts().then((_) {
        setLoadingProducts(false);
      });

      _areProductsFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, Cart cart, ch) => Badge(
              child: ch as Widget,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () => Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
          )
        ],
      ),
      drawer: MainDrawer(),
      body: _isLoadingProducts ? Center(child: CircularProgressIndicator()) : ProductsGrid(_showOnlyFavorites),
    );
  }
}
