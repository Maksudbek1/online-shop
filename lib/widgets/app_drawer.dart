import 'package:flutter/material.dart';
import 'package:online_magazin/screens/home_screen.dart';
import 'package:online_magazin/screens/manage_product_screen.dart';
import 'package:online_magazin/screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text("Salom do'stim"),
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text("Magazin"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(HomeScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text("Buyurtmalar"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Mahsulotlarni boshqarish"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ManageProductScreen.routeName),
          ),
        ],
      ),
    );
  }
}
