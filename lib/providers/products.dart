import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _list = [
    // Product(
    //   id: "p1",
    //   title: "MacBook Pro",
    //   description: "Ajoyib MacBook",
    //   price: 2000,
    //   imageUrl:
    //       "https://images.pexels.com/photos/7974/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
    // ),
    // Product(
    //   id: "p2",
    //   title: "Iphone 14",
    //   description: "Ajoyib Iphone",
    //   price: 1500,
    //   imageUrl:
    //       "https://nypost.com/wp-content/uploads/sites/2/2022/08/iphone-14-leaked-images-comp.jpg?quality=75&strip=all",
    // ),
    // Product(
    //   id: "p3",
    //   title: "Apple Watch",
    //   description: "Ajoyib Apple Watch",
    //   price: 500,
    //   imageUrl:
    //       "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MQEE3_VW_PF+watch-49-titanium-ultra_VW_PF_WF_CO+watch-face-49-ocean-ultra_VW_PF_WF_CO_GEO_ES?wid=1400&hei=1400&trim=1%2C0&fmt=p-jpg&qlt=95&.v=1661191674381%2C1660927567672%2C1661371967510",
    // ),
  ];

  List<Product> get list {
    return [..._list];
  }

  List<Product> get favorites {
    return _list.where((product) => product.isFavorite).toList();
  }

  Future<void> getProductFromFirebase() async {
    final url = Uri.parse(
        "https://fir-online-shop-2140f-default-rtdb.firebaseio.com/products.json");

    try {
      final response = await http.get(url);
      if (jsonDecode(response.body) != null) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final List<Product> loadedProducts = [];
        data.forEach((productId, productData) {
          loadedProducts.add(Product(
            id: productId,
            title: productData["title"],
            description: productData["description"],
            price: productData["price"],
            imageUrl: productData["imageUrl"],
            isFavorite: productData["isFavorite"],
          ));
        });
        _list = loadedProducts;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  List<Product> _cartItems = [];

  List<Product> get cartItems {
    return [..._cartItems];
  }

  void addToCart(Product product) {
    _cartItems.add(product);
  }

  Future<void> addProduct(Product product) async {
    // http formulasi = Http endpoint (url) + http so'rovi = natija
    final url = Uri.parse(
        "https://fir-online-shop-2140f-default-rtdb.firebaseio.com/products.json");

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "image": product.imageUrl,
            "isFavorite": product.isFavorite,
          },
        ),
      );
      final name = (jsonDecode(response.body) as Map<String, dynamic>)["name"];
      final newProduct = Product(
        id: name,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _list.add(newProduct);
      //boshidan qo'shish uchun
      //_list.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final productIndex = _list.indexWhere(
      (product) => product.id == updatedProduct.id,
    );
    if (productIndex >= 0) {
      final url = Uri.parse(
          "https://fir-online-shop-2140f-default-rtdb.firebaseio.com/products/${updatedProduct.id}.json");
      try {
        await http.patch(
          url,
          body: jsonEncode(
            {
              "title": updatedProduct.title,
              "description": updatedProduct.description,
              "price": updatedProduct.price,
              "imageUrl": updatedProduct.imageUrl,
            },
          ),
        );
        _list[productIndex] = updatedProduct;
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        "https://fir-online-shop-2140f-default-rtdb.firebaseio.com/products/$id.json");

    try {
      await http.delete(url);
      _list.removeWhere((product) => product.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Product findById(String productId) {
    return _list.firstWhere((product) => product.id == productId);
  }
}
