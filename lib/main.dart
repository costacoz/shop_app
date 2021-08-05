import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/auth.dart';
import 'package:shop_flutter_app/screens/auth_screen.dart';
import 'package:shop_flutter_app/screens/splash_screen.dart';

import '/screens/orders_screen.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'providers/products.dart';
import 'screens/cart_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/products_overview_screen.dart';
import 'screens/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (_, auth, previousProducts) => Products(auth.token, auth.userId, previousProducts?.items ?? []),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (_, auth, previousOrders) => Orders(auth.token, auth.userId, previousOrders?.items ?? []),
        ),
        ChangeNotifierProvider(create: (_) => Cart()),
      ],
      child: Consumer<Auth>(
        builder: (_, auth, __) => MaterialApp(
          title: 'Shop app',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          // home: auth.isAuthenticated ? ProductsOverviewScreen() : AuthScreen(),
          onGenerateRoute: (routeSettings) {
            print('routeSettings: $routeSettings');
          },
          routes: {
            '/': (_) => auth.isAuthenticated
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoSignin(),
                    builder: (ctx, dataSnapshot) {
                      if (dataSnapshot.connectionState == ConnectionState.waiting) {
                        return SplashScreen();
                      } else {
                        if (dataSnapshot.hasError) {
                          print(dataSnapshot.error);
                        }
                        return AuthScreen();
                      }
                    },
                  ),
            ProductsOverviewScreen.routeName: (_) => ProductsOverviewScreen(),
            OrdersScreen.routeName: (_) => OrdersScreen(),
            ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
            CartScreen.routeName: (_) => CartScreen(),
            UserProductsScreen.routeName: (_) => UserProductsScreen(),
            EditProductScreen.routeName: (_) => EditProductScreen(),
            AuthScreen.routeName: (_) => AuthScreen(),
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: Center(
        child: Text('Shop!'),
      ),
    );
  }
}
