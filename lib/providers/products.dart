import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:leancloud_flutter_plugin/leancloud_flutter_plugin.dart';
import './Product.dart';
import '../models/http_exception.dart';
import '../models/MyAVObject.dart';
import 'dart:io';
import '../models/file_meta.dart';
import '../utils/image_utils.dart';

class Products with ChangeNotifier {
  Map<String, String> imgHeaders = {
    "X-LC-Id": "WWVO3d7KG8fUpPvTY9mt1OT5-gzGzoHsz",
    "X-LC-Key": "2nDU7yqQoMpsGMTFbWYTdxgG",
    "Content-Type": "image/jpg"
  };
  Set<String> _sourceKeyWords = Set();
  List<Product> _items = [];
  List<Product> _trendingProducts = [];
  List<Product> _recommendProducts = [];

  final String authToken;
  final String userId;
  final String uId;

  Products(this.authToken, this._items, this.userId, this.uId);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get trendingProducts {
    return [..._trendingProducts];
  }

  Set<String> get sourceKeyWords {
    return _sourceKeyWords;
  }

  List<Product> get recommendProducts {
    return [..._recommendProducts];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  List<Product> get ratedItems {
    return _items.where((product) => product.isRated).toList();
  }

  Future<void> fetchAndSetProducts([bool filterByUser, String category]) async {
    AVQuery queryProduct = AVQuery("Product");
    try {
      var response;
      if (filterByUser) {
        response = await queryProduct
            .whereEqualTo('createBy', this.userId)
            .limit(10)
            .find();
      } else if (category != null) {
        response = await queryProduct
            .whereEqualTo('subCategory', category)
            .limit(10)
            .find();
      } else {
        response = await queryProduct.limit(10).find();
      }
      final List<Product> loadedProducts = [];
      List<AVObject> products = response.toList();
      products.forEach((prod) {
        loadedProducts.add(
          Product(
            id: prod.get("objectId"),
            title: prod.get("title"),
            description: prod.get("description"),
            price: prod.get("price"),
            imageUrl: prod.get("imageUrl"),
            createBy: this.userId,
            rating: double.parse(prod.get('rating').toString()),
            numOfRating: double.parse(prod.get('numOfRating').toString()),
            pId: prod.get('pId').toString(),
            mainCategory: prod.get('mainCategory'),
            subCategory: prod.get('subCategory'),
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
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
    object.put('numOfRating', 0.0);
    object.put('rating', 0.0);

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
          rating: 0,
          numOfRating: 0);
      _items.add(newProduct);
      notifyListeners();
      if (productId != null && fileMeta != null) {
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
    //compress the images
    File compressedImage = await EImageUtils(image).compress(
      quality: 60,
    );
    File resizedImage = await EImageUtils(compressedImage).resize(width: 512);
    //upload file to server and attach this file to the corresponding product object.

    var url = 'https://wwvo3d7k.lc-cn-n1-shared.com/1.1/files/$fileName';
    final response = await http.post(url,
        headers: imgHeaders, body: resizedImage.readAsBytesSync());
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

  Future<void> fetchProductByPage(int page) async {
    print('pages = $page');
    AVQuery query = AVQuery('Product');
    var response = await query
        .limit(10)
        .skip(10 * page)
        .orderByDescending('createAt')
        .find();

    List<AVObject> products = response.toList();
    final List<Product> loadedProducts = [];
    products.forEach((prod) {
      loadedProducts.add(Product(
        id: prod.get("objectId"),
        title: prod.get("title"),
        description: prod.get("description"),
        price: prod.get("price"),
        imageUrl: prod.get("imageUrl"),
        createBy: this.userId,
        rating: double.parse(prod.get('rating').toString()),
        numOfRating: double.parse(prod.get('numOfRating').toString()),
        pId: prod.get('pId').toString(),
        mainCategory: prod.get('mainCategory'),
        subCategory: prod.get('subCategory'),
      ));
    });
    _items.addAll(loadedProducts);
    notifyListeners();
  }

  // fetch all products title and article type for user seaching keyword...
  Future<void> fetchProductTitle() async {
    //adding title to the source keywords list
    //adding article type to the source keywords list
    AVQuery query = AVQuery('Product');
    var response = await query.limit(1000).find();
    List<AVObject> products = response.toList();
    Set<String> keywords = Set();
    products.forEach((prod) {
      keywords.add(prod.get('title'));
    });
    _sourceKeyWords = keywords;
    notifyListeners();
  }

  //when user select source keyword, return a products object.
  Future<Product> searchByTitle(String title) async {
    AVQuery query = AVQuery('Product');
    var response = await query.whereEqualTo('title', title).find();
    List<AVObject> products = response.toList();
    //if found
    if (products.length > 0) {
      AVObject prod = products[0];
      return Product(
        id: prod.get("objectId"),
        title: prod.get("title"),
        description: prod.get("description"),
        price: prod.get("price"),
        imageUrl: prod.get("imageUrl"),
        createBy: this.userId,
        rating: double.parse(prod.get('rating').toString()),
        numOfRating: double.parse(prod.get('numOfRating').toString()),
        pId: prod.get('pId').toString(),
        mainCategory: prod.get('mainCategory'),
        subCategory: prod.get('subCategory'),
      );
    } else {
      return null;
    }
  }

  Future<List<String>> fetchProductTitleByQuery(String query) async {
    var searchCondition =
        'where={"title":{"\$regex":"$query","\$options":"i"}}';
    var url = 'https://wwvo3d7k.lc-cn-n1-shared.com/1.1/classes/Product?' +
        searchCondition;
    var uri = Uri.encodeFull(url);
    final response = await http.get(uri, headers: {
      "X-LC-Id": "WWVO3d7KG8fUpPvTY9mt1OT5-gzGzoHsz",
      "X-LC-Key": "2nDU7yqQoMpsGMTFbWYTdxgG",
      "Content-Type": "application/json",
    });
    final responseResult = json.decode(response.body) as Map<String, dynamic>;
    List results = responseResult['results'] as List<dynamic>;

    //keyword container
    List<String> keywords = List();

    results.forEach((prod) {
      Map<String, dynamic> p = prod as Map<String, dynamic>;
      //add title to keywords set
      keywords.add(p['title']);
    });

    return keywords;
  }

  Future<void> getRatedProduct() async {
    AVQuery queryRating = AVQuery('Rating');
    AVQuery queryProduct = AVQuery('Product');
    List<AVObject> ratings =
        await queryRating.whereEqualTo('uId', this.uId).find();
    List<AVObject> products = await queryProduct.limit(1000).find();
    List<Product> loadedProducts = [];

    if (ratings.length > 0) {
      List<String> pIds = List();
      ratings.forEach((rating) {
        pIds.add(rating.get('pId'));
      });

      pIds.forEach((pId) {
        AVObject p =
            products.firstWhere((prod) => prod.get('pId').toString() == pId);
        loadedProducts.add(Product(
          id: p.get("objectId"),
          title: p.get("title"),
          description: p.get("description"),
          price: p.get("price"),
          imageUrl: p.get("imageUrl"),
          createBy: this.userId,
          rating: double.parse(p.get('rating').toString()),
          numOfRating: double.parse(p.get('numOfRating').toString()),
          pId: p.get('pId').toString(),
          mainCategory: p.get('mainCategory'),
          subCategory: p.get('subCategory'),
        ));
      });

      _items = loadedProducts;
      notifyListeners();
    } else {
      return null;
    }
  }

  Future<void> getTrendingProduct() async {
    AVQuery query = AVQuery('Product');
    List<Product> loadedProducts = [];
    //get the most ratted products
    List<AVObject> products =
        await query.orderByDescending('numOfRating').find();
    if (products.length > 10) {
      products.sort(
          (prodA, prodB) => prodB.get('rating').compareTo(prodA.get('rating')));
      for (int i = 0; i < 10; i++) {
        loadedProducts.add(Product(
          id: products[i].get("objectId"),
          title: products[i].get("title"),
          description: products[i].get("description"),
          price: products[i].get("price"),
          imageUrl: products[i].get("imageUrl"),
          createBy: this.userId,
          rating: double.parse(products[i].get('rating').toString()),
          numOfRating: double.parse(products[i].get('numOfRating').toString()),
          pId: products[i].get('pId').toString(),
          mainCategory: products[i].get('mainCategory'),
          subCategory: products[i].get('subCategory'),
        ));
      }
      _trendingProducts = loadedProducts;
      notifyListeners();
    }
  }

  Future<void> getRecommendProduct() async {
    const url = 'http://wwvo3d7kkogq.leanapp.cn/';
    final response = await http.get(url + 'rec/$uId');
    if (json.decode(response.body)['response'] != null &&
        json.decode(response.body)['response'] == 'NO RECOMMEND ITEM') {
      _recommendProducts = _trendingProducts;
      notifyListeners();
      return;
    }

    List<dynamic> responsedData =
        json.decode(response.body)['products'] as List<dynamic>;
    List<Product> loadedProduct = [];
    responsedData.forEach((prod) {
      Map<String, dynamic> p = json.decode(prod) as Map<String, dynamic>;
      loadedProduct.add(Product(
        id: p['objectId'],
        title: p['title'],
        description: p['description'],
        price: p['price'],
        imageUrl: p['imageUrl'],
        createBy: p['createBy'],
        rating: double.parse(p['rating'].toString()),
        numOfRating: double.parse(p['numOfRating'].toString()),
        pId: p['pId'].toString(),
        mainCategory: p['mainCategory'],
        subCategory: p['subCategory'],
      ));
    });
    _recommendProducts = loadedProduct;
    notifyListeners();
  }

  Future<Product> getProductById(String id) async {
    AVQuery query = AVQuery('Product');
    var response = await query.whereEqualTo('pId', int.parse(id)).find();
    List<AVObject> products = response.toList();
    return Product(
      id: products[0].get('objectId'),
      title: products[0].get('title'),
      description: products[0].get('description'),
      price: products[0].get('price'),
      imageUrl: products[0].get('imageUrl'),
      createBy: products[0].get('createBy'),
      rating: double.parse(products[0].get('rating').toString()),
      numOfRating: double.parse(products[0].get('numOfRating').toString()),
      pId: products[0].get('pId').toString(),
      mainCategory: products[0].get('mainCategory'),
      subCategory: products[0].get('subCategory'),
    );
  }
}
