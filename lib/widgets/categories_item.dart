import 'package:flutter/material.dart';
import '../pages/product_screen.dart';

class CategoriesItem extends StatelessWidget {
  final String img;
  final String name;
  CategoriesItem(this.img, this.name);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(this.name);
        Navigator.of(context)
            .pushNamed(ProductScreen.routeName, arguments: this.name);
      },
      child: Padding(
        padding: EdgeInsets.only(right: 10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Stack(
            children: <Widget>[
              Image.asset(
                img,
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.height / 2,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    // Add one stop for each color. Stops should increase from 0 to 1
                    stops: [0.2, 0.7],
                    colors: [
                      Color.fromARGB(100, 0, 0, 0),
                      Color.fromARGB(100, 0, 0, 0),
                    ],
                    // stops: [0.0, 0.1],
                  ),
                ),
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.height / 2,
              ),
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.height / 2,
                  padding: EdgeInsets.all(1),
                  constraints: BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Center(
                    child: Text(
                      this.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
