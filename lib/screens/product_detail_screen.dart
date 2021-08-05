import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static final String routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final String productId = ModalRoute.of(context)!.settings.arguments as String;

    /// Use listen: false, to avoid rebuilding the widget when the Products model changes, as while on this screen
    /// we are not interested in updating this widget when something in Products model changes.
    /// In other words, selectedProduct will be initialized on build() invokation(s) once and won't be nor reinit-ed
    /// or invoke this widget's build method. Whereas with listen: true, it would invoke build() if something in
    /// Products model changes.
    /// Same with buttons, listen: false is needed to avoid placing model listeners with each click, so
    /// with buttons need to always use listen: false parameter.
    final selectedProduct = Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(selectedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true, // poigrat s etim
            flexibleSpace: FlexibleSpaceBar(
              title: Text(selectedProduct.title),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: selectedProduct.id,
                    child: Image.network(
                      selectedProduct.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(0, 0, 0, 1).withOpacity(0.4),
                          Color.fromRGBO(0, 0, 0, 1).withOpacity(0.1),
                          Color.fromRGBO(0, 0, 0, 0).withOpacity(0.0),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [0, 0.20, 0.25],
                      ),
                    ),
                    width: double.infinity,
                    height: 300,
                  )
                ],
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate.fixed([
            SizedBox(height: 10),
            Text(
              "\$${selectedProduct.price}",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 20),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                selectedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            SizedBox(height: 800),
          ]))
        ],
      ),
    );
  }
}
