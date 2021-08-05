import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as orderProvider;

class OrderItem extends StatefulWidget {
  final orderProvider.OrderItem order;

  const OrderItem({Key? key, required this.order}) : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("\$${widget.order.total.toStringAsFixed(2)}"),
            subtitle: Text(DateFormat('dd/MM/yyyy - hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () => setState(() => _expanded = !_expanded),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.linear,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: _expanded ? min(widget.order.cartItems.length * 20 + 30, 125) : 0,
            child: ListView.builder(
              itemBuilder: (ctx, idx) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.order.cartItems[idx].title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      '${widget.order.cartItems[idx].quantity}x \$${widget.order.cartItems[idx].price}',
                      style: TextStyle(fontSize: 18, color: Colors.black38),
                    )
                  ],
                );
              },
              itemCount: widget.order.cartItems.length,
            ),
          )
        ],
      ),
    );
  }
}
