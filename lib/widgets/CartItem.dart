import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final String productId;
  final int quantity;
  final String title;

  CartItem(this.id, this.price, this.quantity, this.title, this.productId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        print("deleted pressed");
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('\$${price}'),
              ),
              title: Text(title),
              subtitle: Text('Total \$${(price * quantity)}'),
              trailing: Text('$quantity x '),
            ),
          )),
    );
  }
}
