import 'package:flutter/material.dart';
import 'package:online_magazin/screens/cart_screen.dart';
import 'package:online_magazin/widgets/app_drawer.dart';
import 'package:online_magazin/widgets/custom_cart.dart';
import 'package:online_magazin/widgets/product_item.dart';
import 'package:online_magazin/widgets/products_grid.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

enum FiltersOption {
  Favorites,
  All,
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  static const routeName = "/homeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [];
  var _showOnlyFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Mening do'konim"),
        actions: [
          PopupMenuButton(
            onSelected: (FiltersOption filter) {
              setState(() {
                if (filter == FiltersOption.All) {
                  //barchasini kursat
                  _showOnlyFavorite = false;
                } else {
                  // sevimlilarni kursat
                  _showOnlyFavorite = true;
                }
              });
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  child: Text("Barchasi"),
                  value: FiltersOption.All,
                ),
                PopupMenuItem(
                  child: Text("Sevimli"),
                  value: FiltersOption.Favorites,
                ),
              ];
            },
          ),
          Consumer<Cart>(
            builder: (context, cart, child) {
              return CustomCart(
                child: child!,
                number: cart.itemsCount().toString(),
              );
            },
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavorite),
    );
  }
}
