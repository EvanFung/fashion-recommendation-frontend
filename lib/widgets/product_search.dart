import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Product.dart';
import '../providers/products.dart';
import '../pages/ProductDetailPage.dart';

class ProductSearch extends SearchDelegate {
  final Set<String> sourceList;
  final List<Product> products;

  ProductSearch(this.sourceList, this.products);
  String searchHint = "Search fashion items...";

  var suggestList = [
    "Formal",
    "Wallets",
    "Trousers",
    "Handbags",
    "Shirts",
    "Casual",
    "Tshirt"
  ];
  @override
  String get searchFieldLabel => searchHint;

  @override
  List<Widget> buildActions(BuildContext context) {
    ///显示在最右边的控件列表
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";

          ///搜索建议的内容
          showSuggestions(context);
        },
      ),
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () => query = "",
      )
    ];
  }

  ///左侧带动画的控件，一般都是返回
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),

      ///调用 close 关闭 search 界面
      onPressed: () => close(context, null),
    );
  }

  ///展示搜索结果
  @override
  Widget buildResults(BuildContext context) {
    List<String> result = List();

    ///模拟搜索过程
    for (var str in sourceList) {
      ///query 就是输入框的 TextEditingController
      if (query.isNotEmpty && str.toLowerCase().contains(query.toLowerCase())) {
        result.add(str);
      }
    }

    ///展示搜索结果
    return ListView.builder(
      itemCount: result.length,
      itemBuilder: (BuildContext context, int index) => ListTile(
        title: Text(result[index]),
        onTap: () async {
          Product product =
              await Provider.of<Products>(context).searchByTitle(result[index]);
          if (product != null) {
            print(product.title);
            Navigator.of(context)
                .pushNamed(ProductDetailPage.routeName, arguments: product);
          }
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggest = query.isEmpty
        ? suggestList
        : sourceList.where((input) => input.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggest.length,
      itemBuilder: (BuildContext context, int index) => InkWell(
        child: ListTile(
          title: RichText(
            text: TextSpan(
              text: suggest[index].substring(0, query.length),
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: suggest[index].substring(query.length),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          searchHint = "";
          query = suggest[index].toString();
          showResults(context);
        },
      ),
    );
  }
}
