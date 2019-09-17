import 'package:fashion/widgets/OrderItem.dart' as ord;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Orders.dart';

class OrderPage extends StatelessWidget {
  static final String routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (ctx, i) => ord.OrderItem(ordersData.orders[i]),
      ),
    );
  }
}
