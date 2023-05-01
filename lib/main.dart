import 'package:flutter/material.dart';
import 'package:online_magazin/providers/cart.dart';
import 'package:online_magazin/providers/orders.dart';
import 'package:online_magazin/providers/products.dart';
import 'package:online_magazin/screens/edit_product_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/manage_product_screen.dart';
import '../screens/orders_screen.dart';
import 'package:online_magazin/styles/my_shop_style.dart';
import 'package:online_magazin/widgets/product_details_screen.dart';
import 'package:provider/provider.dart';

import './screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  ThemeData theme = MyShopStyle.theme;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Products>(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider<Cart>(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider<Orders>(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mening Do\'konim',
        theme: theme,
        initialRoute: HomeScreen.routeName,
        routes: {
          ProductDetailsScreen.routeName: (context) => ProductDetailsScreen(),
          CartScreen.routeName: (context) => CartScreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
          OrdersScreen.routeName: (context) => OrdersScreen(),
          ManageProductScreen.routeName: (context) => ManageProductScreen(),
          EditProductScreen.routeName: (context) => EditProductScreen(),
        },
      ),
    );
  }
}
