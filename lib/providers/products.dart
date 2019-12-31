import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:leancloud_flutter_plugin/leancloud_flutter_plugin.dart';
import './Product.dart';
import '../models/http_exception.dart';
import '../models/MyAVObject.dart';
import 'dart:io';
import '../models/file_meta.dart';

class Products with ChangeNotifier {
  Map<String, String> imgHeaders = {
    "X-LC-Id": "WWVO3d7KG8fUpPvTY9mt1OT5-gzGzoHsz",
    "X-LC-Key": "2nDU7yqQoMpsGMTFbWYTdxgG",
    "Content-Type": "image/jpg"
  };
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;
  final String userId;
  Products(this.authToken, this._items, this.userId);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts([bool filterByUser]) async {
    AVQuery queryProduct = AVQuery("Product");
    try {
      var response;
      if (filterByUser) {
        response =
            await queryProduct.whereEqualTo('createBy', this.userId).find();
      } else {
        response = await queryProduct.find();
      }

      List<AVObject> products = response.toList();
      final List<Product> loadedProducts = [];
      products.forEach((prod) {
        loadedProducts.add(
          Product(
              id: prod.get("objectId"),
              title: prod.get("title"),
              description: prod.get("description"),
              price: prod.get("price"),
              imageUrl: prod.get("imageUrl"),
              createBy: this.userId,
              rating: prod.get('rating'),
              numOfRating: prod.get('numOfRating')),
        );
      });
      _items = loadedProducts;
      print('fetching products...');
      notifyListeners();

      //TEST UPDATE
      // AVObject o3 = AVObject("Product");
      // o3.put("objectId", "5df7ed5f21b47e00755b6a6e");
      // o3.put("title", "JJ");

      // await o3.save();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product, FileMeta fileMeta) async {
    print('userId is $userId');
    //https://fashion-rec-sys.firebaseio.com/
    AVObject object = new AVObject("Product");
    object.put("title", product.title);
    object.put("description", product.description);
    object.put("price", product.price);
    object.put("imageUrl", fileMeta.url);
    object.put('createBy', this.userId);
    object.put('mainCategory', product.mainCategory);
    object.put('subCategory', product.subCategory);
    object.put('numOfRating', 0);
    object.put('rating', 0);

    try {
      final response = await object.save();
      print(response.toString());
      String productStr = json.decode(response.toString())['fields'];
      String productId = json.decode(productStr)['objectId'];
      final newProduct = Product(
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          id: productId,
          createBy: product.createBy,
          rating: 0.0,
          numOfRating: 0);
      _items.add(newProduct);
      notifyListeners();
      if (productId != null && fileMeta != null) {
        print(fileMeta.objectId);
        print(productId);
        //attach file to the product.
        var url =
            'https://wwvo3d7k.lc-cn-n1-shared.com/1.1/classes/Product/$productId';
        final responseFile = await http.put(url,
            headers: {
              "X-LC-Id": "WWVO3d7KG8fUpPvTY9mt1OT5-gzGzoHsz",
              "X-LC-Key": "2nDU7yqQoMpsGMTFbWYTdxgG",
              "Content-Type": "application/json",
            },
            body: json.encode({
              'profilePic': {'id': fileMeta.objectId, '__type': 'File'}
            }));
        print(responseFile.body);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url = 'https://5peu6yst.lc-cn-n1-shared.com/1.1/classes/Product/$id';
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      // await http.put(url,
      //     headers: {
      //       "X-LC-Id": "5pEU6YStYoYHjxJlibN6ag7d-gzGzoHsz",
      //       "X-LC-Key": "wmGw6rwPS8oquig1csmyzbUl",
      //       "Content-Type": "application/json"
      //     },
      //     body: json.encode({
      //       'title': newProduct.title,
      //       'description': newProduct.description,
      //       'imageUrl': newProduct.imageUrl,
      //       'price': newProduct.price
      //     }));
      AVObject prod = AVObject("Product");
      prod.put("objectId", id);
      prod.put(
        "title",
        newProduct.title,
      );
      prod.put("description", newProduct.description);
      prod.put("imageUrl", newProduct.imageUrl);
      prod.put("price", newProduct.price);
      prod.put('mainCategory', newProduct.mainCategory);
      prod.put('subCategory', newProduct.subCategory);
      final response = await prod.save();
      print(response);
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('....');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://wwvo3d7k.lc-cn-n1-shared.com/1.1/classes/Product/$id';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(
      url,
      headers: {
        "X-LC-Id": "WWVO3d7KG8fUpPvTY9mt1OT5-gzGzoHsz",
        "X-LC-Key": "2nDU7yqQoMpsGMTFbWYTdxgG",
        "Content-Type": "application/json"
      },
    );
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

//return the file id
  Future<FileMeta> updateUploadProductImage(
      File image, String productId, Product newProduct, String fileName) async {
    //update the provider product.
    int prodIndex = _items.indexWhere((prod) => prod.id == productId);
    //product was found
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
    }
    notifyListeners();

    //upload file to server and attach this file to the corresponding product object.

    var url = 'https://wwvo3d7k.lc-cn-n1-shared.com/1.1/files/$fileName';
    final response = await http.post(url,
        headers: imgHeaders, body: image.readAsBytesSync());
    Map<String, dynamic> fileData =
        json.decode(response.body) as Map<String, dynamic>;
    String fileId = fileData['objectId'];
    if (productId != null) {
      url =
          'https://wwvo3d7k.lc-cn-n1-shared.com/1.1/classes/Product/$productId';
      final responseOnUpdate = await http.put(url,
          headers: {
            "X-LC-Id": "WWVO3d7KG8fUpPvTY9mt1OT5-gzGzoHsz",
            "X-LC-Key": "2nDU7yqQoMpsGMTFbWYTdxgG",
            "Content-Type": "application/json",
          },
          body: json.encode({
            'profilePic': {'id': fileId, '__type': 'File'}
          }));
    }
    return FileMeta(
        url: fileData['url'],
        name: fileData['name'],
        objectId: fileData['objectId']);
  }
}
