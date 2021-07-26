import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/product.dart';
import 'package:shop_flutter_app/providers/products.dart';

import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavorites;

  ProductsGrid(this.showOnlyFavorites);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    final productItems = showOnlyFavorites ? products.favoriteItems : products.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: productItems[index] as Product, // this line supplies ProductItem with a Product value.
          // Casting is only for demonstrative purpose!

          child: ProductItem(), // ProductItem will reach till first Provider class of type Product, which is line above
        );
      },
      itemCount: productItems.length,
    );
  }
}
