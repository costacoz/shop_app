import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/cart.dart';
import 'package:shop_flutter_app/providers/products.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: product.id),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            // Consumer also as Provider.of() goes up to the parent and takes value: products[index] as Product
            builder: (_, Product productWithListener, unbuildableChild) => IconButton(
              icon: Icon(productWithListener.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () => productWithListener.toggleFavorite(),
            ),
            child: SizedBox(), // this child will be inserted into the child of builder (unbuildableChild above).
            // It is intended to not be rebuild upon Provider model's (Product) changes - for optimization purposes.
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added item to cart!'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      CartItem undoedProduct = cart.removeSingleItem(product.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Undo done for ${undoedProduct.title}'))
                      );
                    },
                  ),
                ),
              );
            },
          ),
          backgroundColor: Color.fromRGBO(25, 25, 25, 0.6),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
