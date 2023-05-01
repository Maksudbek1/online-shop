import 'package:flutter/material.dart';
// import 'package:online_magazin/models/cart_item.dart';
import 'package:online_magazin/models/product.dart';
import 'package:online_magazin/widgets/product_details_screen.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  // final String productId;
  // final String image;
  // final String title;

  const ProductItem({
    super.key,
    // required this.image,
    // required this.title,
    // required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black87,
          leading: IconButton(
            onPressed: () {
              product.toggleFavorite();
            },
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_outline,
              color: Theme.of(context).primaryColor,
            ),
          ),
          trailing: IconButton(
              onPressed: () {
                cart.addToCart(
                  product.id,
                  product.title,
                  product.imageUrl,
                  product.price,
                );
                // ScaffoldMessenger.of(context).showMaterialBanner(
                //   MaterialBanner(
                //     backgroundColor: Colors.grey,
                //     content: Text(
                //       "Savatchaga qo'shildi",
                //       style: TextStyle(color: Colors.white),
                //     ),
                //     actions: [
                //       TextButton(
                //         onPressed: () {
                //           cart.removeSingleItem(product.id, isCartButton: true);
                //           ScaffoldMessenger.of(context)
                //               .hideCurrentMaterialBanner();
                //         },
                //         child: const Text("Bekor qilish"),
                //       ),
                //     ],
                //   ),
                // );
                // Future.delayed(Duration(seconds: 2)).then(
                //   (value) =>
                //       ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                // );
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Savatchaga qo'shildi"),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: "Bekor qilish",
                      onPressed: () {
                        cart.removeSingleItem(product.id, isCartButton: true);
                      },
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).primaryColor,
              )),
        ),
      ),
    );
  }
}
