import 'package:flutter/widgets.dart';
import 'package:online_magazin/models/order.dart';

import '../models/cart_item.dart';

class Orders with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  void addToOrders(List<CartItem> products, double totalPrice) {
    _items.insert(
      0,
      Order(
          id: UniqueKey().toString(),
          products: products,
          date: DateTime.now(),
          totalPrice: totalPrice),
    );
    notifyListeners();
  }
}
