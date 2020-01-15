import 'package:flutter/material.dart';
import '../models/categories.dart';
import '../models/recipe.dart';
import '../widgets/ProductGrid.dart';
import '../widgets/badge.dart';
import '../providers/Cart.dart';
import '../providers/products.dart';
import './CartPage.dart';
import 'package:provider/provider.dart';
import '../providers/Product.dart';
import '../pages/ProductDetailPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/product_search.dart';
import '../widgets/logo.dart';

const double _kAppBarHeight = 128.0;
const double _kFabHalfSize = 28.0;
const double _kRecipePageMaxWidth = 500.0;

enum FilterOptions {
  Favorites,
  All,
  Rated,
}

class PestoStyle extends TextStyle {
  const PestoStyle({
    double fontSize = 12.0,
    FontWeight fontWeight,
    Color color = Colors.black87,
    double letterSpacing,
    double height,
  }) : super(
          inherit: false,
          color: color,
          fontFamily: 'Raleway',
          fontSize: fontSize,
          fontWeight: fontWeight,
          textBaseline: TextBaseline.alphabetic,
          letterSpacing: letterSpacing,
          height: height,
        );
}

final ThemeData _kTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.teal,
  accentColor: Colors.redAccent,
);

class ProductScreen extends StatelessWidget {
  static String routeName = 'Products';

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context).settings.arguments as String;

    return ProductGridScreen(
      recipes: kPestoRecipes,
      category: category,
    );
  }
}

class ProductGridScreen extends StatefulWidget {
  final List<Recipe> recipes;
  String category;
  ProductGridScreen({this.recipes, this.category});

  @override
  _ProductGridScreenState createState() => _ProductGridScreenState();
}

