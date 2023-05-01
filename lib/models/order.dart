import 'package:online_magazin/models/cart_item.dart';

class Order {
  final String id;
  final double totalPrice;
  final DateTime date;
  final List<CartItem> products;

  Order({
    required this.id,
    required this.products,
    required this.date,
    required this.totalPrice,
  });
}
