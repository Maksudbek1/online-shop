import 'package:flutter/material.dart';
import 'package:online_magazin/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({super.key});

  void _notifyUserAboutDelete(BuildContext context, Function() removeItem) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Ishonchingiz komilmi?"),
            content: Text("Bu mahsulot o'chmoqda"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "Bekor qilish",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  removeItem();
                  Navigator.of(context).pop();
                },
                child: const Text("O'chirish"),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).errorColor,
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    return Card(
        child: ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName,
                  arguments: product.id);
            },
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
          ),
          IconButton(
            onPressed: () {
              _notifyUserAboutDelete(context, () {
                Provider.of<Products>(context, listen: false)
                    .deleteProduct(product.id);
              });
            },
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).errorColor,
            ),
          ),
        ],
      ),
    ));
  }
}
