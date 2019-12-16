import 'package:fashion/pages/EditProductPage.dart';
import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          imageUrl,
        ),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductPage.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Are you sure?"),
                        content: Text(
                            "Do you want to remove the product from this product list?"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          FlatButton(
                            child: Text("Yes"),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                              Provider.of<Products>(context, listen: false)
                                  .deleteProduct(id);
                            },
                          )
                        ],
                      );
                    });
              },
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
