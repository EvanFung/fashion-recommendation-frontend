import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/Product.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/file_meta.dart';

class EditProductPage extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedProduct = Product(
      id: null,
      title: '',
      price: 0,
      description: '',
      imageUrl: '',
      mainCategory: _mainCategoryValue,
      subCategory: _subCategoryValue);
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
    'mainCategory': 'Accessories',
    'subCategory': 'Watches'
  };
  var _isInit = true;
  var _isLoading = false;

  //dropdown menu variable
  List<String> _category = <String>[
    'Accessories',
    'Apparel',
    'Personal Care',
    'Footwear'
  ];
  List<List<String>> _subCategory = <List<String>>[
    [
      'Watches',
      'Socks',
      'Belts',
      'Bags',
      'Shoe Accessories',
      'Jewellery',
      'Wallets',
      'Accessories',
      'Eyewear',
      'Ties'
    ],
    [
      'Topwear',
      'Bottomwear',
      'Innerwear',
      'Loungewear and Nightwear',
      'Saree',
      'Dress'
    ],
    ['Fragrance', 'Lips', 'Skin Care', 'Makeup'],
    ['Shoes', 'Flip Flops', 'Sandal']
  ];
  static String _mainCategoryValue = 'Accessories';
  static String _subCategoryValue = 'Watches';
  int _mainCategoryIndex = 0;
  int _subCategoryIndex = 0;

  //upload image
  Future<File> _storedImage;
  bool isUploaded = false;
  //completed upload the file, we get the file id.
  FileMeta fileMeta;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;

      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
          'createBy': _editedProduct.createBy,
          'mainCategory': _editedProduct.mainCategory,
          'subCategory': _editedProduct.subCategory
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct, fileMeta);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: value,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            mainCategory: _editedProduct.mainCategory,
                            subCategory: _editedProduct.subCategory);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            price: double.parse(value),
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            mainCategory: _editedProduct.mainCategory,
                            subCategory: _editedProduct.subCategory);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: value,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            mainCategory: _editedProduct.mainCategory,
                            subCategory: _editedProduct.subCategory);
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Main Categories'),
                        DropdownButton(
                          isExpanded: false,
                          value: _mainCategoryValue,
                          onChanged: (String newValue) {
                            setState(() {
                              //avoid index out of bound when user select sub category first, then select main category
                              _subCategoryIndex = 0;
                              _mainCategoryValue = newValue;
                              _mainCategoryIndex = _category.indexOf(newValue);

                              //editProduct
                              _editedProduct = Product(
                                  title: _editedProduct.title,
                                  price: _editedProduct.price,
                                  description: _editedProduct.description,
                                  imageUrl: _editedProduct.imageUrl,
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  mainCategory: newValue,
                                  subCategory: _editedProduct.subCategory);
                            });
                          },
                          items: _category
                              .map<DropdownMenuItem<String>>(
                                  (String value) => DropdownMenuItem<String>(
                                        child: Text(value),
                                        value: value,
                                      ))
                              .toList(),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Sub Categories'),
                        DropdownButton(
                          value: _subCategory[_mainCategoryIndex]
                              [_subCategoryIndex],
                          onChanged: (String newValue) {
                            setState(() {
                              _subCategoryValue = newValue;
                              _subCategoryIndex =
                                  _subCategory[_mainCategoryIndex]
                                      .indexOf(newValue);
                              _editedProduct = Product(
                                  title: _editedProduct.title,
                                  price: _editedProduct.price,
                                  description: _editedProduct.description,
                                  imageUrl: _editedProduct.imageUrl,
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  mainCategory: _editedProduct.mainCategory,
                                  subCategory: newValue);
                            });
                          },
                          items: _subCategory[_mainCategoryIndex]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              child: Text(value),
                              value: value,
                            );
                          }).toList(),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FlatButton(
                              color: Theme.of(context).buttonColor,
                              child: Text('Choose Image'),
                              onPressed: _chooseImage,
                            ),
                            FlatButton(
                              color: Theme.of(context).buttonColor,
                              child: Text('Upload Image'),
                              onPressed: isUploaded ? null : _uploadImage,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        _showImage()
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _showImage() {
    return FutureBuilder<File>(
      future: _storedImage,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              child: Image.file(
                snapshot.data,
                fit: BoxFit.cover,
              ),
            ),
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  Future<void> _chooseImage() async {
    setState(() {
      _storedImage = ImagePicker.pickImage(source: ImageSource.gallery);
    });

    File file = await _storedImage;
    setState(() {
      _editedProduct = Product(
          title: _editedProduct.title,
          price: _editedProduct.price,
          description: _editedProduct.description,
          imageUrl: _editedProduct.imageUrl,
          id: _editedProduct.id,
          isFavorite: _editedProduct.isFavorite,
          mainCategory: _editedProduct.mainCategory,
          subCategory: _editedProduct.subCategory,
          image: file);
    });
  }

  Future<void> _uploadImage() async {
    File imageFile = await _storedImage;
    final fileName = await path.basename(imageFile.path);
    FileMeta uploadedFileMeta = await Provider.of<Products>(context)
        .updateUploadProductImage(
            imageFile, _editedProduct.id, _editedProduct, fileName);
    print('fileMeta 452 $uploadedFileMeta');
    if (uploadedFileMeta != null) {
      setState(() {
        isUploaded = true;
        fileMeta = uploadedFileMeta;
      });
    }
  }
}
