import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_magazin/models/cart_item.dart';

import '../models/order.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({
    super.key,
    required this.totalPrice,
    required this.date,
    required this.products,
  });

  final double totalPrice;
  final DateTime date;
  final List<CartItem> products;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expandItem = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.totalPrice}'),
            subtitle: Text(
              DateFormat("dd/MM/yy hh:mm").format(widget.date),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expandItem = !_expandItem;
                });
              },
              icon: Icon(_expandItem ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          if (_expandItem)
            Container(
              padding: EdgeInsets.all(5),
              height: min(widget.products.length * 20 + 50, 100),
              child: ListView.builder(
                itemExtent: 30,
                itemCount: widget.products.length,
                itemBuilder: (context, index) {
                  final product = widget.products[index];
                  return ListTile(
                    title: Text(product.title),
                    trailing: Text(
                      "${product.quantity} x \$${product.price}",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}