class _ProductGridScreenState extends State<ProductGridScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var _showFavoritesOnly = false;
  var _isInit = true;
  var _isLoading = false;
  var indexOfPage = 1;
  var _showRatedOnly = false;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    //CONTEXT INSIDE the initState wont work!!!!
    // TODO: implement initState
    super.initState();

    _scrollController.addListener(() {
      //if we are bottom of the page
      //only when show all products, we can infinite scroll products.
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_showRatedOnly &&
          widget.category == null) {
        print('scroll to bottom now.');

        fetchNextPageProduct(context);
      }
    });
  }

  @override
  void didChangeDependencies() {
    //it will run after the app fully operate.
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      if (widget.category != null) {
        Provider.of<Products>(context)
            .fetchAndSetProducts(false, widget.category)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      } else {
        //all product
        Provider.of<Products>(context).fetchAndSetProducts(false).then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      }

      Provider.of<Products>(context).fetchProductTitle().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController = null;
    super.dispose();
  }

  Future<void> fetchNextPageProduct(BuildContext context) async {
    setState(() {
      indexOfPage += 1;
    });
    await Provider.of<Products>(context).fetchProductByPage(indexOfPage);
  }

  // Future<void> fetchProducts(BuildContext context) async {
  //   await Provider.of<Products>(context).fetchAndSetProducts(false);
  // }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final productsData = Provider.of<Products>(context, listen: false);
    final products =
        _showFavoritesOnly ? productsData.favoriteItems : productsData.items;
    return Scaffold(
        key: scaffoldKey,
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : CustomScrollView(
                controller: _scrollController,
                semanticChildCount: products.length,
                slivers: <Widget>[
                  _buildAppBar(context, statusBarHeight, productsData),
                  _buildBody(
                      context, statusBarHeight, _showFavoritesOnly, products),
                ],
              ));
  }

  Widget _buildAppBar(
      BuildContext context, double statusBarHeight, Products productsData) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: _kAppBarHeight,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Search',
          onPressed: () {
            showSearch(
                context: context,
                delegate: ProductSearch(productsData.sourceKeyWords));
          },
        ),
        PopupMenuButton(
          onSelected: (FilterOptions selectedValue) {
            setState(() {
              if (selectedValue == FilterOptions.Favorites) {
                _showFavoritesOnly = true;
                _showRatedOnly = false;
              } else if (selectedValue == FilterOptions.All) {
                _showFavoritesOnly = false;
                _showRatedOnly = false;
                setState(() {
                  _isLoading = true;
                });
                Provider.of<Products>(context)
                    .fetchAndSetProducts(false)
                    .then((_) {
                  setState(() {
                    _isLoading = false;
                  });
                });
              } else if (selectedValue == FilterOptions.Rated) {
                _showRatedOnly = true;
                _showFavoritesOnly = false;
                Provider.of<Products>(context).getRatedProduct();
              }
            });
          },
          icon: Icon(Icons.more_vert),
          itemBuilder: (_) => [
            PopupMenuItem(
              child: Text('Only favorites'),
              value: FilterOptions.Favorites,
            ),
            PopupMenuItem(
              child: Text('All'),
              value: FilterOptions.All,
            ),
            PopupMenuItem(
              child: Text('Rated'),
              value: FilterOptions.Rated,
            ),
          ],
        ),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Size size = constraints.biggest;
          final double appBarHeight = size.height - statusBarHeight;
          final double t = (appBarHeight - kToolbarHeight) /
              (_kAppBarHeight - kToolbarHeight);
          final double extraPadding =
              Tween<double>(begin: 10.0, end: 24.0).transform(t);
          final double logoHeight = appBarHeight - 1.5 * extraPadding;
          return Padding(
            padding: EdgeInsets.only(
              top: statusBarHeight + 0.5 * extraPadding,
              bottom: extraPadding,
            ),
            child: Center(
              child: Logo(
                height: logoHeight,
                t: t.clamp(0.0, 1.0),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, double statusBarHeight,
      bool showFavoritesOnly, List<Product> products) {
    final EdgeInsets mediaPadding = MediaQuery.of(context).padding;
    final EdgeInsets padding = EdgeInsets.only(
        top: 8.0,
        left: 8.0 + mediaPadding.left,
        right: 8.0 + mediaPadding.right,
        bottom: 8.0);
    return SliverPadding(
      padding: padding,
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: _kRecipePageMaxWidth,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return ChangeNotifierProvider.value(
            value: products[index],
            child: ProductCard(),
          );
        }, childCount: products.length),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  TextStyle get titleStyle =>
      const PestoStyle(fontSize: 24.0, fontWeight: FontWeight.w600);
  TextStyle get authorStyle =>
      const PestoStyle(fontWeight: FontWeight.w500, color: Colors.black54);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailPage.routeName, arguments: product);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildProductImage(product),
                buildProductTitle(product)
              ],
            ),
            buildFavoriteButton(product),
            buildRatingNumber(context, product),
          ],
        ),
      ),
    );
  }

  ClipRRect buildProductImage(Product product) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
      child: Hero(
        tag: product.imageUrl,
        child: AspectRatio(
          aspectRatio: 4.0 / 3.0,
          child: CachedNetworkImage(
            imageUrl: product.imageUrl,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            imageBuilder: (BuildContext context, ImageProvider imageProvider) =>
                Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              )),
            ),
          ),
        ),
      ),
    );
  }

  Expanded buildProductTitle(Product product) {
    return Expanded(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  product.title,
                  style: titleStyle,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    product.description,
                    style: authorStyle,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Positioned buildRatingNumber(BuildContext context, Product product) {
    return Positioned(
      top: 6.0,
      left: 6.0,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.star,
                color: Theme.of(context).accentColor,
                size: 15,
              ),
              (product.rating / product.numOfRating).toString() == 'NaN'
                  ? Text('0')
                  : Text(
                      (product.rating / product.numOfRating).toStringAsFixed(2))
            ],
          ),
        ),
      ),
    );
  }

  Positioned buildFavoriteButton(Product product) {
    return Positioned(
      top: 6.0,
      right: 6.0,
      child: IconButton(
        color: Colors.red,
        icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
        onPressed: () {
          product.toggleFavoriteStatus();
        },
      ),
    );
  }
}
