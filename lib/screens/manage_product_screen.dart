import 'package:flutter/material.dart';
import 'package:online_magazin/screens/edit_product_screen.dart';
import 'package:online_magazin/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';

class ManageProductScreen extends StatelessWidget {
  const ManageProductScreen({super.key});

  static const routeName = "/manage-products";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context).getProductFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Mahsulotlarni boshqarish"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: productProvider.list.length,
          itemBuilder: ((context, index) {
            final product = productProvider.list[index];
            return ChangeNotifierProvider.value(
              value: product,
              child: const UserProductItem(),
            );
          }),
        ),
      ),
    );
  }
}
